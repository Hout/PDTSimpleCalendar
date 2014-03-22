//
//  PDTSimpleCalendarViewHeader.m
//  PDTSimpleCalendar
//
//  Created by Jerome Miglino on 10/8/13.
//  Copyright (c) 2013 Producteev. All rights reserved.
//

#import "PDTSimpleCalendarViewHeader.h"

const CGFloat PDTSimpleCalendarHeaderMonthTextSize = 12.0f;
const CGFloat PDTSimpleCalendarHeaderWeekdayTextSize = 12.0f;

@interface PDTSimpleCalendarViewHeader ()

/**
 *  View that contains the weekdays
 */
@property (nonatomic, strong) UIView *weekdayView;

@end


@implementation PDTSimpleCalendarViewHeader

@synthesize weekdays = _weekdays;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }

    // Initialization code
    _titleLabel = [[UILabel alloc] init];
    [_titleLabel setFont:[UIFont systemFontOfSize:PDTSimpleCalendarHeaderMonthTextSize]];
    [_titleLabel setTextColor:self.textColor];
    [_titleLabel setBackgroundColor:self.backgroundColor];
    [self addSubview:_titleLabel];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];

    _weekdayView = [[UIView alloc] init];
    [_weekdayView setBackgroundColor:self.backgroundColor];
    [self addSubview:_weekdayView];
    [_weekdayView setTranslatesAutoresizingMaskIntoConstraints:NO];

    UIView *separatorView = [[UIView alloc] init];
    [separatorView setBackgroundColor:self.separatorColor];
    [self addSubview:separatorView];
    [separatorView setTranslatesAutoresizingMaskIntoConstraints:NO];

    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    NSDictionary *metricsDictionary = @{@"onePixel" : [NSNumber numberWithFloat:onePixel]};
    NSDictionary *viewsDictionary = @{@"titleLabel" : self.titleLabel, @"weekdayView": self.weekdayView, @"separatorView" : separatorView};

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-(==10)-[titleLabel]-(==10)-|" options:0 metrics:nil views:viewsDictionary]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[weekdayView]|" options:0 metrics:nil views:viewsDictionary]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[separatorView]|" options:0 metrics:nil views:viewsDictionary]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[titleLabel]-(==10)-[weekdayView]-(==10)-[separatorView]" options:0 metrics:nil views:viewsDictionary]];

    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorView(==onePixel)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];

    [self fillWeekdays];
    return self;
}


#pragma mark - Fill weekdays

-(void)fillWeekdays {
    if (![self.weekdays count]) {
        return;
    }

    // Fill weekdayView with labels
    NSMutableDictionary *labelsDictionary = [[NSMutableDictionary alloc] initWithCapacity:[self.weekdays count]];
    for (NSUInteger index = 0; index < [self.weekdays count]; index++) {
        UILabel *weekdayLabel = [[UILabel alloc] init];
        weekdayLabel.font = [UIFont systemFontOfSize:PDTSimpleCalendarHeaderWeekdayTextSize];
        weekdayLabel.text = self.weekdays[index];
        weekdayLabel.textColor = self.textColor;
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.backgroundColor = self.backgroundColor;
        [_weekdayView addSubview:weekdayLabel];
        weekdayLabel.translatesAutoresizingMaskIntoConstraints = NO;
       [labelsDictionary setObject:weekdayLabel forKey:[NSString stringWithFormat:@"weekdayLabel%d", index]];

    }

    // Construct horizontal layout string to "|[weekdayLabel0] ... [weekdayLabelN]|"
    NSString *layoutString = @"|[weekdayLabel0]";
    for (NSUInteger index = 1; index < [self.weekdays count]; index++) {
        layoutString = [layoutString stringByAppendingFormat:@"[weekdayLabel%d(==weekdayLabel0)]", index];
    }
    layoutString = [layoutString stringByAppendingString:@"|"];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:layoutString options:0 metrics:nil views:labelsDictionary]];

    // Construct vertical layout strings for each label
    for (NSUInteger index = 0; index < [self.weekdays count]; index++) {
        layoutString = [NSString stringWithFormat:@"V:|[weekdayLabel%d]|", index];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:layoutString options:0 metrics:nil views:labelsDictionary]];
    }
}




#pragma mark - Weekday set

-(void)setWeekdays:(NSArray *)weekdays {
    _weekdays = [weekdays copy];
    [self fillWeekdays];
}


#pragma mark - Colors

- (UIColor *)textColor
{
    if(_textColor == nil) {
        _textColor = [[[self class] appearance] textColor];
    }

    if(_textColor != nil) {
        return _textColor;
    }

    return [UIColor grayColor];
}

- (UIColor *)separatorColor
{
    if(_separatorColor == nil) {
        _separatorColor = [[[self class] appearance] separatorColor];
    }

    if(_separatorColor != nil) {
        return _separatorColor;
    }

    return [UIColor lightGrayColor];
}

- (UIColor *)backgroundColor
{
    if(_backgroundColor == nil) {
        _backgroundColor = [[[self class] appearance] backgroundColor];
    }

    if(_backgroundColor != nil) {
        return _backgroundColor;
    }

    return [UIColor whiteColor];
}


@end
