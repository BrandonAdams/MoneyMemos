//
//  TaxInformation.m
//  MoneyMemos
//
//  Created by Student on 5/17/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import "TaxInformation.h"

@implementation TaxInformation

- (instancetype)initWithDictionary:(NSDictionary *)dictionary{
    self = [super init];
    if (self) {
        self.geoPostalCode = dictionary[@"geoPostalCode"] ? dictionary[@"geoPostalCode"] : @"";
        self.geoCity = dictionary[@"geoCity"] ? dictionary[@"geoCity"] : @"";
        self.geoCountry = dictionary[@"geoCountry"]? dictionary[@"geoCountry"] : @"";
        self.geoState = dictionary[@"geoState"] ? dictionary[@"geoState"] : @"";
        self.taxSales = [dictionary[@"taxSales"]floatValue];
        self.stateSalesTax = [dictionary[@"stateSalesTax"]floatValue];
    }
    
    return self;
}

@end
