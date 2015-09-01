//
//  FOCShamDurationAttributeSetting.h
//  Focus
//
//  Created by Jamie Lynch on 22/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCIntAttributeSetting.h"

@interface FOCShamDurationAttributeSetting : FOCIntAttributeSetting

/**
 * Returns a label in the format %d
 */
+ (NSString *)timeLabelForView:(int)duration;

@end
