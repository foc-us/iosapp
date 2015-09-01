//
//  ModelController.m
//  Focus
//
//  Created by Jamie Lynch on 26/06/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCModelController.h"
#import "FOCDataViewController.h"
#import "FOCDefaultProgramProvider.h"
#import "FOCAppDelegate.h"

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */

@interface FOCModelController ()

@property (readonly, strong, nonatomic) NSArray *pageData;
@end

@implementation FOCModelController

- (instancetype)init {
    self = [super init];
    if (self) {
        [self refresh];
    }
    return self;
}

- (void)refresh
{
    FOCAppDelegate *delegate = (FOCAppDelegate *) [[UIApplication sharedApplication] delegate];
    _pageData = [delegate retrieveFocusPrograms];
    NSLog(@"Refreshed and displayed %d programs", [_pageData count]);
}

- (FOCDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    
    if (([self.pageData count] == 0) || (index >= [self.pageData count])) {
        return nil;
    }

    FOCDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:@"FOCDataViewController"];
    dataViewController.program = self.pageData[index];
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(FOCDataViewController *)viewController {
    return [self.pageData indexOfObject:viewController.program];
}

#pragma mark - Page View Controller Data Source

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(FOCDataViewController *)viewController];
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    index--;
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = [self indexOfViewController:(FOCDataViewController *)viewController];
    if (index == NSNotFound) {
        return nil;
    }
    
    index++;
    if (index == [self.pageData count]) {
        return nil;
    }
    return [self viewControllerAtIndex:index storyboard:viewController.storyboard];
}

@end
