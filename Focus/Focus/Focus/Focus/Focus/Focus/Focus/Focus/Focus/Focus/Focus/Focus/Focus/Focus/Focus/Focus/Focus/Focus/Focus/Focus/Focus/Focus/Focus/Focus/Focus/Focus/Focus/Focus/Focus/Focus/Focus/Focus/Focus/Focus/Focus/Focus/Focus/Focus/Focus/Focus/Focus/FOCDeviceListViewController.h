//
//  FOCDeviceListViewController.h
//  Focus
//
//  Created by Jamie Lynch on 25/08/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "FOCBleScanDelegate.h"

@interface FOCDeviceListViewController : UITableViewController<UITableViewDelegate, UITableViewDataSource, FOCBleScanDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
