////  Combination.m//  KillerSudoku////  Created by 李泳 on 14/11/18.//  Copyright (c) 2014年 yongli1992. All rights reserved.//#import "Combination.h"@interface Combination()@property(nonatomic, strong)NSMutableDictionary* combination;@end@implementation Combinationstatic Combination* sharedCombination = nil;-(id)init {    self = [super init];        // Singleton implementation    if (sharedCombination != nil) {        return sharedCombination;    }    //    NSTimeInterval startTime = [[NSDate date] timeIntervalSinceReferenceDate];        self.combination = [[NSMutableDictionary alloc] init];        NSString* filePath = [[NSBundle mainBundle] pathForResource:@"combination" ofType:@"txt"];    NSString* str = [[NSString alloc] initWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];        NSArray* strParts = [str componentsSeparatedByString:@"#"];    // Level 1: Iterate all combination sizes    for (NSString* part in strParts) {        // Get the size of combinations        NSNumber* cellNumber = [NSNumber numberWithInteger:[[part substringToIndex:1] integerValue]];        NSMutableDictionary* sumDict = [[NSMutableDictionary alloc] init];                // Level 2: Iterate all the sums that may appear at this size value, represented by each line            // Relate each sum to a set of all possible combinations, store in a dict: sumDict        [[part substringFromIndex:2] enumerateLinesUsingBlock:^(NSString* line, BOOL *stop){            // Get the size            NSNumber* sum = [NSNumber numberWithInteger:[[line substringToIndex:2] integerValue]];            NSMutableArray* combSet = [[NSMutableArray alloc] init];                        // Level 3: Iterate all possible combinations that add up to this particular sum, which of of this particular size                // Store all possible combinations in the set: combSet            NSArray* combArray = [line componentsSeparatedByString:@" "];            for (int i = 1; i < [combArray count]; i++) {                // Get the string representation of this combination                NSString* combStr = [combArray objectAtIndex:i];                NSMutableArray* comb = [[NSMutableArray alloc] init];                // Level 4: Iterate each number in this particular combination, store them in the set: comb                for (int j = 0; j < [combStr length]; j++) {                    NSString* ch = [combStr substringWithRange:NSMakeRange(j, 1)];                    NSNumber* num = [NSNumber numberWithInteger:[ch integerValue]];                    [comb addObject:num];                }                // With a certain number of cells and a cetain sum, add a new possible combination into its combSet                [combSet addObject:comb];            }            // Now with a certain number of cells and a certain sum, all its possible combinations are stored in combSet            [sumDict setObject:combSet forKey:sum];        }];                [self.combination setObject:sumDict forKey:cellNumber];    }    //    NSTimeInterval endTime = [[NSDate date] timeIntervalSinceReferenceDate];//    double elapsedTime = endTime - startTime;//    //NSLog(@"time: %f", elapsedTime);        // Singleton implementation    sharedCombination = self;    return self;}- (Combination*)copy {    Combination* newComb = [Combination alloc];    newComb.combination = self.combination;    return newComb;}- (NSArray*)allComsOfCageSize:(NSNumber*)size withSum:(NSNumber*)sum {    NSArray* combinations = [[self.combination objectForKey:size] objectForKey:sum];    return  combinations;}/*! * Return an array of candidate numbers in a cage with given size and sum */- (NSArray*)allNumsOfCageSize:(NSNumber*)size withSum:(NSNumber*)sum {    NSMutableArray* candidates = [[NSMutableArray alloc] init];    for (NSArray* combination in [self allComsOfCageSize:size withSum:sum]) {        for (NSNumber* num in combination) {            if (![candidates containsObject:num]) {                [candidates addObject:num];                if ([candidates count] == 9) {                    return candidates;                }            }        }    }        return candidates;}- (NSDictionary*)probabilityDistributionOfCageSize:(NSNumber*)size withSum:(NSNumber*)sum {    int count[10] = {0};    NSMutableDictionary* prob = [[NSMutableDictionary alloc] init];        for (NSArray* combination in [self allComsOfCageSize:size withSum:sum]) {        for (NSNumber* num in combination) {            count[[num intValue]]++;        }    }        float total = (float)[[self allComsOfCageSize:size withSum:sum] count];    for (int i = 1; i < 10; i++) {        float probility = count[i] / total;        NSNumber* p = [NSNumber numberWithFloat:probility];        [prob setObject:p forKey:[NSNumber numberWithInt:i]];    }        return prob;}@end