//
//  FOCUiPageChangeDelegate.h
//  Focus
//
//  Created by Jamie Lynch on 24/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#ifndef Focus_FOCUiPageModel_h
#define Focus_FOCUiPageModel_h

#import "FOCUiPageModel.h"

/**
 * The methods in this delegate are called when a UIView event requests a change in the
 * model layer. For example, the user may request to start/stop a program, or change the
 * visibility of certain UI elements.
 */
@protocol FOCUiPageChangeDelegate <NSObject>

/**
 * Called when the UI model for displaying the program changes e.g. Settings visibility
 */
- (void)didAlterPageState:(FOCUiPageModel *)pageModel;

/**
 * Called when the user requests to stop/start a program through the app UI.
 */
- (void)didRequestProgramStateChange:(FOCUiPageModel *)pageModel play:(bool)play;

/**
 * Called when the user requests an edit to the program. The responder should write the
 * edited program to the Focus device then notify the UI of changes to the model.
 */
- (void)didRequestProgramEdit:(FOCDeviceProgramEntity *)program;

@end

#endif