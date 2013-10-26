//
//  ContributorsView.h
//  iOS-Contributors
//
//  Created by Bryce Pauken on 10/25/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SBJsonParser.h"
#import "UIContributorsCell.h"

@interface RemainingCount : NSObject

@property (nonatomic) int remaining;

@end

@interface UIContributorsView : UIView <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, retain) NSMutableDictionary *connectionResponses;
@property (nonatomic, retain) id contributors;
@property (nonatomic, retain) NSMutableDictionary *images;
@property (nonatomic, retain) UILabel *loadingLabel;
@property (nonatomic, retain) UIActivityIndicatorView *loadingSpinner;
@property (nonatomic, retain) UILabel *messageLabel;
@property (nonatomic, retain) NSMutableDictionary *names;
@property (nonatomic, retain) SBJsonParser *parser;
@property (nonatomic, retain) UITableView *tableView;
@property (nonatomic, retain) NSString *authToken;

- (void)showContributorsForRepo:(NSString *)repo;

@end
