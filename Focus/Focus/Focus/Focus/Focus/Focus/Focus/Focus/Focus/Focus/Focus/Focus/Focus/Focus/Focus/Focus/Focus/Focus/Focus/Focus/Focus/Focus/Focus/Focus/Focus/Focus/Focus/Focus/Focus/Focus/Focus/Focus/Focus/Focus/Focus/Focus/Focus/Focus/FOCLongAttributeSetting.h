//
//  FOCLongAttributeSetting.h
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCBaseAttributeSetting.h"

@interface FOCLongAttributeSetting : FOCBaseAttributeSetting

/**
 * Returns the label for a given long value.
 */
+ (NSString *)labelForValue:(long)value;

/**
 * Returns the index for a given long value.
 */
+ (int)indexForValue:(long)value;

/**
 * Returns the long value for a given increment index.
 */
+ (long)valueForIncrementIndex:(long)index;

@end
