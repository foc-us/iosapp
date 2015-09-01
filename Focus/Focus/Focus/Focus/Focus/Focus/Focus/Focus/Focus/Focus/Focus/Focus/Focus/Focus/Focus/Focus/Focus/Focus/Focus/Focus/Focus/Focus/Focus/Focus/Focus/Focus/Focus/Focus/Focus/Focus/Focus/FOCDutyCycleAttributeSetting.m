//
//  FOCDutyCycleAttributeSetting.m
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCDutyCycleAttributeSetting.h"

static const int kMinDutyCycle = 0;
static const int kMaxDutyCycle = 100;
static const int kApiScalar = 1000;

@implementation FOCDutyCycleAttributeSetting

+ (NSArray *)labelsForAttribute
{
    NSMutableArray *options = [[NSMutableArray alloc] init];
    
    for (int i=kMinDutyCycle; i<=kMaxDutyCycle; i++) {
        [options addObject:[NSString stringWithFormat:@"%d%%", i]];
    }
    return [options copy];
}

+ (int)indexForValue:(long)value
{
    value /= kApiScalar;
    
    for (int i=kMinDutyCycle; i<=kMaxDutyCycle; i++) {
        if (i == value) {
            return i - kMinDutyCycle;
        }
    }
    return -1;
}

+ (long)valueForIncrementIndex:(long)index
{
    for (int i=kMinDutyCycle; i<=kMaxDutyCycle; i++) {
        if (i == index) {
            return i * kApiScalar;
        }
    }
    return -1;
}

+ (NSString *)labelForValue:(long)value
{
    int index = [self indexForValue:value];
    return index != -1 ? [self labelsForAttribute][index] : nil;
}

@end
