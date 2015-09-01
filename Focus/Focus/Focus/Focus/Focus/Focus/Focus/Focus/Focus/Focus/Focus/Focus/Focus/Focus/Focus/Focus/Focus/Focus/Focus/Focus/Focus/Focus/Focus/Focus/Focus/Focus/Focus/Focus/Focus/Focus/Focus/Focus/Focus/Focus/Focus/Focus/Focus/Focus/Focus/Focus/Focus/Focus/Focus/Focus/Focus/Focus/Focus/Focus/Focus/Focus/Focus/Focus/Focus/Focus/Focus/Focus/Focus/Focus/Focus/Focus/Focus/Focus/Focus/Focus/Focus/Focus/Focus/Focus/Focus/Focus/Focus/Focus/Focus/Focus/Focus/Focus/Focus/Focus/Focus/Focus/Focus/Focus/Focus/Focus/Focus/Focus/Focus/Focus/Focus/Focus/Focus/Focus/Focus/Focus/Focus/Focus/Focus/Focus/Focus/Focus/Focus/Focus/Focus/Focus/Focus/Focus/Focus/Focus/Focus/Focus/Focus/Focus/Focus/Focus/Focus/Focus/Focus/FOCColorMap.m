//
//  FOCColorMap.m
//  Focus
//
//  Created by Jamie Lynch on 16/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCColorMap.h"

@implementation FOCColorMap

+(UIColor *) colorFromString: (NSString *) colorString {
    NSString *sanitisedHex = [[colorString stringByReplacingOccurrencesOfString: @"#" withString: @""] uppercaseString];
    CGFloat alpha, red, blue, green;
    
    switch ([sanitisedHex length]) {
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom: sanitisedHex start: 0];
            green = [self colorComponentFrom: sanitisedHex start: 2];
            blue  = [self colorComponentFrom: sanitisedHex start: 4];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom: sanitisedHex start: 0];
            red   = [self colorComponentFrom: sanitisedHex start: 2];
            green = [self colorComponentFrom: sanitisedHex start: 4];
            blue  = [self colorComponentFrom: sanitisedHex start: 6];
            break;
        default:
            return nil;
    }
    return [UIColor colorWithRed: red green: green blue: blue alpha: alpha];
}

+ (CGFloat) colorComponentFrom: (NSString *) string start: (NSUInteger) start {
    NSString *fullHex = [string substringWithRange: NSMakeRange(start, 2)];
    unsigned hexComponent;
    [[NSScanner scannerWithString: fullHex] scanHexInt: &hexComponent];
    return hexComponent / 255.0;
}

@end
