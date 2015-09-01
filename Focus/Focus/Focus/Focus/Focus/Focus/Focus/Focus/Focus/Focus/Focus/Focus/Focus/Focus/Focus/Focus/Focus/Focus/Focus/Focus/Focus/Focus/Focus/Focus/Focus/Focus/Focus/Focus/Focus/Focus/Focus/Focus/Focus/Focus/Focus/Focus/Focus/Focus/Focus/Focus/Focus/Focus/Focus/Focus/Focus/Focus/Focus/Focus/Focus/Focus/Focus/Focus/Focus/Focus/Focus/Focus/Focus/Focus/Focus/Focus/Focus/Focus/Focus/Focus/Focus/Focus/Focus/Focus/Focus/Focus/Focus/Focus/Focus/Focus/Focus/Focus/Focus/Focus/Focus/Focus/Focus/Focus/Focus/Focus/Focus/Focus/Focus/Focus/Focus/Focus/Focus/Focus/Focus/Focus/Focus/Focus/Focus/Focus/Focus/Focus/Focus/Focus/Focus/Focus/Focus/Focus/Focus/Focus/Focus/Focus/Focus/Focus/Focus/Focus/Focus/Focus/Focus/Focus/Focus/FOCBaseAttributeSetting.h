//
//  FOCBaseAttributeSetting.h
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Allows conversion between the UI representation of a program setting (String labels)
 * to the device representation of a setting (int/bool/etc)
 */
@interface FOCBaseAttributeSetting : NSObject

/**
 * Returns an array which contains all allowed values for the attribute. An attribute
 * starts at a minimum value and continues to the maximum, going up in increments.
 */
+ (NSArray *)labelsForAttribute;

@end
