//
//  FocusUuids.m
//  Focus
//
//  Created by Jamie Lynch on 07/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FocusConstants.h"

@implementation FocusConstants

NSString *const FOCUS_ERROR_DOMAIN = @"FOCUS_ERROR_DOMAIN";

NSString *const BLE_SERVICE_BATTERY = @"180F";
NSString *const BLE_SERVICE_INFO = @"180A";
NSString *const FOC_SERVICE_UNKNOWN = @"0000AA10-F845-40FA-995D-658A43FEEA4C";
NSString *const FOC_SERVICE_TDCS = @"0000AAB0-F845-40FA-995D-658A43FEEA4C";

NSString *const FOC_CHARACTERISTIC_CONTROL_CMD_REQUEST = @"0000AAB1-F845-40FA-995D-658A43FEEA4C";
NSString *const FOC_CHARACTERISTIC_CONTROL_CMD_RESPONSE = @"0000AAB2-F845-40FA-995D-658A43FEEA4C";
NSString *const FOC_CHARACTERISTIC_DATA_BUFFER = @"0000AAB3-F845-40FA-995D-658A43FEEA4C";
NSString *const FOC_CHARACTERISTIC_ACTUAL_CURRENT = @"0000AAB4-F845-40FA-995D-658A43FEEA4C";
NSString *const FOC_CHARACTERISTIC_ACTIVE_MODE_DURATION = @"0000AAB5-F845-40FA-995D-658A43FEEA4C";
NSString *const FOC_CHARACTERISTIC_ACTIVE_MODE_REMAINING_TIME = @"0000AAB6-F845-40FA-995D-658A43FEEA4C";

const Byte FOC_EMPTY_BYTE = 0x00;
const Byte FOC_STATUS_CMD_SUCCESS = 0x00;
const Byte FOC_STATUS_CMD_FAILURE = 0x01;
const Byte FOC_STATUS_CMD_UNSUPPORTED = 0x02;

const Byte FOC_CMD_SLEEP_MODE = 0x00;
const Byte FOC_CMD_DISPLAY_MODE = 0x01;
const Byte FOC_CMD_MANAGE_PROGRAMS = 0x02;

const Byte FOC_SUBCMD_MAX_PROGRAMS = 0x00;
const Byte FOC_SUBCMD_VALID_PROGS = 0x01;
const Byte FOC_SUBCMD_PROG_STATUS = 0x02;
const Byte FOC_SUBCMD_READ_PROG = 0x03;
const Byte FOC_SUBCMD_WRITE_PROG = 0x04;
const Byte FOC_SUBCMD_ENABLE_PROG = 0x05;
const Byte FOC_SUBCMD_DISABLE_PROG = 0x06;
const Byte FOC_SUBCMD_START_PROG = 0x07;
const Byte FOC_SUBCMD_STOP_PROG = 0x08;

const Byte FOC_PROG_DESC_FIRST = 0x00;
const Byte FOC_PROG_DESC_SECOND = 0x01;

const int FOC_PROG_STATUS_VALID = 1;
const int FOC_PROG_STATUS_INVALID = 0;

@end
