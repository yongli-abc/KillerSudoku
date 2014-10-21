//
//  GameBoard.m
//  KillerSudoku
//
//  Created by 李泳 on 14-10-14.
//  Copyright (c) 2014年 yongli1992. All rights reserved.
//

#import "GameBoard.h"

@interface GameBoard()

@property(nonatomic, strong)NSMutableArray* cells;

@end

@implementation GameBoard

-(id)initWithCells:(NSArray*)cells {
    self = [super init];
    self.cells = [[NSMutableArray alloc] init];

    for (NSArray* row in cells) {
        NSMutableArray* new_row = [[NSMutableArray alloc] init];
        for (NSNumber* num in row) {
            [new_row addObject:[NSNumber numberWithInt:[num intValue]]];
        }
        [self.cells addObject:new_row];
    }
    
    return self;
}

-(id)initWithIntegerArray:(int[9][9])array {
    self = [super init];
    self.cells = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < 9; i++) {
        NSMutableArray* newRow = [[NSMutableArray alloc] init];
        for (int j = 0; j < 9; j++) {
            [newRow addObject:[NSNumber numberWithInt:array[i][j]]];
        }
        [self.cells addObject:newRow];
    }
    
    return self;
}

-(NSNumber*)getNumAtRow:(NSInteger)row Column:(NSInteger)col {
    return [[self.cells objectAtIndex:row] objectAtIndex:col];
    
}

-(void)setNum:(NSNumber*)number AtRow:(NSInteger)row Column:(NSInteger)col {
    [[self.cells objectAtIndex:row] replaceObjectAtIndex:col withObject:number];
}

-(Boolean)isFinished {
    // Build an array containing all the possible values 1 ~ 9
    NSMutableArray* values = [[NSMutableArray alloc] init];
    for (int i = 1; i < 10; i++) {
        [values addObject:[NSNumber numberWithInt:i]];
    }
    
    // Check each row
    for (NSMutableArray* row in self.cells) {
        for (NSNumber* number in values) {
            if([row containsObject:number] == false) {
                return false;
            }
        }
    }
    
    // Check each column
    for (int j = 0; j < 9; j++) {
        NSMutableArray* checkedValues = [[NSMutableArray alloc] init];
        for (int i = 0; i < 9; i++) {
            NSNumber* value = [[self.cells objectAtIndex:i] objectAtIndex:j];
            // If this vlaue is invalid, or already in the checkedValues array, then the game is not valid finished
            if ([values containsObject:value] == false || [checkedValues containsObject:value]) {
                return false;
            }
            else {
                [checkedValues addObject:value];
            }
        }
    }
    
    // Check each nonet
    for (int nonet = 0; nonet < 9; nonet++) {
        NSMutableArray* checkedValues = [[NSMutableArray alloc] init];
        // Calculate the start position for current nonet
        int i = nonet / 3 * 3;
        int j = nonet % 3 * 3;
        
        for (int delta_i = 0; delta_i < 3; delta_i++) {
            for (int delta_j = 0; delta_j < 3; delta_j++) {
                NSNumber* value = [[self.cells objectAtIndex:(i + delta_i)] objectAtIndex:(j + delta_j)];
                if ([values containsObject:value] == false || [checkedValues containsObject:value]) {
                    return false;
                }
                else {
                    [checkedValues addObject:value];
                }
            }
        }
    }
    
    
    return true;
}



- (NSString*)description {
    NSMutableString* description = [[NSMutableString alloc] init];
    [description appendString:@"\n    0 1 2   3 4 5   6 7 8\n    - - - - - - - - - - - \n"];
    for (int i = 0; i < 9; i++) {
        [description appendString:[NSString stringWithFormat:@"%d | ",i,nil]];
        for (int j = 0; j < 9; j++) {
            [description appendString:[[[self.cells objectAtIndex:i] objectAtIndex:j] stringValue]];
            [description appendString:@" "];
            if (j == 2 || j == 5) {
                [description appendString:@"| "];
            }
        }
        [description appendString:@"\n"];
        if (i == 2 || i == 5) {
            [description appendString:@"    - - - - - - - - - - -\n"];
        }
    }
    [description appendString:@"\n"];
    return [NSString stringWithString:description];
}

-(NSMutableSet*)findCandidatesAtRow:(NSInteger)row Column:(NSInteger)col {
    NSMutableSet* candidates = [[NSMutableSet alloc] init];
    
    //  If the cell is already filled, return the empty set directly
    if ([[[self.cells objectAtIndex:row] objectAtIndex:col] intValue] == 0) {
        for (int value = 1; value <= 9; value++) {
            // Check the row for duplicate
            NSMutableArray* checkingRow = [self.cells objectAtIndex:row];
            if ([checkingRow containsObject:[NSNumber numberWithInt:value]]) {
                continue;
            }
            
            // Check the column for duplicate
            for (int i = 0; i < 9; i++) {
                if ([[[self.cells objectAtIndex:i] objectAtIndex:col] intValue] == value) {
                    goto outerContinue;
                }
            }
            
            // Check the nonet for duplicate
            int nonet = row / 3 * 3 + col / 3;
            int i = nonet / 3 * 3;
            int j = nonet % 3 * 3;
            
            for (int delta_i = 0; delta_i < 3; delta_i++) {
                for (int delta_j = 0; delta_j < 3; delta_j++) {
                    if ([[[self.cells objectAtIndex:(i + delta_i)] objectAtIndex:(j + delta_j)] intValue] == value) {
                        goto outerContinue;
                    }
                }
            }
            
            [candidates addObject:[NSNumber numberWithInt:value]];
            
        outerContinue:;
        }
    }
    
    return candidates;
}

-(GameBoard*)copy {
    GameBoard* newBoard = [[GameBoard alloc] initWithCells:self.cells];
    return newBoard;
}



@end