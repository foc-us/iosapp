//
//  FOCDefaultProgramProvider.m
//  Focus
//
//  Created by Jamie Lynch on 14/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import "FOCDefaultProgramProvider.h"

@implementation FOCDefaultProgramProvider

+(FOCDeviceProgramEntity *)gamer
{
    FOCDeviceProgramEntity *entity = [[FOCDeviceProgramEntity alloc] init];
    entity.name = @"Gamer";
    entity.imageName = @"program_gamer.png";

    entity.programId = [[NSNumber alloc] initWithInt:-1];
    entity.programMode = DCS;
    entity.current = [[NSNumber alloc] initWithInt:1500];
    entity.duration = [[NSNumber alloc] initWithInt:600];
    entity.voltage = [[NSNumber alloc] initWithInt:20];
    entity.sham = [[NSNumber alloc] initWithBool:false];
    entity.shamDuration = [[NSNumber alloc] initWithInt:35];
    
    return entity;
}

+(FOCDeviceProgramEntity *)enduro
{
    FOCDeviceProgramEntity *entity = [[FOCDeviceProgramEntity alloc] init];
    entity.name = @"Enduro";
    entity.imageName = @"program_enduro.png";
    
    entity.programId = [[NSNumber alloc] initWithInt:-1];
    entity.programMode = DCS;
    entity.current = [[NSNumber alloc] initWithInt:1700];
    entity.duration = [[NSNumber alloc] initWithInt:900];
    entity.voltage = [[NSNumber alloc] initWithInt:20];
    entity.sham = [[NSNumber alloc] initWithBool:false];
    entity.shamDuration = [[NSNumber alloc] initWithInt:45];
    
    return entity;
}

+(FOCDeviceProgramEntity *)wave
{
    FOCDeviceProgramEntity *entity = [[FOCDeviceProgramEntity alloc] init];
    entity.name = @"Wave";
    entity.imageName = @"program_wave.png";
    
    entity.programId = [[NSNumber alloc] initWithInt:-1];
    entity.programMode = ACS;
    entity.current = [[NSNumber alloc] initWithInt:1500];
    entity.duration = [[NSNumber alloc] initWithInt:1080];
    entity.voltage = [[NSNumber alloc] initWithInt:30];
    entity.sham = [[NSNumber alloc] initWithBool:false];
    entity.shamDuration = [[NSNumber alloc] initWithInt:25];
    
    entity.bipolar = [NSNumber numberWithBool:true];
    entity.currentOffset = [[NSNumber alloc] initWithInt:100];
    entity.frequency = [[NSNumber alloc] initWithInt:1000];
    
    return entity;
}

+(FOCDeviceProgramEntity *)pulse
{
    FOCDeviceProgramEntity *entity = [[FOCDeviceProgramEntity alloc] init];
    entity.name = @"Pulse";
    entity.imageName = @"program_pulse.png";
    
    entity.programId = [[NSNumber alloc] initWithInt:-1];
    entity.programMode = PCS;
    entity.current = [[NSNumber alloc] initWithInt:1500];
    entity.duration = [[NSNumber alloc] initWithInt:600];
    entity.voltage = [[NSNumber alloc] initWithInt:15];
    entity.sham = [[NSNumber alloc] initWithBool:false];
    entity.bipolar = [[NSNumber alloc] initWithBool:false];
    entity.shamDuration = [[NSNumber alloc] initWithInt:25];
    
    entity.currentOffset = [[NSNumber alloc] initWithInt:1200];
    entity.frequency = [[NSNumber alloc] initWithInt:40000];
    entity.dutyCycle = [[NSNumber alloc] initWithInt:20];
    
    return entity;
}

+(FOCDeviceProgramEntity *)noise
{
    FOCDeviceProgramEntity *entity = [[FOCDeviceProgramEntity alloc] init];
    entity.name = @"Noise";
    entity.imageName = @"program_noise.png";
    
    entity.programId = [[NSNumber alloc] initWithInt:-1];
    entity.programMode = RNS;
    entity.current = [[NSNumber alloc] initWithInt:1600];
    entity.duration = [[NSNumber alloc] initWithInt:600];
    entity.voltage = [[NSNumber alloc] initWithInt:20];
    entity.sham = [[NSNumber alloc] initWithBool:false];
    entity.bipolar = [[NSNumber alloc] initWithBool:false];
    entity.shamDuration = [[NSNumber alloc] initWithInt:25];
    
    entity.frequency = [[NSNumber alloc] initWithInt:1000];
    entity.randomCurrent = [NSNumber numberWithBool:true];
    entity.randomFrequency = [NSNumber numberWithBool:true];
    
    return entity;
}

+(NSArray *) allDefaults
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[self gamer]];
    [array addObject:[self enduro]];
    [array addObject:[self wave]];
    [array addObject:[self pulse]];
    [array addObject:[self noise]];
    return array;
}

@end
