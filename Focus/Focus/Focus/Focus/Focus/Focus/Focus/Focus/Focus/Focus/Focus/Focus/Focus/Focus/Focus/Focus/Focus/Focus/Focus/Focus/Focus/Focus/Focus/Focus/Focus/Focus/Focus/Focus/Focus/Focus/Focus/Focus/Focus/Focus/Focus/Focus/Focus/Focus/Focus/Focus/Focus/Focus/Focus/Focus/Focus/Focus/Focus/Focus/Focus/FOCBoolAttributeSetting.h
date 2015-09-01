//
//  FOCBaseBoolAttributeSetting.h
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCBaseAttributeSetting.h"

@interface FOCBoolAttributeSetting : FOCBaseAttributeSetting

/**
 * Returns the label for a given boolean value.
 */
+ (NSString *)labelForValue:(bool)value;

/**
 * Returns the index for a given boolean value.
 */
+ (int)indexForValue:(bool)value;

/**
 * Returns the boolean value for a given increment index.
 */
+ (bool)valueForIncrementIndex:(long)index;

@end
