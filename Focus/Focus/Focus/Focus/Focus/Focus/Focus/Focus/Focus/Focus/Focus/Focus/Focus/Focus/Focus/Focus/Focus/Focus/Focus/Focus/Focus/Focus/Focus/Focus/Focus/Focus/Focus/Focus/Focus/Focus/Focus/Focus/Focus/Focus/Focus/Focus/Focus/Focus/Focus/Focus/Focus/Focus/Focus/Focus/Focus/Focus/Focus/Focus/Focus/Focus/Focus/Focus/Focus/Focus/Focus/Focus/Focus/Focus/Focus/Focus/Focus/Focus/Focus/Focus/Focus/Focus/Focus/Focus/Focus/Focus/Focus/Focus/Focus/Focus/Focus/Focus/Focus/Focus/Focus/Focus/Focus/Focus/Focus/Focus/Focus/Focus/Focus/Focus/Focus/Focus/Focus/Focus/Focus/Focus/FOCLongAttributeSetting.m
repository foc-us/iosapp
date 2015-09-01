//
//  FOCLongAttributeSetting.m
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCLongAttributeSetting.h"

@implementation FOCLongAttributeSetting

+ (NSString *)labelForValue:(long)value
{
    return [self labelsForAttribute][[self indexForValue:value]];
}

+ (int)indexForValue:(long)value
{
    return -1;
}

+ (long)valueForIncrementIndex:(long)index
{
    return -1;
}

@end
