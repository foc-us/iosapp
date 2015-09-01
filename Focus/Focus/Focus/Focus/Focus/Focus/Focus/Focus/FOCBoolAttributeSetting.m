//
//  FOCBaseBoolAttributeSetting.m
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCBoolAttributeSetting.h"

static NSString *kOn = @"ON";
static NSString *kOff = @"OFF";

@implementation FOCBoolAttributeSetting

+ (NSArray *)labelsForAttribute
{
    return [NSArray arrayWithObjects:kOn, kOff, nil];
}

+ (int)indexForValue:(bool)value
{
    return value ? 0 : 1;
}

+ (NSString *)labelForValue:(bool)value
{
    return value ? kOn : kOff;
}

+ (bool)valueForIncrementIndex:(long)index
{
    return index == 0;
}

@end
