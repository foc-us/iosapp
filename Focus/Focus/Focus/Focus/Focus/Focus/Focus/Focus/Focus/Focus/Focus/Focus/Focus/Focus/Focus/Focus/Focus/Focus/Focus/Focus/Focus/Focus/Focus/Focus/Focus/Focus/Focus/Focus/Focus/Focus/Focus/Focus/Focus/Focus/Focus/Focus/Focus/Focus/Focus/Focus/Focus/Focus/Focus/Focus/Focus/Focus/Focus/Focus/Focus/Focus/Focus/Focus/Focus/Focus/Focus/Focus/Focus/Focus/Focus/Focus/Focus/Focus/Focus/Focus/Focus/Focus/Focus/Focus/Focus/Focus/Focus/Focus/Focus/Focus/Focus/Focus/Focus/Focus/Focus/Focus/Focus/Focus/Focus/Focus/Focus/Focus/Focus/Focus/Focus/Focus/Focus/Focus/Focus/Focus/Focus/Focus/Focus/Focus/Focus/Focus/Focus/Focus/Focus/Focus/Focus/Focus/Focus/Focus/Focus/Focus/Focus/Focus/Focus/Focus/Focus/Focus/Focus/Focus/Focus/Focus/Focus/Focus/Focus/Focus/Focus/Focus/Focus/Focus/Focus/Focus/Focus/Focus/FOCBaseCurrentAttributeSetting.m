//
//  FOCCurrentAttributeSetting.m
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCBaseCurrentAttributeSetting.h"

static const int kIncrement = 100;
static const int kCurrentScalar = 1000;

@implementation FOCBaseCurrentAttributeSetting

+ (NSArray *)labelsForAttribute
{
    NSMutableArray *options = [[NSMutableArray alloc] init];
    
    for (int i=[self minCurrent]; i<=[self maxCurrent]; i+=kIncrement) {
        [options addObject:[NSString stringWithFormat:@"%.1fmA", ((float) i) / kCurrentScalar]];
    }
    return [options copy];
}

+ (NSArray *)rawUnscaledValues
{
    NSMutableArray *rawValues = [[NSMutableArray alloc] init];
    
    for (int i=[self minCurrent]; i<=[self maxCurrent]; i+=kIncrement) {
        [rawValues addObject:[[NSNumber alloc] initWithInt:i]];
    }
    return rawValues;
}

+ (int)indexForValue:(int)value
{
    NSArray *rawValues = [self rawUnscaledValues];
    
    for (int i=0; i<[rawValues count]; i++) {
        NSNumber *number = rawValues[i];
        
        if (number.intValue == value) {
            return i;
        }
    }
    return -1;
}

+ (int)valueForIncrementIndex:(long)index
{
    return ((NSNumber *)[self rawUnscaledValues][index]).intValue;
}

+ (NSString *)labelForValue:(int)value
{
    int index = [self indexForValue:value];
    return index != -1 ? [self labelsForAttribute][index] : nil;
}

+ (int)maxCurrent
{
    return -1;
}

+ (int)minCurrent
{
    return -1;
}

@end
