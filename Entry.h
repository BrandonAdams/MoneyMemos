//
//  Entry.h
//  MoneyMemos
//
//  Created by Student on 5/18/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entry : NSObject

@property (nonatomic) float amount;
@property (copy, nonatomic) NSString *type;

-(id)initWithDictionary:(NSDictionary *)dictionary;

@end
