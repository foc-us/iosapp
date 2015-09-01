//
//  AppDelegate.m
//  Focus
//
//  Created by Jamie Lynch on 26/06/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCAppDelegate.h"
#import "FOCDeviceProgramEntity.h"
#import "FOCDefaultProgramProvider.h"
#import "CoreDataProgram.h"

@interface FOCAppDelegate ()

@end

@implementation FOCAppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

static NSString* kDataSchema = @"FocusProgram";
static NSString* kFocusProgramEntity = @"CoreDataProgram";
static NSString* kStorePath = @"focus.sqlite";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Fabric with:@[CrashlyticsKit]];
    
    self.focusDeviceManager = [[FOCDeviceManager alloc] init];
    _managedObjectContext = [self managedObjectContext];
    
    if ([[self retrieveFocusPrograms] count] == 0) {
        NSLog(@"No programs found in Core Data, creating app defaults");
        [self saveSyncedPrograms:[FOCDefaultProgramProvider allDefaults]];
    }
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"Application became inactive!");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"Entering background!");
    [_focusDeviceManager closeConnection];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    NSLog(@"Entering foreground, refreshing BLE device state!");
    [_focusDeviceManager refreshDeviceState];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    NSLog(@"Application became active!");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    NSLog(@"Application terminating!");
}

#pragma mark - Core Data stack

- (void)saveSyncedPrograms:(NSArray *)syncedPrograms
{
    NSLog(@"Persisting %lu saved programs.", (unsigned long)[syncedPrograms count]);
    [self pruneStalePrograms];

    for (FOCDeviceProgramEntity *entity in syncedPrograms) {
        
        if (entity.name != nil && ![entity.name isEqualToString:@""]) {
            CoreDataProgram *data = [NSEntityDescription
                                     insertNewObjectForEntityForName:kFocusProgramEntity
                                     inManagedObjectContext:_managedObjectContext];
            data = [entity serialiseToCoreDataModel:data];
        }
    }
    NSError *error;
    
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Failed to save program sync: %@", [error localizedDescription]);
    }
    
    [self.syncDelegate didChangeDataSet:syncedPrograms];
}

- (void)pruneStalePrograms
{
    NSLog(@"Pruning out-of-date programs.");
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:kFocusProgramEntity inManagedObjectContext:_managedObjectContext]];
    [request setIncludesPropertyValues:NO]; // only fetch the managedObjectID
    
    NSError *error = nil;
    NSArray *persistedPrograms = [_managedObjectContext executeFetchRequest:request error:&error];

    if (error != nil) {
        NSLog(@"Error retrieving stale Core Data entities %@", error);
    }
    
    for (NSManagedObject *program in persistedPrograms) {
        [_managedObjectContext deleteObject:program];
    }
    
    NSError *saveError = nil;
    [_managedObjectContext save:&saveError];
    
    if (error != nil) {
        NSLog(@"Error deleting stale Core Data entities %@", error);
    }
}

- (NSArray *)retrieveFocusPrograms
{
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:kFocusProgramEntity inManagedObjectContext:_managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    NSError *error;
    NSMutableArray *programArray = [[NSMutableArray alloc] init];
    
    NSArray *array = [_managedObjectContext executeFetchRequest:request error:&error];
    
    if (error != nil) {
        NSLog(@"Failed to retrieve persisted programs %@", error);
    }
    else {
        NSLog(@"Retrieved %lu persisted programs, serialising...", (unsigned long)[array count]);
    }
    
    if (array != nil) {
        for (CoreDataProgram *data in array) { // serialise entities, ignore any that don't have a valid name.
            
            if (data.name != nil && ![data.name isEqualToString:@""]) {
                FOCDeviceProgramEntity *entity = [[FOCDeviceProgramEntity alloc] initWithCoreDataModel:data];
                
                if ([entity.name isEqualToString:@"gamer"]) {
                    entity.imageName = @"program_gamer.png";
                }
                else if ([entity.name isEqualToString:@"wave"]) {
                    entity.imageName = @"program_wave.png";
                }
                else if ([entity.name isEqualToString:@"pulse"]) {
                    entity.imageName = @"program_pulse.png";
                }
                else if ([entity.name isEqualToString:@"enduro"]) {
                    entity.imageName = @"program_enduro.png";
                }
                else if ([entity.name isEqualToString:@"noise"]) {
                    entity.imageName = @"program_noise.png";
                }
                
                [programArray addObject:entity];
                NSLog(@"%@", [entity programDebugInfo]);
            }
        }
    }
    return [programArray sortedArrayUsingSelector:@selector(compare:)];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    if (_managedObjectModel == nil) {
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:kDataSchema withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    }
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (_persistentStoreCoordinator == nil) {
        
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:kStorePath];
        NSError *error = nil;
        NSString *failureReason = @"There was an error creating or loading the application's saved data.";

        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    
    if (managedObjectContext != nil) {
        NSError *error;
        
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
