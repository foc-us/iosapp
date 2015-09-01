//
//  FOCModeAttributeSetting.m
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCModeAttributeSetting.h"

static NSString *kDcsLabel = @"Direct";
static NSString *kAcsLabel = @"Alternating";
static NSString *kRnsLabel = @"Random";
static NSString *kPcsLabel = @"Pulse";

@implementation FOCModeAttributeSetting

+ (NSArray *)labelsForAttribute
{
    return [NSArray arrayWithObjects:kDcsLabel, kAcsLabel, kRnsLabel, kPcsLabel, nil];
}

+ (NSString *)labelForValue:(ProgramMode)value
{
    return [self labelsForAttribute][[self indexForValue:value]];
}

+ (int)indexForValue:(ProgramMode)value
{
    switch (value) {
        case DCS: return 0;
        case ACS: return 1;
        case RNS: return 2;
        case PCS: return 3;
        default: return -1;
    }
}

+ (ProgramMode)valueForIncrementIndex:(long)index
{
    switch (index) {
        case 0: return DCS;
        case 1: return ACS;
        case 2: return RNS;
        case 3: return PCS;
        default: return RNS;
    }
}

@end
