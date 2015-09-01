//
//  FOMColorMap.h
//  Focus
//
//  Created by Jamie Lynch on 16/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Converts hex strings to UIColors
 */
@interface FOCColorMap : NSObject

/**
 * Converts a 6-hex string or 8-hex string into a UIColor.
 */
+(UIColor *) colorFromString: (NSString *) colorString;

@end
