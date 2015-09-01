//
//  CoreDataProgram.h
//  Focus
//
//  Created by Jamie Lynch on 16/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

/**
 * A model that is used to store the state of a Focus program in CoreData.
 * Bool/Int/Long fields are boxed as NSNumbers.
 */
@interface CoreDataProgram : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * programId;
@property (nonatomic, retain) NSString * imageName;
@property (nonatomic, retain) NSNumber * programMode;
@property (nonatomic, retain) NSNumber * valid;
@property (nonatomic, retain) NSNumber * sham;
@property (nonatomic, retain) NSNumber * bipolar;
@property (nonatomic, retain) NSNumber * randomCurrent;
@property (nonatomic, retain) NSNumber * randomFrequency;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * current;
@property (nonatomic, retain) NSNumber * voltage;
@property (nonatomic, retain) NSNumber * shamDuration;
@property (nonatomic, retain) NSNumber * currentOffset;
@property (nonatomic, retain) NSNumber * frequency;
@property (nonatomic, retain) NSNumber * dutyCycle;
@property (nonatomic, retain) NSNumber * minFrequency;
@property (nonatomic, retain) NSNumber * maxFrequency;

@end
