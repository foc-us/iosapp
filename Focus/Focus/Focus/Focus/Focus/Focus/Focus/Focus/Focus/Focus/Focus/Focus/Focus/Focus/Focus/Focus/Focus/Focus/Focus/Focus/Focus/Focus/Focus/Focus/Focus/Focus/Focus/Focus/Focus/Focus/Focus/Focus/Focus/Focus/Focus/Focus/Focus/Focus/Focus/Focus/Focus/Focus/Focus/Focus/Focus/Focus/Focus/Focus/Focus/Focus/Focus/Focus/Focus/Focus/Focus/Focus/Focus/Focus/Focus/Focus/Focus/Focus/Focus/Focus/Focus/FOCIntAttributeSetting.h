//
//  FOCIntAttributeSetting.h
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCBaseAttributeSetting.h"

@interface FOCIntAttributeSetting : FOCBaseAttributeSetting

/**
 * Returns the label for a given integer value.
 */
+ (NSString *)labelForValue:(int)value;

/**
 * Returns the index for a given integer value.
 */
+ (int)indexForValue:(int)value;

/**
 * Returns the integer value for a given increment index.
 */
+ (int)valueForIncrementIndex:(long)index;

@end
