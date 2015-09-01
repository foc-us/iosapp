//
//  AppDelegate.h
//  Focus
//
//  Created by Jamie Lynch on 26/06/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

#import "FOCDeviceManager.h"
#import "FOCAppSyncDelegate.h"

/**
 * Contains a Device manager instance which allows the Focus Device to be interacted with
 * via its Bluetooth API.
 */
@interface FOCAppDelegate : UIResponder <UIApplicationDelegate> {
        __weak id<FOCAppSyncDelegate> delegate_;
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) FOCDeviceManager *focusDeviceManager;
@property (weak) id <FOCAppSyncDelegate> syncDelegate;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

/**
 * Persist all programs in the array in Core Data.
 */
- (void)saveSyncedPrograms:(NSArray *)syncedPrograms;

/**
 * Retrieves programs from Core Data (if any)
 */
- (NSArray *)retrieveFocusPrograms;

@end