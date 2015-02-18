//
//  LabelView.m
//  SoberTool
//
//  Created by Matthew Faluotico on 1/18/15.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import "LabelView.h"
#import <POP/POP.h>

@implementation LabelView

- (id) initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    [self addLabels];
    return self;
}

- (void) addLabels {
    CGRect screen = [[UIScreen mainScreen] bounds];
    
    self.aboutLabel = [[UILabel alloc] initWithFrame:screen];
    self.rewardsLabel = [[UILabel alloc] init];
    self.communityLabel = [[UILabel alloc] init];
    self.settingsLabel = [[UILabel alloc] init];
    self.shareLabel = [[UILabel alloc] init];
    
    self.aboutLabel.text = @"About";
    self.rewardsLabel.text = @"Rewards";
    self.shareLabel.text = @"Share";
    self.settingsLabel.text = @"Settings";
    self.communityLabel.text = @"Community";
    
    NSArray *labels = @[self.aboutLabel, self.rewardsLabel, self.communityLabel, self.settingsLabel, self.shareLabel];
    
    CGFloat y = screen.size.height - 70;
    CGFloat x = 20;
    
    for (UILabel *label in labels) {
        label.textAlignment = NSTextAlignmentRight;
        CGFloat width = screen.size.width - 40;
        CGFloat height = 50;
        label.frame = CGRectMake(x, y, width, height);
        y = y - 55;
        
        label.textColor = [UIColor whiteColor];
		label.font = [UIFont systemFontOfSize:28];
		
        [self addSubview:label];
    }
    
    
}

-(id)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    
    if (hitView == self)
        return nil;
    else
        return hitView;
}

@end
