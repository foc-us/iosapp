//
//  FOCDeviceListViewController.m
//  Focus
//
//  Created by Jamie Lynch on 25/08/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCDeviceListViewController.h"
#import "FOCDeviceManager.h"
#import "FOCAppDelegate.h"

static NSString *kCellIdentifier = @"DeviceTableItem";

@interface FOCDeviceListViewController ()
@property NSMutableArray *deviceList;
@property FOCDeviceManager *deviceManager;
@end

@implementation FOCDeviceListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self =[super initWithCoder:aDecoder]) {
        _deviceList = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)didDiscoverFocusDevice:(id)peripheral
{
    [_deviceList addObject:peripheral];
    [self.tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    FOCAppDelegate *delegate = (FOCAppDelegate *) [[UIApplication sharedApplication] delegate];
    _deviceManager = delegate.focusDeviceManager;
    _deviceManager.scanningDelegate = self;
    
    [_deviceManager scanForFocusPeripherals];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_deviceList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
    }
    
    CBPeripheral *peripheral = [_deviceList objectAtIndex:indexPath.row];
    NSString *deviceName = [NSString stringWithFormat:@"%@ - %@", peripheral.name, peripheral.identifier.UUIDString];
    
    cell.textLabel.text = deviceName;
    return cell;
}

- (IBAction)didSelectDone:(id)sender
{
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    CBPeripheral *peripheral;
    
    if (indexPath != nil) {
        peripheral = [_deviceList objectAtIndex:indexPath.row];
    }
    
    [_deviceManager useNewFocusDevice:peripheral];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
