//
//  UIContributorsCell.h
//  iOS-Contributors
//
//  Created by Bryce Pauken on 10/25/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIContributorsCell : UITableViewCell

@property (nonatomic, retain) UIImageView *avatarView;
@property (nonatomic, retain) UIView *divider;
@property (nonatomic) int padding;
@property (nonatomic, retain) UILabel *usernameLabel;

- (void)setUsernameText:(NSString *)usernameText withImage:(UIImage *)image withDivider:(BOOL)divider;

@end
