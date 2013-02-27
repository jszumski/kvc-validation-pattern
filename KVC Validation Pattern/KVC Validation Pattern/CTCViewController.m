//
//  CTCViewController.m
//  KVC Validation Pattern
//
//  Created by John Szumski on 2/18/13.
//  Copyright (c) 2013 CapTech Consulting. All rights reserved.
//

#import "CTCViewController.h"
#import "CTCStation.h"
#import "CTCAddress.h"
#import "CTCHistoricalPrice.h"

typedef NS_ENUM(NSUInteger, CTCViewControllerSection) {
	CTCViewControllerSectionInfo				= 0,
	CTCViewControllerSectionHistoricalPrices	= 1
};


@implementation CTCViewController {
	CTCStation			*_currentStation;
	NSNumberFormatter	*_priceFormatter;
	NSDateFormatter		*_dateFormatter;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	// hide the source view by default
	self.sourceTextView.hidden = YES;
	
	// register for segmented control changes
	[self.responseSegmentedControl addTarget:self
									  action:@selector(responseSegmentedControlDidChange:)
							forControlEvents:UIControlEventValueChanged];
	
	// call it manually the first time
	[self responseSegmentedControlDidChange:self.responseSegmentedControl];
}

- (void)displayInfoForStation:(CTCStation*)station {
	_currentStation = station;
		
	[self.tableView reloadData];
}

- (NSString*)jsonStringForResponse:(NSUInteger)responseIndex {
	NSString *filename = nil;
	
	switch (responseIndex) {
		case 0:
		default:
			filename = @"ResponseA";
			break;
			
		case 1:
			filename = @"ResponseB";
			break;
			
		case 2:
			filename = @"ResponseC";
			break;
			
		case 3:
			filename = @"ResponseD";
			break;
			
		case 4:
			filename = @"ResponseE";
			break;
	}
	
	return [NSString stringWithContentsOfFile:[[NSBundle mainBundle] pathForResource:filename ofType:@"json"] encoding:NSUTF8StringEncoding error:nil];
}


#pragma mark - UI response

- (IBAction)viewJSONTapped:(id)sender {	
	// toggle source view
	if (self.sourceTextView.hidden == YES) {
		self.sourceTextView.hidden = NO;
		self.tableView.hidden = YES;
		
		self.viewJSONButton.title = NSLocalizedString(@"Hide JSON", nil);
			
	} else {
		self.sourceTextView.hidden = YES;
		self.tableView.hidden = NO;
		
		self.viewJSONButton.title = NSLocalizedString(@"Show JSON", nil);
	}
}

- (void)responseSegmentedControlDidChange:(id)sender {
	NSString *json = [self jsonStringForResponse:self.responseSegmentedControl.selectedSegmentIndex];
	
	
	// update source view
	self.sourceTextView.text = json;
	
	
	// parse and update station
	NSError *error = nil;
	NSDictionary *stationDictionary = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
																	  options:kNilOptions
																		error:&error];

	if (error != nil) {
		NSLog(@"Unable to parse JSON into store:\n %@", json);
		return;
	}
	
	CTCStation *newStation = [[CTCStation alloc] init];
	[newStation setValuesForKeysWithDictionary:stationDictionary];
	[self displayInfoForStation:newStation];
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == CTCViewControllerSectionInfo) {
		return 4;
		
	} else if (section == CTCViewControllerSectionHistoricalPrices) {
		return [_currentStation.historicalPrices count];
	}
	
	return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	// make the Address cell tall enough for two lines
	if (indexPath.section == CTCViewControllerSectionInfo && indexPath.row == 3) {
		return 66.0;
	}
	
	return 44.0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	if (section == CTCViewControllerSectionHistoricalPrices) {
		return NSLocalizedString(@"Historical Prices", nil);
	}
	
	return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if (section == CTCViewControllerSectionHistoricalPrices &&
		[self tableView:tableView numberOfRowsInSection:section] == 0) {
		
		return NSLocalizedString(@"No historical information is available.", nil);
	}
	
	return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	static NSString *cellId = @"value1Cell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
	
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellId];		
	}
	
	cell.detailTextLabel.numberOfLines = 1;
	
	if (indexPath.section == CTCViewControllerSectionInfo) {

		if (indexPath.row == 0) {
			cell.textLabel.text = NSLocalizedString(@"Name", nil);
			cell.detailTextLabel.text = _currentStation.stationName;
			
			
		} else if (indexPath.row == 1) {
			cell.textLabel.text = NSLocalizedString(@"Price", nil);
			cell.detailTextLabel.text = [self stringForPrice:_currentStation.price];
		
			
		} else if (indexPath.row == 2) {
			cell.textLabel.text = NSLocalizedString(@"Sells Diesel", nil);
			cell.detailTextLabel.text = _currentStation.sellsDiesel ? NSLocalizedString(@"Yes", nil) : NSLocalizedString(@"No", nil);
			
			
		} else if (indexPath.row == 3) {
			CTCAddress *address = _currentStation.address;
			
			cell.textLabel.text = NSLocalizedString(@"Address", nil);
			
			if (address != nil) {
				cell.detailTextLabel.text = [NSString stringWithFormat:@"%@\n %@, %@ %@", address.street, address.city, address.state, address.zip];
			} else {
                cell.detailTextLabel.text = @"\n "; // prevents Address label from jumping around between real and empty strings
            }
			
			cell.detailTextLabel.numberOfLines = 2;
		}
	
	} else if (indexPath.section == CTCViewControllerSectionHistoricalPrices) {
		CTCHistoricalPrice *historicalPrice = [_currentStation.historicalPrices objectAtIndex:indexPath.row];
		
		cell.textLabel.text = [self stringForDate:historicalPrice.date];
		cell.detailTextLabel.text = [self stringForPrice:historicalPrice.price];
	}

	return cell;
}


#pragma mark - Formatting

- (NSString*)stringForPrice:(CGFloat)price {
	// this can only be called from the main thread
	static dispatch_once_t priceFormatterOnceToken;
	dispatch_once(&priceFormatterOnceToken, ^{
		_priceFormatter = [[NSNumberFormatter alloc] init];
		[_priceFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
	});
	
	return [_priceFormatter stringFromNumber:[NSNumber numberWithFloat:price]];
}

- (NSString*)stringForDate:(NSDate*)date {
	// this can only be called from the main thread
	
	static dispatch_once_t dateFormatterOnceToken;
	dispatch_once(&dateFormatterOnceToken, ^{
		_dateFormatter = [[NSDateFormatter alloc] init];
		[_dateFormatter setDateStyle:NSDateFormatterShortStyle];
		[_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
	});
	
	return [_dateFormatter stringFromDate:date];
}

@end