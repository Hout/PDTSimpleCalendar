//
//  PDTSimpleCalendarTests.m
//  PDTSimpleCalendarTests
//
//  Created by Jeroen Houtzager on 10-03-14.
//  Copyright (c) 2014 Producteev. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "PDTSimpleCalendarViewCell.h"
#import "PDTSimpleCalendarViewCell+Private.h"

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


@interface PDTSimpleCalendarViewCellTests : XCTestCase <PDTSimpleCalendarViewCellDelegate>

@end

@implementation PDTSimpleCalendarViewCellTests

- (void)testDayLabelGregorian
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 5;
    dateComponents.month = 3;
    dateComponents.year = 2014;
    NSDate *date = [calendar dateFromComponents:dateComponents];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    [cell setDate:date calendar:calendar];

    XCTAssertTrue([cell.dayLabel.text isEqualToString:@"5"], @"Bad day formatting for Latin locale");
}

- (void)testDayLabelArab
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSIslamicCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ar_BH"];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 5;
    dateComponents.month = 3;
    dateComponents.year = 2014;
    NSDate *date = [calendar dateFromComponents:dateComponents];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    [cell setDate:date calendar:calendar];

    XCTAssertTrue([cell.dayLabel.text isEqualToString:@"٥"], @"Bad day formatting for Arab locale");
}

- (void)testDelegateTextColorNegative
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSIslamicCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ar_BH"];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 5;
    dateComponents.month = 3;
    dateComponents.year = 2014;
    NSDate *date = [calendar dateFromComponents:dateComponents];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.delegate = self;
    cell.dayLabel = [UILabel new];
    [cell setDate:date calendar:calendar];
    cell.selected = NO;
    cell.isEnabled = YES;
    cell.isToday = NO;

    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor blackColor]], @"Bad delegate color for cell");
    XCTAssertTrue([cell.dayLabel.backgroundColor isEqualToColor:[UIColor whiteColor]], @"Bad delegate color for cell");
}

- (void)testDelegateTextColorPositive
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSIslamicCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ar_BH"];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 6;
    dateComponents.month = 3;
    dateComponents.year = 2014;
    NSDate *date = [calendar dateFromComponents:dateComponents];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.delegate = self;
    cell.dayLabel = [UILabel new];
    [cell setDate:date calendar:calendar];
    cell.selected = NO;
    cell.isEnabled = YES;
    cell.isToday = NO;

    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor darkGrayColor]], @"Bad delegate color for cell");
    XCTAssertTrue([cell.dayLabel.backgroundColor isEqualToColor:[UIColor blueColor]], @"Bad delegate color for cell");
}

- (UIColor *)simpleCalendarViewCell:(PDTSimpleCalendarViewCell *)cell textColorForDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSIslamicCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ar_BH"];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 6;
    dateComponents.month = 3;
    dateComponents.year = 2014;
    NSDate *specialDate = [calendar dateFromComponents:dateComponents];

    // Only return dark gray on 6 March 214, otherwise return nil (=default)
    if ([date isEqualToDate:specialDate]) {
        return [UIColor darkGrayColor];
    }
    return nil;
}

- (UIColor *)simpleCalendarViewCell:(PDTSimpleCalendarViewCell *)cell circleColorForDate:(NSDate *)date {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSIslamicCalendar];
    calendar.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"ar_BH"];
    NSDateComponents *dateComponents = [NSDateComponents new];
    dateComponents.day = 6;
    dateComponents.month = 3;
    dateComponents.year = 2014;
    NSDate *specialDate = [calendar dateFromComponents:dateComponents];

    // Only return dark gray on 6 March 214, otherwise return nil (=default)
    if ([date isEqualToDate:specialDate]) {
        return [UIColor blueColor];
    }
    return nil;
}

- (void)testDisabledColor
{
    [[PDTSimpleCalendarViewCell appearance] setTextDisabledColor:nil];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = NO;
    cell.isEnabled = NO;
    cell.isToday = NO;

    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor lightGrayColor]], @"Bad disabled color for cell");
}

- (void)testDisabledColorAppearance
{
    [[PDTSimpleCalendarViewCell appearance] setTextDisabledColor:[UIColor purpleColor]];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = NO;
    cell.isEnabled = NO;
    cell.isToday = NO;

    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor purpleColor]], @"Bad disabled color for cell with appearance");
}

- (void)testNormalColor
{
    [[PDTSimpleCalendarViewCell appearance] setTextDefaultColor:nil];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = NO;
    cell.isEnabled = YES;
    cell.isToday = NO;

    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor blackColor]], @"Bad normal color for cell");
}

- (void)testNormalColorAppearance
{
    [[PDTSimpleCalendarViewCell appearance] setTextDefaultColor:[UIColor redColor]];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = NO;
    cell.isEnabled = YES;
    cell.isToday = NO;

    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor redColor]], @"Bad normal color for cell with appearance");
}

- (void)testTodayCircleColor
{
    [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:nil];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = NO;
    cell.isEnabled = YES;
    cell.isToday = YES;

    XCTAssertTrue([cell.dayLabel.backgroundColor isEqualToColor:[UIColor grayColor]], @"Bad today color for cell");
}

- (void)testTodayCircleColorAppearance
{
    [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:[UIColor blueColor]];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = NO;
    cell.isEnabled = YES;
    cell.isToday = YES;

    XCTAssertTrue([cell.dayLabel.backgroundColor isEqualToColor:[UIColor blueColor]], @"Bad today color for cell with appearance");
}

- (void)testTodayColorNoSelected
{
    [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:nil];
    [[PDTSimpleCalendarViewCell appearance] setTextTodayColor:nil];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = NO;
    cell.isEnabled = YES;
    cell.isToday = YES;

    XCTAssertTrue([cell.dayLabel.backgroundColor isEqualToColor:[UIColor grayColor]], @"Bad today circle color for cell");
    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor whiteColor]], @"Bad today text color for cell");
}

- (void)testTodayColorNoSelectedAppearance
{
    [[PDTSimpleCalendarViewCell appearance] setCircleTodayColor:[UIColor darkGrayColor]];
    [[PDTSimpleCalendarViewCell appearance] setTextTodayColor:[UIColor greenColor]];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = NO;
    cell.isEnabled = YES;
    cell.isToday = YES;

    XCTAssertTrue([cell.dayLabel.backgroundColor isEqualToColor:[UIColor darkGrayColor]], @"Bad today circle color for cell with appearance");
    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor greenColor]], @"Bad today text color for cell with appearance");
}

- (void)testSelectedColorToday
{
    [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:nil];
    [[PDTSimpleCalendarViewCell appearance] setTextSelectedColor:nil];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = YES;
    cell.isEnabled = YES;
    cell.isToday = YES;

    XCTAssertTrue([cell.dayLabel.backgroundColor isEqualToColor:[UIColor redColor]], @"Bad selected circle color for cell");
    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor whiteColor]], @"Bad selected text color for cell");
}

- (void)testSelectedColorTodayAppearance
{
    [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:[UIColor purpleColor]];
    [[PDTSimpleCalendarViewCell appearance] setTextSelectedColor:[UIColor yellowColor]];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = YES;
    cell.isEnabled = YES;
    cell.isToday = YES;

    XCTAssertTrue([cell.dayLabel.backgroundColor isEqualToColor:[UIColor purpleColor]], @"Bad selected color for cell");
    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor yellowColor]], @"Bad selected color for cell");
}

- (void)testSelectedColorNotToday
{
    [[PDTSimpleCalendarViewCell appearance] setTextSelectedColor:nil];
    [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:nil];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = YES;
    cell.isEnabled = YES;
    cell.isToday = NO;

    XCTAssertTrue([cell.dayLabel.backgroundColor isEqualToColor:[UIColor redColor]], @"Bad selected circle color for cell");
    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor whiteColor]], @"Bad selected text color for cell");
}

- (void)testSelectedColorNotTodayAppearance
{
    [[PDTSimpleCalendarViewCell appearance] setCircleSelectedColor:[UIColor purpleColor]];
    [[PDTSimpleCalendarViewCell appearance] setTextSelectedColor:[UIColor yellowColor]];

    PDTSimpleCalendarViewCell *cell = [PDTSimpleCalendarViewCell new];
    cell.dayLabel = [UILabel new];
    cell.selected = YES;
    cell.isEnabled = YES;
    cell.isToday = NO;

    XCTAssertTrue([cell.dayLabel.backgroundColor isEqualToColor:[UIColor purpleColor]], @"Bad selected color for cell");
    XCTAssertTrue([cell.dayLabel.textColor isEqualToColor:[UIColor yellowColor]], @"Bad selected color for cell");
}

@end
