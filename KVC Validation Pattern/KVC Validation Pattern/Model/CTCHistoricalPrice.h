//
// CTCHistoricalPrice
// KVC Validation Pattern
//
// Created by ncipollina on 2/19/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CTCBaseModel.h"


@interface CTCHistoricalPrice : CTCBaseModel

@property (nonatomic, strong) NSDate	*date;
@property (nonatomic, assign) CGFloat	price;

@end