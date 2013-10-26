//
//  UIContributorsCell.m
//  iOS-Contributors
//
//  Created by Bryce Pauken on 10/25/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "UIContributorsCell.h"

@implementation UIContributorsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        self.padding = 8;
        
        self.avatarView = [[UIImageView alloc] init];
        [self addSubview:self.avatarView];
        
        self.usernameLabel = [[UILabel alloc] init];
        [self.usernameLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:16]];
        [self.usernameLabel setTextColor:[UIColor colorWithWhite:0.267 alpha:1]];
        [self addSubview:self.usernameLabel];
        
        self.divider = [[UIView alloc] init];
        [self.divider setBackgroundColor:[UIColor colorWithWhite:0.8 alpha:1]];
        [self addSubview:self.divider];
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self.avatarView setFrame:CGRectMake(self.padding, self.padding, self.frame.size.height-self.padding*2, self.frame.size.height-self.padding*2)];
    [self.usernameLabel setFrame:CGRectMake(self.avatarView.frame.size.width+self.padding*2, self.padding, self.frame.size.width-self.avatarView.frame.size.width-self.padding*3, self.frame.size.height-self.padding*2)];
    [self.divider setFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
}

- (void)setUsernameText:(NSString *)usernameText withImage:(UIImage *)image withDivider:(BOOL)divider {
    [self.usernameLabel setText:usernameText];
    [self.avatarView setImage:image];
    [self.divider setHidden:!divider];
    [self setFrame:self.frame];
}

@end
