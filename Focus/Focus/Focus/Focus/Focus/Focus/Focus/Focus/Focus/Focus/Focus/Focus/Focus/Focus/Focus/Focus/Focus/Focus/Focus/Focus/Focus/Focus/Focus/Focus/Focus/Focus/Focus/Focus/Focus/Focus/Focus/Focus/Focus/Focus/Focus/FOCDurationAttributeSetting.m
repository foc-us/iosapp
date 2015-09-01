//
//  FOCDurationAttributeSetting.m
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCDurationAttributeSetting.h"

@implementation FOCDurationAttributeSetting

+ (NSArray *)labelsForSeconds
{
    NSMutableArray *seconds = [[NSMutableArray alloc] init];
    
    for (int i=0; i<60; i++) {
        [seconds addObject:[NSString stringWithFormat:@"%02d seconds", i]];
    }
    return [seconds copy];
}

+ (NSArray *)labelsForMinutes
{
    NSMutableArray *minutes = [[NSMutableArray alloc] init];
    
    for (int i=5; i<40; i++) {
        [minutes addObject:[NSString stringWithFormat:@"%02d minutes", i]];
    }
    return [minutes copy];
}

+ (int)indexForSeconds:(int)duration
{
    return duration % 60;
}

+ (int)indexForMinutes:(int)duration
{
    int minutes = (duration - (duration %60)) / 60;
    return minutes - 5;
}

+ (NSString *)secondLabelForDuration:(int)duration
{
    return [self labelsForSeconds][[self indexForSeconds:duration]];
}

+ (NSString *)minuteLabelForDuration:(int)duration
{
    return [self labelsForMinutes][[self indexForMinutes:duration]];
}

+ (int)durationForIndices:(int)minutes seconds:(int)seconds
{
    return ((minutes + 5) * 60) + seconds;
}

+ (NSString *)timeLabelForView:(int)duration
{
    int seconds = duration % 60;
    int mins = (duration - seconds) / 60;
    return [NSString stringWithFormat:@"%02d:%02d", mins, seconds];
}

@end
