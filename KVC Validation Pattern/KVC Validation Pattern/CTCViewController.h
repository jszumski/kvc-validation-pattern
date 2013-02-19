//
//  CTCViewController.h
//  KVC Validation Pattern
//
//  Created by John Szumski on 2/18/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CTCViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property(nonatomic,strong) IBOutlet UITextView			*sourceTextView;
@property(nonatomic,strong) IBOutlet UITableView		*tableView;
@property(nonatomic,strong) IBOutlet UIBarButtonItem	*viewJSONButton;
@property(nonatomic,strong) IBOutlet UISegmentedControl	*responseSegmentedControl;

@end