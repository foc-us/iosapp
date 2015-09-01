//
//  RootViewController.h
//  Focus
//
//  Created by Jamie Lynch on 26/06/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FOCAppDelegate.h"
#import "FOCDataViewController.h"
#import "FOCDeviceStateDelegate.h"
#import "FOCUiPageChangeDelegate.h"

@class FOCUiPageModel;

/**
 * Controls all the pages in the ViewPager, and what data they should display.
 * Responds to callbacks from the Focus Device manager and updates the UI appropriately.
 */
@interface FOCRootViewController : UIViewController <UIPageViewControllerDelegate, UIPageViewControllerDataSource, FOCDeviceStateDelegate, FOCAppSyncDelegate, FOCUiPageChangeDelegate> {
    
    __weak id<FOCUiPageChangeDelegate> delegate_;
}

@property (weak) id <FOCUiPageChangeDelegate> delegate;
@property (strong, nonatomic) UIPageViewController* pageViewController;

/**
 * Returns the view controller at the given index, or nil if none exists.
 */
- (FOCDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard;

/**
 * Returns the index of the given view controller, or NSNotFound if it is not in the dataset.
 */
- (NSUInteger)indexOfViewController:(FOCDataViewController *)viewController;

@end
