//
//  Entry.m
//  MoneyMemos
//
//  Created by Student on 5/18/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import "Entry.h"

@implementation Entry

-(id)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self)
    {
        self.amount = dictionary[@"amount"] ?  [dictionary[@"amount"]floatValue] : 0;
        self.type = dictionary[@"type"] ? dictionary[@"type"] : @"MISC";
    }
    
    return self;
}//initWithDictionary

@end
