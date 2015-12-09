//
//  HLContainerViewController.m
//  HotlineSDK
//
//  Created by AravinthChandran on 9/10/15.
//  Copyright (c) 2015 Freshdesk. All rights reserved.
//

#import "HLContainerController.h"

@interface HLContainerController ()

@property (nonatomic, strong) UIViewController *childController;

@end

@implementation HLContainerController

-(instancetype)initWithController:(UIViewController *)controller{
    self = [super init];
    if (self) {
        self.childController = controller;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setNavigationBarConfig];

    self.containerView = [UIView new];
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.containerView];
    
    UIView *footerView = [UIView new];
    footerView.translatesAutoresizingMaskIntoConstraints = NO;
    footerView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:footerView];
    
    //Footerview label
    UILabel *footerLabel = [UILabel new];
    footerLabel.text = @"Powered by Hotline";
    footerLabel.font = [UIFont systemFontOfSize:11];
    footerLabel.textColor = [UIColor whiteColor];
    footerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [footerView addSubview:footerLabel];
    [footerView addConstraint:[NSLayoutConstraint constraintWithItem:footerView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:footerLabel attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [footerView addConstraint:[NSLayoutConstraint constraintWithItem:footerView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:footerLabel attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0]];
    
    NSDictionary *views = @{ @"containerView" : self.containerView, @"footerView" : footerView, @"childControllerView" : self.childController.view};
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[containerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[footerView]|" options:0 metrics:nil views:views]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[containerView][footerView(20)]|" options:0 metrics:nil views:views]];
    
    self.childController.view.translatesAutoresizingMaskIntoConstraints = NO;
    [self.containerView addSubview:self.childController.view];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[childControllerView]|" options:0 metrics:nil views:views]];
    [self.containerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[childControllerView]|" options:0 metrics:nil views:views]];
    
    // This invokes the child controllers -willMoveToParentViewController:
    [self addChildViewController:self.childController];
}

-(void)setNavigationBarConfig{
    
    /*
     
     Made navigation bar to be opaque
     
     This will fix the view from being framed underneath the navigation bar and status bar.
     http://stackoverflow.com/questions/18798792
     
     All setting to the navigation bar has to refer parent view controller since we are using
     container controller
     
     */
    
    self.navigationController.navigationBar.translucent = NO;

}

@end