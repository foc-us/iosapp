//
//  FOCBasePeripheralManager.h
//  Focus
//
//  Created by Jamie Lynch on 09/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

@import CoreBluetooth;
@import QuartzCore;

#import "FocusConstants.h"

/**
 * A base manager class which contains useful functionality for interacting with the Focus
 * device e.g., human-friendly logging, command response deserialisation, etc
 */
@interface FOCBasePeripheralManager : NSObject<CBPeripheralDelegate>

/**
 * Initialises a new manager instance with the given peripheral.
 */
- (id)initWithPeripheral:(CBPeripheral *) focusDevice;

/**
 * Returns a human-friendly name for a peripheral service.
 */
- (NSString *)loggableServiceName:(CBService *)service;

/**
 * Returns a human-friendly name for a peripheral characteristic.
 */
- (NSString *)loggableCharacteristicName:(CBCharacteristic *)characteristic;

/**
 * Constructs a command request byte array.
 */
- (NSData *)constructCommandRequest:(Byte)cmdId subCmdId:(Byte)subCmdId;

/**
 * Constructs a command request byte array.
 */
- (NSData *)constructCommandRequest:(Byte)cmdId subCmdId:(Byte)subCmdId progId:(Byte)progId progDescId:(Byte)progDescId;

/**
 * Called when an error occurred reading the command response
 */
- (void)interpretCommandResponse:(NSError *)error;

/**
 * Called when the command response is interpreted
 */
- (void)interpretCommandResponse:(Byte)cmdId status:(Byte)status data:(const unsigned char *)data characteristic:(CBCharacteristic *)characteristic;

/**
 * Deserialises a command response byte array into its useful parts, and calls
 * [self interpretCommandResponse]
 */
- (void)deserialiseCommandResponse:(CBCharacteristic *)characteristic;

@property CBPeripheral *focusDevice;

@end