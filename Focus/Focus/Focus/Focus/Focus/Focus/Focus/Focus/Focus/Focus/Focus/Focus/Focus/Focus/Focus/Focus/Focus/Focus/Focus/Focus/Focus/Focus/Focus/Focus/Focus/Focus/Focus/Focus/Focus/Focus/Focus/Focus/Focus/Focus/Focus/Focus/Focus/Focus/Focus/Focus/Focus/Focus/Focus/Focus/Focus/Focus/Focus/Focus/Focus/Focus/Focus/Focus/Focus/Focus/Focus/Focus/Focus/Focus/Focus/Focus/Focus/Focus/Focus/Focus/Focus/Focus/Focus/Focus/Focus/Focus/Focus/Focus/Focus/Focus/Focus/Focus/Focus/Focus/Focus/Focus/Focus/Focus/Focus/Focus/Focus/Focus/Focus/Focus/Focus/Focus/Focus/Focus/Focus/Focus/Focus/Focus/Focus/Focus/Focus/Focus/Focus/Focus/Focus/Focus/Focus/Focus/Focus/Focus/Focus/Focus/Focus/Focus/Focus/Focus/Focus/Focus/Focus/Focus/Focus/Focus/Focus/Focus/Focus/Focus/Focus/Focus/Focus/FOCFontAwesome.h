//
//  FOCFontAwesome.h
//  Focus
//
//  Created by Jamie Lynch on 13/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * Manages the FontAwesome typeface & provides convenience methods for retrieving unicode
 * characters via FA codes. See http://fortawesome.github.io/ for further details.
 */
@interface FOCFontAwesome : NSObject

/**
 * Returns the unicode character for a code e.g. fa-play
 */
+(NSString *) unicodeForIcon:(NSString *)iconName;

/**
 * Returns an instance of the FontAwesome typeface.
 */
+(UIFont *) font;

extern NSString *const FONT_AWESOME;
extern const float DEFAULT_ICON_SIZE;

@end
