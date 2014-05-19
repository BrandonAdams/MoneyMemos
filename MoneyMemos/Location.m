//
//  Location.m
//  MoneyMemos
//
//  Created by Student on 5/14/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import "Location.h"

@implementation Location

-(id)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.name = dictionary[@"name"] ?  dictionary[@"name"] : @"New Location";
        self.zip = dictionary[@"zip"] ? [dictionary[@"zip"]intValue] : -1;
        self.entries = [NSMutableArray array];
    }
    
    return self;
}
-(int)locationZip{
    return _zip;
}

-(NSString *)locationName{
    return _name;
}

@end
