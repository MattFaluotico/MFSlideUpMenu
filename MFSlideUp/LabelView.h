//
//  LabelView.h
//  SoberTool
//
//  Created by Matthew Faluotico on 1/18/15.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelView : UIView

@property UILabel *communityLabel;
@property UILabel *rewardsLabel;
@property UILabel *aboutLabel;
@property UILabel *settingsLabel;
@property UILabel *shareLabel;

- (void) addLabels;

@end
