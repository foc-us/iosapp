//
//  ReadProgramManager.h
//  Focus
//
//  Created by Jamie Lynch on 08/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;
@import QuartzCore;

/**
 * Reads a program stored on the Focus device.
 */
@interface ReadProgramManager : NSObject

- (id)initWithPeripheral:(CBPeripheral *)peripheral numPrograms:(int)numPrograms

@end
