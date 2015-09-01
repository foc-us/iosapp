//
//  ModelController.h
//  Focus
//
//  Created by Jamie Lynch on 26/06/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FOCDataViewController;

@interface FOCModelController : NSObject <UIPageViewControllerDataSource>

- (FOCDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;
- (NSUInteger)indexOfViewController:(FOCDataViewController *)viewController;
- (void)refresh;

@end

