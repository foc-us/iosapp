//
//  FOCDisplayAttributeModel.h
//  Focus
//
//  Created by Jamie Lynch on 15/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Models the data that should be displayed for each attribute of a program; i.e., a title & value
 */
@interface FOCDisplayAttributeModel : NSObject

@property NSString *attrLabel;
@property NSString *attrValue;

@end
