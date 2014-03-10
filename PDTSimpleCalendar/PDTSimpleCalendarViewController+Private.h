//
//  PDTSimpleCalendarViewController.h
//  PDTSimpleCalendar
//
//  Created by Jerome Miglino on 10/7/13.
//  Copyright (c) 2013 Producteev. All rights reserved.
//

#import "PDTSimpleCalendarViewCell.h"

@interface PDTSimpleCalendarViewController () <PDTSimpleCalendarViewCellDelegate>

@property (nonatomic, strong) UILabel *overlayView;
@property (nonatomic, strong) NSDateFormatter *headerDateFormatter; //Will be used to format date in header view and on scroll.

// First and last date of the months based on the public properties first & lastDate
@property (nonatomic, readonly) NSDate *firstDateMonth;
@property (nonatomic, readonly) NSDate *lastDateMonth;

- (PDTSimpleCalendarViewCell *)cellForItemAtDate:(NSDate *)date;

@end


