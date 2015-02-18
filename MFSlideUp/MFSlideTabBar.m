//
//  STTabBarController.m
//  SoberTool
//
//  Created by Matthew Faluotico on 1/17/15.
//  Copyright (c) 2015 mf. All rights reserved.
//

#import "MFSlideTabBar.h"
#import "AppDelegate.h"
#import "LabelView.h"

NSInteger moreIndex = 2;
CGFloat animationTime = 0.2;
NSInteger last = 0;

@interface MFSlideTabBar ()

@property LabelView *labels;

@end


@implementation MFSlideTabBar

#pragma mark - View loading

- (void) viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.tabBarController.delegate = self;
    self.tabBar.backgroundColor = [UIColor whiteColor];
    
    self.view.backgroundColor = [UIColor redColor];
    self.tabBar.tintColor = [UIColor redColor];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16], NSFontAttributeName, nil] forState:UIControlStateNormal];

    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    self.labels = [[LabelView alloc] initWithFrame:screenRect];
    [self.view addSubview:self.labels];
    [self addGesturesToLabels];
    [self.labels setUserInteractionEnabled:NO];
    self.labels.alpha = 0;
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addGesturesToLabels {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(presentAboutController:)];
    [self.labels.aboutLabel addGestureRecognizer:tap];
    [self.labels.aboutLabel setUserInteractionEnabled:YES];
}

# pragma mark - Menu animation

- (BOOL) slideOutTabBar {
    
    POPSpringAnimation *tabSlideOut = [POPSpringAnimation new];
    tabSlideOut.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    CGFloat current_y = self.tabBar.layer.position.y;
    CGFloat new_y = current_y + 50;
    tabSlideOut.springSpeed = 30;
    tabSlideOut.springBounciness = 75;
    tabSlideOut.toValue = @(new_y);
    
    [self.tabBar.layer pop_addAnimation:tabSlideOut forKey:@"tab_slideout"];
    
    
    return YES;
}

- (BOOL) slideInTabBar {
    POPBasicAnimation *tabSlideIn = [POPBasicAnimation new];
    tabSlideIn.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    tabSlideIn.timingFunction= [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    CGFloat current_y = self.tabBar.layer.position.y;
    tabSlideIn.duration = animationTime;
    CGFloat new_y = current_y - 50;
    tabSlideIn.toValue = @(new_y);
    [self.tabBar.layer pop_addAnimation:tabSlideIn forKey:@"tab_slidein"];
    return YES;
}

- (void) slideOutView: (UIView *) view {
    
    
    POPSpringAnimation *viewSlideOut = [POPSpringAnimation new];
    viewSlideOut.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    CGRect newFrame = view.frame;
    newFrame.origin.y = newFrame.origin.y - 320;
    viewSlideOut.toValue = [NSValue valueWithCGRect:newFrame];
    viewSlideOut.springSpeed = 30;
    viewSlideOut.springBounciness = 75;
    
    [viewSlideOut setCompletionBlock:^(POPAnimation *a, BOOL n) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backDown:)];
        [view addGestureRecognizer:tap];
    }];
    

    [view pop_addAnimation:viewSlideOut forKey:@"view_slideout"];
}

- (void) slideInView: (UIView *) view hasNewView: (BOOL) newMoreView {
    
    POPBasicAnimation *viewSlideIn = [POPBasicAnimation new];
    viewSlideIn.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    CGRect newFrame = view.frame;
    newFrame.origin.y = 0;
    newFrame.origin.x = 0;
    viewSlideIn.toValue = [NSValue valueWithCGRect:newFrame];
    viewSlideIn.duration = animationTime;
    viewSlideIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    
    if (newMoreView) {
        [viewSlideIn setCompletionBlock:^(POPAnimation *a, BOOL n) {
            [self setSelectedIndex:moreIndex];
        }];
    }
    
    [view pop_addAnimation:viewSlideIn forKey:@"view_slidein"];
}

- (void) slideInLabel {
    
    POPBasicAnimation *labelsSlideIn = [POPBasicAnimation new];
    labelsSlideIn.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    labelsSlideIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    labelsSlideIn.duration = animationTime;
    CGRect finalFrame = self.labels.frame;
    CGRect initFrame = finalFrame;
    initFrame.origin.y = initFrame.origin.y + 25;
    labelsSlideIn.fromValue = [NSValue valueWithCGRect:initFrame];
    labelsSlideIn.toValue = [NSValue valueWithCGRect:finalFrame];
    
    POPBasicAnimation *labelsFadeIn = [POPBasicAnimation new];
    labelsFadeIn.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    labelsFadeIn.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    labelsFadeIn.fromValue = @(0);
    labelsFadeIn.toValue = @(1);
    labelsFadeIn.duration = animationTime * 1.5;
    
    [self.labels pop_addAnimation:labelsFadeIn forKey:@"labelsfade"];
    [self.labels pop_addAnimation:labelsSlideIn forKey:@"labels"];
}

- (void) slideOutLabel {
    POPBasicAnimation *labelsSlideOut = [POPBasicAnimation new];
    labelsSlideOut.property = [POPAnimatableProperty propertyWithName:kPOPViewFrame];
    labelsSlideOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    labelsSlideOut.duration = animationTime * 0.5;
    CGRect initFrame = self.labels.frame;
    CGRect finalFrame = initFrame;
    finalFrame.origin.y = finalFrame.origin.y + 25;
    labelsSlideOut.fromValue = [NSValue valueWithCGRect:initFrame];
    labelsSlideOut.toValue = [NSValue valueWithCGRect:finalFrame];
    
    POPBasicAnimation *labelsFadeOut = [POPBasicAnimation new];
    labelsFadeOut.property = [POPAnimatableProperty propertyWithName:kPOPViewAlpha];
    labelsFadeOut.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    labelsFadeOut.fromValue = @(1);
    labelsFadeOut.toValue = @(0);
    labelsFadeOut.duration = animationTime * 0.5;
    
    [labelsSlideOut setCompletionBlock:^(POPAnimation * a, BOOL n) {
        //   resets the frame of the label.
        self.labels.frame = [[UIScreen mainScreen] bounds];
    }];

    [self.labels pop_addAnimation:labelsFadeOut forKey:@"labelsfade"];
    [self.labels pop_addAnimation:labelsSlideOut forKey:@"labels"];
}

#pragma mark - Tab Delegate

- (void) tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    last = [self selectedIndex];
}

- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
    UIViewController *moreViewController = [self.viewControllers objectAtIndex:moreIndex];
    
    if (viewController == moreViewController) {
        [self setSelectedIndex:last];
        [self slideOutTabBar];
        [self slideInLabel];
        [self slideOutView: [self selectedViewController].view];
        [self.labels setUserInteractionEnabled:YES];
//        [self.tabBar setUserInteractionEnabled:NO];
    }
}

# pragma mark - Tap Calls

- (void) backDown: (UITapGestureRecognizer *)gestureRecognizer {
    UIView *view = gestureRecognizer.view;
    [view removeGestureRecognizer:gestureRecognizer];
    NSLog(@"removed");
    [self slideInView:view hasNewView:NO];
    [self slideInTabBar];
    [self slideOutLabel];
    [self.labels setUserInteractionEnabled:NO];
    
}

- (void) backDownView: (UIView *) view {
    
    for (UIGestureRecognizer *g in view.gestureRecognizers) {
        [view removeGestureRecognizer:g];
    }
    
    [self slideInView:view hasNewView:YES];
    [self slideInTabBar];
    [self slideOutLabel];
    [self.labels setUserInteractionEnabled:NO];
    
}

# pragma mark - Presenting View Controlers

- (void) presentAboutController: (UITapGestureRecognizer *) gesture {
    NSLog(@"about");
    UIViewController *moreViewController = self.selectedViewController;
    
    [self backDownView:moreViewController.view];
    
}

- (void) presentRewardsController {}

- (void) presentShareController {}

- (void) presentSettingsController {}

- (void) presentCommunityController {}


@end

