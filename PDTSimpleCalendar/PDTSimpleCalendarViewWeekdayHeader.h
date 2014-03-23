//
//  PDTSimpleCalendarViewWeekdayHeader.h
//  PDTSimpleCalendarDemo
//
//  Created by Jeroen Houtzager on 23-03-14.
//  Copyright (c) 2014 Producteev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PDTSimpleCalendarViewWeekdayHeader : UIView

// Array of strings with weekday abbreviations
@property (nonatomic, copy) NSArray *weekdays;

@property (nonatomic, copy) UIColor *weekdayHeaderTextColor UI_APPEARANCE_SELECTOR;;
@property (nonatomic, copy) UIColor *weekdayHeaderBackgroundColor UI_APPEARANCE_SELECTOR;;
@property (nonatomic, copy) UIColor *weekdayHeaderSeparatorColor UI_APPEARANCE_SELECTOR;;

@end
