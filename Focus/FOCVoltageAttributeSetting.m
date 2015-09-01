//
//  FOCVoltageAttributeSetting.m
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCVoltageAttributeSetting.h"

static const int kMinVoltage = 10;
static const int kMaxVoltage = 60;

@implementation FOCVoltageAttributeSetting

+ (NSArray *)labelsForAttribute
{
    NSMutableArray *options = [[NSMutableArray alloc] init];
    
    for (int i=kMinVoltage; i<=kMaxVoltage; i++) {
        [options addObject:[NSString stringWithFormat:@"%dV", i]];
    }
    return [options copy];
}

+ (int)indexForValue:(int)value
{
    return value - kMinVoltage;
}

+ (int)valueForIncrementIndex:(long)index
{
    return index + kMinVoltage;
}

+ (NSString *)labelForValue:(int)value
{
    return [self labelsForAttribute][[self indexForValue:value]];
}

@end
