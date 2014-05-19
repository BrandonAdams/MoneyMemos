//
//  Location.h
//  MoneyMemos
//
//  Created by Student on 5/14/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject

@property (copy, nonatomic) NSString *name;
@property (nonatomic) int zip;
@property (nonatomic) float tax;

@property (strong, nonatomic) NSMutableArray *entries;

-(id)initWithDictionary:(NSDictionary *)dictionary;
-(int)locationZip;
-(NSString *)locationName;


@end
