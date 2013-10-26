//
//  DemoInterface.m
//  iOS-Contributors
//
//  Created by Bryce Pauken on 10/25/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "DemoInterface.h"

@implementation DemoInterface

+ (BOOL)IS_IOS7 {
    return ([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch] != NSOrderedAscending);
}

- (id)init {
    self = [super init];
    if (self) {
        [self setBackgroundColor:[UIColor colorWithWhite:0.980 alpha:1]];
        
        self.header = [[UIView alloc] init];
        self.headerBorder = [CALayer layer];
        [self.headerBorder setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
        [self.header.layer addSublayer:self.headerBorder];
        self.headerGradient = [CAGradientLayer layer];
        self.headerGradient.frame = self.header.bounds;
        self.headerGradient.colors = [NSArray arrayWithObjects:(id)[[UIColor colorWithWhite:0.980 alpha:1] CGColor], (id)[[UIColor colorWithWhite:0.945 alpha:1] CGColor], nil];
        [self.header.layer insertSublayer:self.headerGradient atIndex:0];
        [self addSubview:self.header];
        
        self.headerLabel = [[UILabel alloc] init];
        [self.headerLabel setBackgroundColor:[UIColor clearColor]];
        [self.headerLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [self.headerLabel setShadowColor:[UIColor whiteColor]];
        [self.headerLabel setShadowOffset:CGSizeMake(0,1)];
        [self.headerLabel setText:@"iOS Contributors"];
        [self.headerLabel setTextAlignment:NSTextAlignmentCenter];
        [self.headerLabel setTextColor:[UIColor colorWithRed:0.255 green:0.514 blue:0.769 alpha:1]];
        [self addSubview:self.headerLabel];
        
        self.textField = [[DemoTextField alloc] init];
        [self.textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
        [self.textField setAutocorrectionType:UITextAutocorrectionTypeNo];
        [self.textField setBackgroundColor:[UIColor whiteColor]];
        [self.textField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [self.textField setDelegate:self];
        [self.textField setFont:[UIFont fontWithName:@"Helvetica" size:14]];
        [self.textField setReturnKeyType:UIReturnKeyGo];
        [self.textField setText:@"KingfishDevelopment / iOS-Contributors"];
        self.textFieldBorder = [CALayer layer];
        [self.textFieldBorder setBackgroundColor:[UIColor colorWithWhite:0.8f alpha:1.0f].CGColor];
        [self.textField.layer addSublayer:self.textFieldBorder];
        [self addSubview:self.textField];
        
        self.contributorsView = [[UIContributorsView alloc] init];
        [self addSubview:self.contributorsView];
        
        [self.contributorsView showContributorsForRepo:self.textField.text];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self.header setFrame:CGRectMake(0, ([DemoInterface IS_IOS7]?20:0), self.frame.size.width, 44)];
    [self.headerBorder setFrame:CGRectMake(0, self.header.frame.size.height-1, self.header.frame.size.width, 1)];
    [self.headerGradient setFrame:self.header.bounds];
    [self.headerLabel setFrame:CGRectMake(0, ([DemoInterface IS_IOS7]?20:0), self.frame.size.width, self.header.frame.size.height)];
    [self.textField setFrame:CGRectMake(0, self.header.frame.origin.y+self.header.frame.size.height, self.frame.size.width, self.header.frame.size.height)];
    [self.textFieldBorder setFrame:CGRectMake(0, self.textField.frame.size.height-1, self.frame.size.width, 1)];
    [self.contributorsView setFrame:CGRectMake(0, self.header.frame.origin.y+self.header.frame.size.height+self.textField.frame.size.height, self.frame.size.width, self.frame.size.height-self.header.frame.size.height-self.textField.frame.size.height-self.header.frame.origin.y)];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [self.contributorsView showContributorsForRepo:textField.text];
    return YES;
}

@end
