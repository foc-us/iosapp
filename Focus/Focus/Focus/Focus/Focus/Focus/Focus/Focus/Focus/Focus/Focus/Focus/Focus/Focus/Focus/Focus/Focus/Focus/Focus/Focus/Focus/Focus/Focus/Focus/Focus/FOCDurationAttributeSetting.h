//
//  FOCDurationAttributeSetting.h
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FOCDurationAttributeSetting : NSObject

/**
 * Returns the labels for all possible minute values.
 */
+ (NSArray *)labelsForMinutes;

/**
 * Returns the labels for all possible second values.
 */
+ (NSArray *)labelsForSeconds;

/**
 * Returns the index for the seconds picker for the given duration.
 */
+ (int)indexForSeconds:(int)duration;

/**
 * Returns the index for the minutes picker for the given duration.
 */
+ (int)indexForMinutes:(int)value;

/**
 * Returns the second label for a given duration.
 */
+ (NSString *)secondLabelForDuration:(int)duration;

/**
 * Returns the minute label for a given duration.
 */
+ (NSString *)minuteLabelForDuration:(int)duration;

/**
 * Returns the duration, given the minute & seconds indices.
 */
+ (int)durationForIndices:(int)minutes seconds:(int)seconds;

/**
 * Returns a label in the format mm:ss
 */
+ (NSString *)timeLabelForView:(int)duration;

@end
