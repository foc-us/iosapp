//
//  FOCFrequencyAttributeSetting.m
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCFrequencyAttributeSetting.h"

static const int kApiScalar = 1000;

@implementation FOCFrequencyAttributeSetting

+ (NSArray *)labelsForAttribute
{
    NSMutableArray *options = [[NSMutableArray alloc] init];
    
    for (NSNumber *number in [self rawUnscaledValues]) {
        int n = number.intValue;
        
        if (n <= 900) {
            [options addObject:[NSString stringWithFormat:@"%.1fHz", ((float) n) / kApiScalar]];
        }
        else {
            [options addObject:[NSString stringWithFormat:@"%dHz", n / kApiScalar]];
        }
    }
    return [options copy];
}

+ (NSArray *)rawUnscaledValues
{
    NSMutableArray *rawValues = [[NSMutableArray alloc] init];
    
    for (int i=100; i<=900; i+=100) {
        [rawValues addObject:[[NSNumber alloc] initWithInt:i]];
    }
    for (int i=1000; i<=29000; i+=1000) {
        [rawValues addObject:[[NSNumber alloc] initWithInt:i]];
    }
    for (int i=30000; i<=300000; i+=10000) {
        [rawValues addObject:[[NSNumber alloc] initWithInt:i]];
    }
    return rawValues;
}

+ (int)indexForValue:(long)value
{
    NSArray *rawValues = [self rawUnscaledValues];
    
    for (int i=0; i<=[rawValues count]; i++) {
        NSNumber *number = rawValues[i];
        
        if (number.intValue == value) {
            return i;
        }
    }
    return -1;
}

+ (long)valueForIncrementIndex:(long)index
{
    NSArray *rawValues = [self rawUnscaledValues];
    return (index <= [rawValues count]) ? ((NSNumber *)rawValues[index]).longValue : -1;
}

+ (NSString *)labelForValue:(long)value
{
    for (int i=100; i<=900; i+=100) {
        if (i == value) {
            return [NSString stringWithFormat:@"%.1fHz", (float)i / kApiScalar];
        }
    }
    for (int i=1000; i<=29000; i+=1000) {
        if (i == value) {
            return [NSString stringWithFormat:@"%dHz", i / kApiScalar];
        }
    }
    for (int i=30000; i<=300000; i+=10000) {
        if (i == value) {
            return [NSString stringWithFormat:@"%dHz", i / kApiScalar];
        }
    }
    NSLog(@"Could not match frequency %ld ", value);
    
    return nil;
}

@end
