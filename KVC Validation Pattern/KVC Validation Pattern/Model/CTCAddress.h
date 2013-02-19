//
// CTCAddress
// KVC Validation Pattern
//
// Created by ncipollina on 2/19/13.
// Copyright 2013 CapTech Consulting.  All rights reserved.
//


#import <Foundation/Foundation.h>
#import "CTCBaseModel.h"


@interface CTCAddress : CTCBaseModel

@property (nonatomic, strong) NSString *street;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *state;
@property (nonatomic, strong) NSString *zip;

@end