//
//  FOCDefaultProgramProvider.h
//  Focus
//
//  Created by Jamie Lynch on 14/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FOCDeviceProgramEntity.h"

/**
 * Returns Focus Program models with their default settings. Pre-loaded programs can be
 * distinguished from those on the device, as their programId will always equal -1.
 */
@interface FOCDefaultProgramProvider : NSObject

+(FOCDeviceProgramEntity *)gamer;
+(FOCDeviceProgramEntity *)enduro;
+(FOCDeviceProgramEntity *)wave;
+(FOCDeviceProgramEntity *)pulse;
+(FOCDeviceProgramEntity *)noise;

/**
 * Returns an array containing all the default Focus programs.
 */
+(NSArray *) allDefaults;

@end
