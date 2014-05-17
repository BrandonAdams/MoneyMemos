//
//  TaxInformation.h
//  MoneyMemos
//
//  Created by Student on 5/17/14.
//  Copyright (c) 2014 Heartfire. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaxInformation : NSObject

@property (nonatomic, copy) NSString *geoPostalCode;
@property (nonatomic, copy) NSString *geoCity;
@property (nonatomic, copy) NSString *geoCountry;
@property (nonatomic, copy) NSString *geoState;
@property (nonatomic, assign) float taxSales;
@property (nonatomic, assign) float stateSalesTax;

-(instancetype) initWithDictionary:(NSDictionary *)dictionary;

@end
