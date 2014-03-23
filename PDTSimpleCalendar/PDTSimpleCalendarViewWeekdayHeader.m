//
//  PDTSimpleCalendarViewWeekdayHeader.m
//  PDTSimpleCalendarDemo
//
//  Created by Jeroen Houtzager on 23-03-14.
//  Copyright (c) 2014 Producteev. All rights reserved.
//

#import "PDTSimpleCalendarViewWeekdayHeader.h"

@interface PDTSimpleCalendarViewWeekdayHeader ()

// Array of strings with weekday abbreviations
@property (nonatomic, copy) NSArray *weekdayLabels;

@end


@implementation PDTSimpleCalendarViewWeekdayHeader

@synthesize weekdayHeaderBackgroundColor = _weekdayHeaderBackgroundColor;
@synthesize weekdayHeaderTextColor = _weekdayHeaderTextColor;
@synthesize weekdayHeaderSeparatorColor = _weekdayHeaderSeparatorColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = self.weekdayHeaderBackgroundColor;
    }

    return self;
}

#pragma mark - Fill weekdays

-(void)fillWeekdays {
    if (![self.weekdays count]) {
        return;
    }

    // Create constraint dictionary
    CGFloat onePixel = 1.0f / [UIScreen mainScreen].scale;
    NSMutableDictionary *viewsDictionary = [[NSMutableDictionary alloc] initWithCapacity:[self.weekdays count] + 1];
    NSDictionary *metricsDictionary = @{@"onePixel" : [NSNumber numberWithFloat:onePixel]};

    // Add separator view
    UIView *separatorView = [[UIView alloc] init];
    [separatorView setBackgroundColor:self.weekdayHeaderSeparatorColor];
    [self addSubview:separatorView];
    [separatorView setTranslatesAutoresizingMaskIntoConstraints:NO];

    [viewsDictionary setObject:separatorView forKey:@"separatorView"];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|[separatorView]|" options:0 metrics:nil views:viewsDictionary]];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[separatorView(==onePixel)]|" options:0 metrics:metricsDictionary views:viewsDictionary]];
    
    // Fill weekdayView with labels
    for (NSUInteger index = 0; index < [self.weekdays count]; index++) {
        UILabel *weekdayLabel = [[UILabel alloc] init];
        weekdayLabel.font = [UIFont systemFontOfSize:12.0];
        weekdayLabel.text = self.weekdays[index];
        weekdayLabel.textColor = self.weekdayHeaderTextColor;
        weekdayLabel.textAlignment = NSTextAlignmentCenter;
        weekdayLabel.backgroundColor = self.weekdayHeaderBackgroundColor;
        [self addSubview:weekdayLabel];
        weekdayLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [viewsDictionary setObject:weekdayLabel forKey:[NSString stringWithFormat:@"weekdayLabel%lu", (unsigned long)index]];
    }

    // Construct horizontal layout string to "|[weekdayLabel0] ... [weekdayLabelN]|"
    NSString *layoutString = @"|[weekdayLabel0]";
    for (NSUInteger index = 1; index < [self.weekdays count]; index++) {
        layoutString = [layoutString stringByAppendingFormat:@"[weekdayLabel%lu(==weekdayLabel0)]", (unsigned long)index];
    }
    layoutString = [layoutString stringByAppendingString:@"|"];
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:layoutString options:0 metrics:nil views:viewsDictionary]];

    // Construct vertical layout strings for each label
    for (NSUInteger index = 0; index < [self.weekdays count]; index++) {
        layoutString = [NSString stringWithFormat:@"V:|[weekdayLabel%lu][separatorView]|", (unsigned long)index];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:layoutString options:0 metrics:nil views:viewsDictionary]];
    }
}


#pragma mark - Accessors

-(void)setWeekdays:(NSArray *)weekdays {
    _weekdays = [weekdays copy];
    [self fillWeekdays];
}


-(void)setWeekdayHeaderBackgroundColor:(UIColor *)weekdayHeaderBackgroundColor {
    _weekdayHeaderBackgroundColor = weekdayHeaderBackgroundColor;

    // set own background color and that of the labels
    [super setBackgroundColor:weekdayHeaderBackgroundColor];
    for (UILabel *label in self.weekdayLabels) {
        label.backgroundColor = weekdayHeaderBackgroundColor;
    }
}


-(void)setWeekdayHeaderTextColor:(UIColor *)weekdayHeaderTextColor {
    for (UILabel *label in self.weekdayLabels) {
        label.textColor = weekdayHeaderTextColor;
    }
}


- (UIColor *)weekdayHeaderTextColor
{
    if (!_weekdayHeaderTextColor) {
        _weekdayHeaderTextColor = [[[self class] appearance] weekdayHeaderTextColor];
    }

    if (_weekdayHeaderTextColor) {
        return _weekdayHeaderTextColor;
    }

    return [UIColor grayColor];
}

- (UIColor *)weekdayHeaderSeparatorColor
{
    if (!_weekdayHeaderSeparatorColor) {
        _weekdayHeaderSeparatorColor = [[[self class] appearance] weekdayHeaderSeparatorColor];
    }

    if (_weekdayHeaderSeparatorColor) {
        return _weekdayHeaderSeparatorColor;
    }

    return [UIColor lightGrayColor];
}

- (UIColor *)weekdayHeaderBackgroundColor
{
    if (!_weekdayHeaderBackgroundColor) {
        _weekdayHeaderBackgroundColor = [[[self class] appearance] weekdayHeaderBackgroundColor];
    }

    if (_weekdayHeaderBackgroundColor) {
        return _weekdayHeaderBackgroundColor;
    }

    return [UIColor colorWithWhite:0.97 alpha:1.0];
}



@end
