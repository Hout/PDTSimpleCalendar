//
//  PDTSimpleCalendarViewHeader.h
//  PDTSimpleCalendar
//
//  Created by Jerome Miglino on 10/8/13.
//  Copyright (c) 2013 Producteev. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  The `PDTSimpleCalendarViewHeader` class displays the month name and year.
 */
@interface PDTSimpleCalendarViewHeader : UICollectionReusableView

/**
 *  Label that displays the month and year
 */
@property (nonatomic, strong) UILabel *titleLabel;

/**
 *  Array of strings that contain the weekday acronyms
 */
@property (nonatomic, strong) NSArray *weekdays;

/** @name Customizing Appearance */

/**
 *  Customize the Month text color display.
 */
@property (nonatomic, strong) UIColor *textColor UI_APPEARANCE_SELECTOR;

/**
 *  Customize the separator color between the month name and the dates.
 */
@property (nonatomic, strong) UIColor *separatorColor UI_APPEARANCE_SELECTOR;

/**
 *  Customize the background color.
 */
@property (nonatomic, strong) UIColor *backgroundColor UI_APPEARANCE_SELECTOR;

@end
