//
//  CTCViewController.m
//  KVC Validation Pattern
//
//  Created by John Szumski on 2/18/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import "CTCViewController.h"

typedef NS_ENUM(NSUInteger, CTVViewControllerSection) {
	CTVViewControllerSectionInfo				= 0,
	CTVViewControllerSectionHistoricalPrices	= 1
};

@implementation CTCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// register for segmented control changes
	[self.responseSegmentedControl addTarget:self
									  action:@selector(responseSegmentedControlDidChange:)
							forControlEvents:UIControlEventValueChanged];
	
	// call it manually the first time
	[self responseSegmentedControlDidChange:self.responseSegmentedControl];
}


#pragma mark - UI response

- (IBAction)viewJSONTapped:(id)sender {
	NSLog(@"View JSON tapped");
}

- (void)responseSegmentedControlDidChange:(id)sender {
	NSLog(@"Response changed to %@", [self.responseSegmentedControl titleForSegmentAtIndex:self.responseSegmentedControl.selectedSegmentIndex]);
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == CTVViewControllerSectionInfo) {
		return 4;
		
	} else if (section == CTVViewControllerSectionHistoricalPrices) {
		return 4;
	}
	
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// make the Address cell tall enough for two lines
	if (indexPath.section == CTVViewControllerSectionInfo && indexPath.row == 3) {
		return 66.0;
	}
	
	return 44.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == CTVViewControllerSectionHistoricalPrices) {
		return NSLocalizedString(@"Historical Prices", nil);
	}
	
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellId = @"value1Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];
		
		cell.detailTextLabel.numberOfLines = 2;
	}
	
	if (indexPath.section == CTVViewControllerSectionInfo) {
		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(@"Name", nil);
			cell.detailTextLabel.text = @"Example Station";
			
		} else if (indexPath.row == 1) {
			cell.textLabel.text = NSLocalizedString(@"Price", nil);
			cell.detailTextLabel.text = @"$3.50";
		
		} else if (indexPath.row == 2) {
			cell.textLabel.text = NSLocalizedString(@"Sells Diesel", nil);
			cell.detailTextLabel.text = @"Yes";
			
		} else if (indexPath.row == 3) {
			cell.textLabel.text = NSLocalizedString(@"Address", nil);
			cell.detailTextLabel.text = @"123 Fake Street\nRichmond, VA 23229";
		}
	
	} else if (indexPath.section == CTVViewControllerSectionHistoricalPrices) {
		cell.textLabel.text = @"1/1/11";
		cell.detailTextLabel.text = @"$3.50";
	}

	return cell;
}

@end