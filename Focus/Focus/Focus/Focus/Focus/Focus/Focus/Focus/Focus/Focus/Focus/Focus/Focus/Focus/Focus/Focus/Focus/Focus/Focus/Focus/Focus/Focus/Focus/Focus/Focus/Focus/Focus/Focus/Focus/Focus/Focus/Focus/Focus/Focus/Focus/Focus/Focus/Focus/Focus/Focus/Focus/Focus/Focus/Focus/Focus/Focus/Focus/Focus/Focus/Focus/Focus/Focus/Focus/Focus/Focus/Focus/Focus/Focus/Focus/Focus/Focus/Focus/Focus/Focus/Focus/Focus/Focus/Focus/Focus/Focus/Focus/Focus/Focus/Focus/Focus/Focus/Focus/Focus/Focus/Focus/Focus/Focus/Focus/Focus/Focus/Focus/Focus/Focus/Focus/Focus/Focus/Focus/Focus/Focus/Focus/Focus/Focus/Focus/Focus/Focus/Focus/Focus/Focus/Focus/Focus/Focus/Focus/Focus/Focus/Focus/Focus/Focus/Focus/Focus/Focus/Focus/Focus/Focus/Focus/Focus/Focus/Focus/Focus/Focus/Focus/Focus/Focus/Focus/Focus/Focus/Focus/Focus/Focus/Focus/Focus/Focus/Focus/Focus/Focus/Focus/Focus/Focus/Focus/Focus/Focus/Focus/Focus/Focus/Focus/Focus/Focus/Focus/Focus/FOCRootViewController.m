//
//  RootViewController.m
//  Focus
//
//  Created by Jamie Lynch on 26/06/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCAppDelegate.h"
#import "FOCRootViewController.h"
#import "FOCModelController.h"
#import "FOCDataViewController.h"

static NSString *kIdentifier = @"FOCDataViewController";

@interface FOCRootViewController ()

@property FOCDeviceManager *deviceManager;
@property (strong, nonatomic) NSMutableArray *pageData;
@property int pageIndex;
@property NSString *statusText;

@end

@implementation FOCRootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    _pageData = [[NSMutableArray alloc] init];
    
    [self reloadData];
    
    FOCAppDelegate *delegate = (FOCAppDelegate *) [[UIApplication sharedApplication] delegate];
    delegate.syncDelegate = self;
    
    _deviceManager = delegate.focusDeviceManager;
    _deviceManager.delegate = self;
    
    self.pageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    self.pageViewController.delegate = self;

    FOCDataViewController* startingViewController = [self viewControllerAtIndex:0 storyboard:self.storyboard];
    NSArray* viewControllers = @[ startingViewController ];
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];

    self.pageViewController.dataSource = self;

    [self addChildViewController:self.pageViewController];
    [self.view addSubview:self.pageViewController.view];

    self.pageViewController.view.frame = self.view.bounds;

    [self.pageViewController didMoveToParentViewController:self];
    [self setupPagingGestureRecognisers];
}

- (void)setupPagingGestureRecognisers // ignore pages when tapping at side
{
    self.view.gestureRecognizers = self.pageViewController.gestureRecognizers;
    
    for (UIGestureRecognizer* recognizer in self.pageViewController.gestureRecognizers) {
        if ([recognizer isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:recognizer];
            [self.pageViewController.view removeGestureRecognizer:recognizer];
        }
    }
}

- (FOCDataViewController *)currentViewController
{
    return ([_pageData count] == 0) ? nil : (FOCDataViewController*) self.pageViewController.viewControllers[0];
}

- (void)reloadData
{
    FOCDataViewController *currentController = [self currentViewController];
    FOCDeviceProgramEntity *currentModel;
    
    if (currentController != nil) {
        currentModel = [self currentViewController].pageModel.program;
    }
    
    FOCAppDelegate *delegate = (FOCAppDelegate *) [[UIApplication sharedApplication] delegate];
    [_pageData removeAllObjects];
    
    for (FOCDeviceProgramEntity *program in [delegate retrieveFocusPrograms]) {
        [_pageData addObject:[[FOCUiPageModel alloc] initWithProgram:program]];
    }
    
    int index = 0; // default to first if no previous controller
    
    for (int i=0; i<[_pageData count] && currentModel != nil; i++) {
        FOCDeviceProgramEntity *newModel = ((FOCUiPageModel *)_pageData[i]).program;
        
        if ([newModel.name isEqualToString:currentModel.name]
            && newModel.programId.intValue == currentModel.programId.intValue) {
            
            index = i;
            break;
        }
    }
    
    NSLog(@"Refreshed and displayed %d programs", [_pageData count]);
    [self refreshDisplayedController];
}

- (void)refreshDisplayedController
{
    FOCDataViewController* startingViewController = [self viewControllerAtIndex:_pageIndex storyboard:self.storyboard];
    
    if (startingViewController != nil) {
        NSArray* viewControllers = @[ startingViewController ];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }
}

- (FOCDataViewController *)viewControllerAtIndex:(NSUInteger)index storyboard:(UIStoryboard *)storyboard {
    _pageIndex = index;
    
    if (([_pageData count] == 0) || (index >= [_pageData count])) {
        return nil;
    }
    
    FOCDataViewController *dataViewController = [storyboard instantiateViewControllerWithIdentifier:kIdentifier];
    dataViewController.pageModel = _pageData[index];
    dataViewController.pageModel.connectionText = _statusText;
    dataViewController.delegate = self;
    
    return dataViewController;
}

- (NSUInteger)indexOfViewController:(FOCDataViewController *)viewController {
    return [_pageData indexOfObject:viewController.pageModel];
}

- (FOCUiPageModel *)findPageModelById:(FOCDeviceProgramEntity *)program
{
    for (int i=0; i<[_pageData count]; i++) {
        FOCUiPageModel *model = _pageData[i];
        
        bool idMatch = model.program.programId.intValue == program.programId.intValue;
        bool nameMatch = [model.program.name isEqualToString:program.name];
        
        if (idMatch && nameMatch) {
            return model;
        }
    }
    return nil;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark DeviceStateDelegate

- (void)didChangeConnectionState: (FocusConnectionState)connectionState
{
    for (FOCUiPageModel *model in _pageData) {
        model.connectionState = connectionState;
    }
    [self refreshDisplayedController];
}

- (void)didChangeConnectionText:(NSString *)connectionText
{
    _statusText = connectionText;
    [[self currentViewController] updateConnectionText:_statusText];
}

- (void)programStateChanged:(bool)playing
{
    for (FOCUiPageModel *model in _pageData) {
        model.isPlaying = playing;
    }
    [self refreshDisplayedController];
}

- (void)didUpdateProgram:(FOCDeviceProgramEntity *)program
{
    FOCUiPageModel *matchingModel = [self findPageModelById:program];
    
    if (matchingModel != nil) {
        matchingModel.program = program;
    }
    FOCAppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    
    for (FOCUiPageModel *model in _pageData) {
        [ary addObject:model.program];
    }
    [delegate saveSyncedPrograms:ary];
}

#pragma mark ProgramSyncDelegate

- (void)didChangeDataSet:(NSArray *)dataSet
{
    [self reloadData];
}

#pragma mark - FOCUiPageChangeDelegate

-(void)didAlterPageState:(FOCUiPageModel *)pageModel
{
    FOCUiPageModel *matchingModel = [self findPageModelById:pageModel.program];
    
    if (matchingModel != nil) {
        matchingModel = pageModel;
    }
}

- (void)didRequestProgramStateChange:(FOCUiPageModel *)pageModel play:(bool)play
{
    if (play) {
        [_deviceManager playProgram:pageModel.program];
    }
    else {
        [_deviceManager stopProgram:pageModel.program];
    }
}

- (void)didRequestProgramEdit:(FOCDeviceProgramEntity *)program
{
    FOCUiPageModel *matchingModel = [self findPageModelById:program];
    
    if (matchingModel != nil && ![matchingModel.program isEqual:program]) {
        [_deviceManager writeProgram:program];
    }
    else {
        NSLog(@"Program attributes don't differ, skipping edit request");
    }
}

#pragma mark - UIPageViewController delegate methods

- (UIPageViewControllerSpineLocation)pageViewController:(UIPageViewController*)pageViewController spineLocationForInterfaceOrientation:(UIInterfaceOrientation)orientation
{
    FOCDataViewController* currentViewController = [self currentViewController];
    NSArray* viewControllers = @[ currentViewController ];
    
    [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    self.pageViewController.doubleSided = NO;
    return UIPageViewControllerSpineLocationMin;
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
