//
// CTCStation
// KVC Validation Pattern
//
// Created by ncipollina on 2/19/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CTCBaseModel.h"

@class CTCAddress;


@interface CTCStation : CTCBaseModel

@property (nonatomic, strong) NSString		*stationName;
@property (nonatomic, strong) CTCAddress	*address;
@property (nonatomic, assign) BOOL			sellsDiesel;
@property (nonatomic, assign) CGFloat		price;
@property (nonatomic, strong) NSArray		*historicalPrices;

@end