//
//  DataStore.h
//  National Parks
//
//  Created by Student on 3/17/14.
//  Copyright (c) 2014 Brandon Adams. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Location.h"

@interface DataStore : NSObject

@property (nonatomic) NSMutableArray *allItems;
@property (nonatomic) Location *currentLocation;

+(instancetype)sharedStore;

@end
