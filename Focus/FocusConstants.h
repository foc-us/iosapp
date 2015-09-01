//
//  FocusUuids.h
//  Focus
//
//  Created by Jamie Lynch on 07/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Defines constants which are used by the Focus device.
 */
@interface FocusConstants : NSObject


/********************** Services **********************/


/**
 * The battery BLE service.
 */
extern NSString *const BLE_SERVICE_BATTERY;

/**
 * The information BLE service.
 */
extern NSString *const BLE_SERVICE_INFO;

/**
 * The Focus tDCS BLE service.
 */
extern NSString *const FOC_SERVICE_TDCS;

/**
 * The Focus BLE service.
 */
extern NSString *const FOC_SERVICE_UNKNOWN;


/********************** Characteristics **********************/


/**
 * A BLE characteristic which is used to write control commands to the Focus Device.
 * Several parameters such as sub-command IDs and Data are written as part of a byte array.
 */
extern NSString *const FOC_CHARACTERISTIC_CONTROL_CMD_REQUEST;

/**
 * A BLE characteristic which is used to read the device response to control commands.
 */
extern NSString *const FOC_CHARACTERISTIC_CONTROL_CMD_RESPONSE;

/**
 * A BLE characteristic which is used as a data buffer when reading the two program descriptors.
 */
extern NSString *const FOC_CHARACTERISTIC_DATA_BUFFER;

/**
 * A BLE characteristic which allows reading/notifying of the current on the device.
 */
extern NSString *const FOC_CHARACTERISTIC_ACTUAL_CURRENT;

/**
 * A BLE characteristic which allows reading/notifying of the playback time for a program.
 */
extern NSString *const FOC_CHARACTERISTIC_ACTIVE_MODE_DURATION;

/**
 * A BLE characteristic which allows reading/notifying of the remaining time for a program.
 */
extern NSString *const FOC_CHARACTERISTIC_ACTIVE_MODE_REMAINING_TIME;


/********************** Commands **********************/


/**
 * Activates sleep mode on the device and terminates the BLE connection.
 */
extern const Byte FOC_CMD_SLEEP_MODE;

/**
 * Manages programs on the device. This should be used in conjuction with the various
 * sub-commands.
 */
extern const Byte FOC_CMD_MANAGE_PROGRAMS;

/**
 * Returned if a command was successful.
 */
extern const Byte FOC_STATUS_CMD_SUCCESS;

/**
 * Returned if a command failed.
 */
extern const Byte FOC_STATUS_CMD_FAILURE;

/**
 * Returned if a command is unsupported.
 */
extern const Byte FOC_STATUS_CMD_UNSUPPORTED;


/********************** Sub-Commands **********************/


/**
 * Sub-command to find the maximum number of programs available on the device.
 */
extern const Byte FOC_SUBCMD_MAX_PROGRAMS;

/**
 * Sub-command to find the number of valid programs on the device.
 */
extern const Byte FOC_SUBCMD_VALID_PROGS;

/**
 * Sub-command to determine whether a program is enabled or not.
 */
extern const Byte FOC_SUBCMD_PROG_STATUS;

/**
 * Sub-command to read a program, which will update the data buffer.
 */
extern const Byte FOC_SUBCMD_READ_PROG;

/**
 * Sub-command to write a program, which will write the contents of the data buffer to
 * internal memory.
 */
extern const Byte FOC_SUBCMD_WRITE_PROG;

/**
 * Sub-command to enable a program.
 */
extern const Byte FOC_SUBCMD_ENABLE_PROG;

/**
 * Sub-command to disable a program.
 */
extern const Byte FOC_SUBCMD_DISABLE_PROG;

/**
 * Sub-command to start a program.
 */
extern const Byte FOC_SUBCMD_START_PROG;

/**
 * Sub-command to stop a program.
 */
extern const Byte FOC_SUBCMD_STOP_PROG;


/********************** Miscellaneous **********************/

/**
 * An empty byte when no value is required (0x00)
 */
extern const Byte FOC_EMPTY_BYTE;

/**
 * The ID for the first program descriptor.
 */
extern const Byte FOC_PROG_DESC_FIRST;

/**
 * The ID for the second program descriptor.
 */
extern const Byte FOC_PROG_DESC_SECOND;

/**
 * Returned if a program is valid.
 */
extern const int FOC_PROG_STATUS_VALID;

/**
 * Returned if a program is invalid.
 */
extern const int FOC_PROG_STATUS_INVALID;

extern NSString *const FOCUS_ERROR_DOMAIN;

@end
