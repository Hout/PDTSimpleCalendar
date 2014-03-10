//
//  PDTSimpleCalendarTests.m
//  PDTSimpleCalendarTests
//
//  Created by Jeroen Houtzager on 10-03-14.
//  Copyright (c) 2014 Producteev. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PDTSimpleCalendarViewController.h"

@implementation UIColor (Compare)

- (BOOL)isEqualToColor:(UIColor *)otherColor {
    CGColorSpaceRef colorSpaceRGB = CGColorSpaceCreateDeviceRGB();

    UIColor *(^convertColorToRGBSpace)(UIColor*) = ^(UIColor *color) {
        if(CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor)) == kCGColorSpaceModelMonochrome) {
            const CGFloat *oldComponents = CGColorGetComponents(color.CGColor);
            CGFloat components[4] = {oldComponents[0], oldComponents[0], oldComponents[0], oldComponents[1]};
            return [UIColor colorWithCGColor:CGColorCreate(colorSpaceRGB, components)];
        } else
            return color;
    };

    UIColor *selfColor = convertColorToRGBSpace(self);
    otherColor = convertColorToRGBSpace(otherColor);
    CGColorSpaceRelease(colorSpaceRGB);

    return [selfColor isEqual:otherColor];
}

@end


@interface PDTSimpleCalendarViewControllerTests : XCTestCase <PDTSimpleCalendarViewDelegate>

@end

@implementation PDTSimpleCalendarViewControllerTests

- (void)testDaysPerWeek
{
    XCTAssertTrue(PDTSimpleCalendarDaysPerWeek == 7, @"Bad number of days per week");
}


- (void)testDefaultFirstDate
{
    PDTSimpleCalendarViewController *simpleCalendarViewController = [PDTSimpleCalendarViewController new];
    simpleCalendarViewController.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *dateComponents = [simpleCalendarViewController.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    dateComponents.day = 1;
    NSDate *expectedDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];

    XCTAssertTrue([simpleCalendarViewController.firstDate isEqualToDate:expectedDate], @"Bad default first date");
}

- (void)testDefaultLastDate
{
    PDTSimpleCalendarViewController *simpleCalendarViewController = [PDTSimpleCalendarViewController new];
    simpleCalendarViewController.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *dateComponents = [simpleCalendarViewController.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    dateComponents.day = 0;
    dateComponents.month = 1;
    dateComponents.year += 2;
    NSDate *expectedDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];

    XCTAssertTrue([simpleCalendarViewController.lastDate isEqualToDate:expectedDate], @"Bad default last date");
}

- (void)testSelectDateTooEarly
{
    PDTSimpleCalendarViewController *simpleCalendarViewController = [PDTSimpleCalendarViewController new];
    simpleCalendarViewController.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *dateComponents = [simpleCalendarViewController.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    dateComponents.day = 1;
    dateComponents.month = 2;
    simpleCalendarViewController.firstDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];
    dateComponents.month = 3;
    simpleCalendarViewController.lastDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];
    dateComponents.month = 1;
    simpleCalendarViewController.selectedDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];

    XCTAssertTrue(simpleCalendarViewController.selectedDate == nil, @"Select date before first date should fail");
}

- (void)testSelectDateTooLate
{
    PDTSimpleCalendarViewController *simpleCalendarViewController = [PDTSimpleCalendarViewController new];
    simpleCalendarViewController.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *dateComponents = [simpleCalendarViewController.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    dateComponents.day = 1;
    dateComponents.month = 2;
    simpleCalendarViewController.firstDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];
    dateComponents.month = 3;
    simpleCalendarViewController.lastDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];
    dateComponents.month = 4;
    simpleCalendarViewController.selectedDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];

    XCTAssertTrue(simpleCalendarViewController.selectedDate == nil, @"Select date after last date should fail");
}

- (void)testSelectDateOk
{
    PDTSimpleCalendarViewController *simpleCalendarViewController = [PDTSimpleCalendarViewController new];
    simpleCalendarViewController.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *dateComponents = [simpleCalendarViewController.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    dateComponents.day = 1;
    dateComponents.month = 2;
    simpleCalendarViewController.firstDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];
    dateComponents.month = 4;
    simpleCalendarViewController.lastDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];
    dateComponents.month = 3;
    NSDate *selectedDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];
    simpleCalendarViewController.selectedDate = selectedDate;

    XCTAssertTrue([simpleCalendarViewController.selectedDate isEqualToDate:selectedDate], @"Select date in range should be ok");
}


- (void)testDelegateSelectDate
{
    PDTSimpleCalendarViewController *simpleCalendarViewController = [PDTSimpleCalendarViewController new];
    simpleCalendarViewController.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *dateComponents = [simpleCalendarViewController.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    dateComponents.day = 21;
    dateComponents.month = 2;
    simpleCalendarViewController.firstDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];
    dateComponents.month = 4;
    simpleCalendarViewController.lastDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];
    dateComponents.month = 3;
    NSDate *selectedDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];

    simpleCalendarViewController.delegate = self;
    simpleCalendarViewController.selectedDate = selectedDate;

    // Testing takes place in delegate
}

- (void)testDelegateDisableDate
{
    PDTSimpleCalendarViewController *simpleCalendarViewController = [PDTSimpleCalendarViewController new];
    simpleCalendarViewController.calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *dateComponents = [simpleCalendarViewController.calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    dateComponents.day = 20;
    dateComponents.month = 2;
    dateComponents.year = 2014;
   simpleCalendarViewController.firstDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];
    dateComponents.month = 4;
    simpleCalendarViewController.lastDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];
    dateComponents.month = 3;
    NSDate *selectedDate = [simpleCalendarViewController.calendar dateFromComponents:dateComponents];

    simpleCalendarViewController.delegate = self;
    simpleCalendarViewController.selectedDate = selectedDate;

    // 20 March should be disabled, selected date should be nil
    XCTAssertTrue(simpleCalendarViewController.selectedDate == nil, @"Selected date should be nil ad date is disabled in delegate");
}

- (void)simpleCalendarViewController:(PDTSimpleCalendarViewController*)controller didSelectDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    dateComponents.day = 21;
    dateComponents.month = 3;
    dateComponents.year = 2014;
    NSDate *expectedDate = [calendar dateFromComponents:dateComponents];

    XCTAssertTrue([date isEqualToDate:expectedDate], @"Selected date is not the expected date");
}

- (BOOL)simpleCalendarDateIsEnabled:(NSDate *)date {
    // Disable 20 March 2014
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:[NSDate date]];
    dateComponents.day = 20;
    dateComponents.month = 3;
    dateComponents.year = 2014;
    NSDate *specialDate = [calendar dateFromComponents:dateComponents];

    return ![date isEqualToDate:specialDate];
}


@end
