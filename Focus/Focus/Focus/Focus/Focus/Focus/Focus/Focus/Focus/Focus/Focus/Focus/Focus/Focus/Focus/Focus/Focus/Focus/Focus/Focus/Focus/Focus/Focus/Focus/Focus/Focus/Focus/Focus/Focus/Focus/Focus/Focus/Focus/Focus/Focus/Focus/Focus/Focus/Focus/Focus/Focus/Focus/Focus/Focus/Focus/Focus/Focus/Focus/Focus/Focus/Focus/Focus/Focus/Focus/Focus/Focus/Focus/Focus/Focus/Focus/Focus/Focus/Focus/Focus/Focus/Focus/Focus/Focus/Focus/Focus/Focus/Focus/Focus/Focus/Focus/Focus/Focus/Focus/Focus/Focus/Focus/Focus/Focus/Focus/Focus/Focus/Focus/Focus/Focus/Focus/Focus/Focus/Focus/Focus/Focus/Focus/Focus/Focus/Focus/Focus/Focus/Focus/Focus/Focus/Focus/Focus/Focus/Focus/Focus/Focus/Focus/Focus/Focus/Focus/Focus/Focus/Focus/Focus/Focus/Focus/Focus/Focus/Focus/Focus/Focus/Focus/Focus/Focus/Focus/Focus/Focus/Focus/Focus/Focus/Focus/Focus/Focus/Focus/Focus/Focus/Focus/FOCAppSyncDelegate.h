//
//  FOCProgramSyncDelegate.h
//  Focus
//
//  Created by Jamie Lynch on 24/07/2015.
//  Copyright (c) 2015 Bearded Hen. All rights reserved.
//

#ifndef Focus_FOCAppSyncDelegate_h
#define Focus_FOCAppSyncDelegate_h

@protocol FOCAppSyncDelegate <NSObject>

- (void)didChangeDataSet:(NSArray *)dataSet;

@end

#endif
