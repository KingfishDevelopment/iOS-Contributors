//
//  DemoInterface.h
//  iOS-Contributors
//
//  Created by Bryce Pauken on 10/25/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoTextField.h"
#import "UIContributorsView.h"

@interface DemoInterface : UIView <UITextFieldDelegate>

@property (nonatomic, retain) UIContributorsView *contributorsView;
@property (nonatomic, retain) UIView *header;
@property (nonatomic, retain) CALayer *headerBorder;
@property (nonatomic, retain) CAGradientLayer *headerGradient;
@property (nonatomic, retain) UILabel *headerLabel;
@property (nonatomic, retain) UITextField *textField;
@property (nonatomic, retain) CALayer *textFieldBorder;

@end
