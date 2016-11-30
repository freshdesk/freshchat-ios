//
//  FDCSATView.h
//  HotlineSDK
//
//  Created by user on 17/10/16.
//  Copyright © 2016 Freshdesk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FDCsat.h"

@protocol FDCSATViewDelegate <NSObject>

-(void)submittedCSAT:(FDCsatHolder *)csatHolder;
-(void)recordCSATYesState;

@end

@interface FDCSATView : UIView

@property (nonatomic,weak) id<FDCSATViewDelegate> delegate;
@property (nonatomic, strong) UILabel *surveyTitle;
@property (nonatomic, assign) BOOL isShowing;
@property (nonatomic, strong) NSLayoutConstraint *CSATPromptCenterYConstraint;

- (instancetype)initWithController:(UIViewController *)controller hideFeedbackView:(BOOL)hideFeedbackView isResolved:(BOOL)isResolved;
- (void)show;
- (void)dismiss;

@end
