//
//  FOCModeAttributeSetting.h
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCBaseAttributeSetting.h"
#import "FOCDeviceProgramEntity.h"

@interface FOCModeAttributeSetting : FOCBaseAttributeSetting

/**
 * Returns the label for a given program mode.
 */
+ (NSString *)labelForValue:(ProgramMode)value;

/**
 * Returns the index for a given program mode.
 */
+ (int)indexForValue:(ProgramMode)value;

/**
 * Returns the program mode for a given increment index.
 */
+ (ProgramMode)valueForIncrementIndex:(long)index;

@end
