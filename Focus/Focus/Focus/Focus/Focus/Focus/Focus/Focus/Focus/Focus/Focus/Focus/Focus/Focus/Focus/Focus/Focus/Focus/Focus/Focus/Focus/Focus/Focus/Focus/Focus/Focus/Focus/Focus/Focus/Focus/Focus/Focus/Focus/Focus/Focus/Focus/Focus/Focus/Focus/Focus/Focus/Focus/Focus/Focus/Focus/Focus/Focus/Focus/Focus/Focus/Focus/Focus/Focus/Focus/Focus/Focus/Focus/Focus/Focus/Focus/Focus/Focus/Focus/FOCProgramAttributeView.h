//
//  FOCProgramAttributeView.h
//  Focus
//
//  Created by Jamie Lynch on 16/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FOCDisplayAttributeModel.h"

/**
 * Displays the title and value of a program attribute.
 */
@interface FOCProgramAttributeView : UIView

/**
 * Updates the view so that it displays any changes in the model's data.
 */
- (void)updateModel:(FOCDisplayAttributeModel *) model;

@end
