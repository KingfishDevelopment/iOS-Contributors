//
//  ContributorsView.m
//  iOS-Contributors
//
//  Created by Bryce Pauken on 10/25/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "UIContributorsView.h"

@implementation RemainingCount

@end

@implementation UIContributorsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.authToken = @"";
        
        self.connectionResponses = [[NSMutableDictionary alloc] init];
        self.parser = [[SBJsonParser alloc] init];
        
        self.loadingLabel = [[UILabel alloc] init];
        [self.loadingLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [self.loadingLabel setHidden:YES];
        [self.loadingLabel setText:@"Loading..."];
        [self.loadingLabel setTextAlignment:NSTextAlignmentCenter];
        [self.loadingLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.loadingLabel];
        
        self.loadingSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [self.loadingSpinner setHidesWhenStopped:YES];
        [self addSubview:self.loadingSpinner];
        
        self.messageLabel = [[UILabel alloc] init];
        [self.messageLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:14]];
        [self.messageLabel setHidden:YES];
        [self.messageLabel setTextAlignment:NSTextAlignmentCenter];
        [self.messageLabel setTextColor:[UIColor lightGrayColor]];
        [self addSubview:self.messageLabel];
        
        self.tableView = [[UITableView alloc] init];
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [self.tableView setDataSource:self];
        [self.tableView setDelegate:self];
        [self addSubview:self.tableView];
        
        [self setBackgroundColor:[UIColor whiteColor]];
    }
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [[[self.connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]] objectForKey:@"data"] appendData:data];
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    [self failedWithError:nil];
    [self.connectionResponses removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSMutableDictionary *connectionResponse = [self.connectionResponses objectForKey:[NSValue valueWithNonretainedObject:connection]];
    RemainingCount *count;
    if([[connectionResponse objectForKey:@"type"] isEqualToString:@"name"]) {
        [self parseResponse:[[NSString alloc] initWithData:[connectionResponse objectForKey:@"data"] encoding:NSUTF8StringEncoding] ofType:@"name"];
        [self.connectionResponses removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
        count = [connectionResponse objectForKey:@"remaining"];
        count.remaining--;
    }
    else if([[connectionResponse objectForKey:@"type"] isEqualToString:@"image"]) {
        [self.images setObject:[UIImage imageWithData:[connectionResponse objectForKey:@"data"]] forKey:[connectionResponse objectForKey:@"url"]];
        [self.connectionResponses removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
        count = [connectionResponse objectForKey:@"remaining"];
        count.remaining--;
    }
    else {
        [self parseResponse:[[NSString alloc] initWithData:[connectionResponse objectForKey:@"data"] encoding:NSUTF8StringEncoding] ofType:@"contributors"];
        [self.connectionResponses removeObjectForKey:[NSValue valueWithNonretainedObject:connection]];
    }
    if(count&&count.remaining==0) {
        [self.tableView setHidden:NO];
        [self.loadingLabel setHidden:YES];
        [self.loadingSpinner stopAnimating];
        [self.messageLabel setHidden:YES];
        [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    }
}

- (void)failedWithError:(NSString *)error {
    [self.tableView setHidden:YES];
    [self.loadingSpinner stopAnimating];
    [self.loadingLabel setHidden:YES];
    [self.messageLabel setHidden:NO];
    if(!error||[error isEqualToString:@""])
        error = @"An Unknown Error Occurred";
    [self.messageLabel setText:error];
    [self setFrame:self.frame];
}

- (void)parseResponse:(NSString *)responseString ofType:(NSString *)type {
    if([type isEqualToString:@"name"]) {
        NSDictionary *response = [self.parser objectWithString:responseString];
        if([response objectForKey:@"name"])
            [self.names setObject:[response objectForKey:@"name"] forKey:[response objectForKey:@"login"]];
    }
    else {
        self.contributors = [self.parser objectWithString:responseString];
        self.images = [[NSMutableDictionary alloc] init];
        self.names = [[NSMutableDictionary alloc] init];
        if(self.contributors==nil) {
            [self failedWithError:nil];
        }
        else if([self.contributors respondsToSelector:@selector(objectForKey:)]&&[self.contributors objectForKey:@"message"]) {
            if([[self.contributors objectForKey:@"message"] isEqualToString:@"Not Found"])
                [self failedWithError:@"Repo Not Found"];
            else if([[self.contributors objectForKey:@"message"] length]>=23&&[[[self.contributors objectForKey:@"message"] substringToIndex:23] isEqualToString:@"API rate limit exceeded"])
                [self failedWithError:@"API Limit Exceeded"];
            self.contributors = nil;
        }
        else {
            RemainingCount *count = [[RemainingCount alloc] init];
            for(id contributor in self.contributors) {
                if([contributor respondsToSelector:@selector(objectForKey:)]&&[contributor objectForKey:@"avatar_url"]) {
                    count.remaining++;
                    NSString *requestURL = [contributor objectForKey:@"avatar_url"];
                    if(self.authToken&&![self.authToken isEqualToString:@""])
                        requestURL = [requestURL stringByAppendingString:[@"?access_token=" stringByAppendingString:self.authToken]];
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
                    [request addValue:@"iOS-Contributors" forHTTPHeaderField:@"User-Agent"];
                    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                    [self.connectionResponses setObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSMutableData data],@"image",[contributor objectForKey:@"avatar_url"],count,nil] forKeys:[NSArray arrayWithObjects:@"data",@"type",@"url",@"remaining",nil]] forKey:[NSValue valueWithNonretainedObject:connection]];
                    [connection start];
                }
                if([contributor respondsToSelector:@selector(objectForKey:)]&&[contributor objectForKey:@"url"]) {
                    count.remaining++;
                    NSString *requestURL = [contributor objectForKey:@"url"];
                    if(self.authToken&&![self.authToken isEqualToString:@""])
                        requestURL = [requestURL stringByAppendingString:[@"?access_token=" stringByAppendingString:self.authToken]];
                    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
                    [request addValue:@"iOS-Contributors" forHTTPHeaderField:@"User-Agent"];
                    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
                    [self.connectionResponses setObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSMutableData data],@"name",[contributor objectForKey:@"login"],count,nil] forKeys:[NSArray arrayWithObjects:@"data",@"type",@"username",@"remaining",nil]] forKey:[NSValue valueWithNonretainedObject:connection]];
                    [connection start];
                }
            }
        }
    }
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    
    [self.loadingLabel setBackgroundColor:backgroundColor];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    CGSize loadingLabelSize = [self.loadingLabel.text sizeWithFont:self.loadingLabel.font];
    [self.loadingSpinner setFrame:CGRectMake((self.frame.size.width-self.loadingSpinner.frame.size.width-loadingLabelSize.width)/2-5, (self.frame.size.height-self.loadingSpinner.frame.size.height)/2, self.loadingSpinner.frame.size.width, self.loadingSpinner.frame.size.height)];
    [self.loadingLabel setFrame:CGRectMake(self.loadingSpinner.frame.origin.x+self.loadingSpinner.frame.size.width+10, (self.frame.size.height-loadingLabelSize.height)/2, loadingLabelSize.width, loadingLabelSize.height)];
    
    CGSize messageLabelSize = [self.messageLabel.text sizeWithFont:self.messageLabel.font];
    [self.messageLabel setFrame:CGRectMake((self.frame.size.width-messageLabelSize.width)/2, (self.frame.size.height-messageLabelSize.height)/2, messageLabelSize.width, messageLabelSize.height)];

    [self.tableView setFrame:self.bounds];
}

- (void)showContributorsForRepo:(NSString *)repo {
    [self.tableView setHidden:YES];
    [self.loadingLabel setHidden:NO];
    [self.loadingSpinner startAnimating];
    [self.messageLabel setHidden:YES];
    
    repo = [repo stringByReplacingOccurrencesOfString:@" " withString:@""];
    if([repo isEqualToString:@""])
        [self failedWithError:@"Please Enter a Repo Name"];
    else {
        NSString *requestURL = [@"https://api.github.com/repos/" stringByAppendingString:[repo stringByAppendingString:@"/contributors"]];
        if(self.authToken&&![self.authToken isEqualToString:@""])
            requestURL = [requestURL stringByAppendingString:[@"?access_token=" stringByAppendingString:self.authToken]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:requestURL]];
        [request addValue:@"iOS-Contributors" forHTTPHeaderField:@"User-Agent"];
        NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [self.connectionResponses setObject:[NSMutableDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSMutableData data],@"contributors",nil] forKeys:[NSArray arrayWithObjects:@"data",@"type",nil]] forKey:[NSValue valueWithNonretainedObject:connection]];
        [connection start];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIContributorsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ContributorsCell"];
    if(cell==nil)
        cell = [[UIContributorsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ContributorsCell"];
    
    NSString *name = [[self.contributors objectAtIndex:indexPath.row] objectForKey:@"login"];
    if([self.names objectForKey:name]&&![[self.names objectForKey:name] isKindOfClass:[NSNull class]]&&![[self.names objectForKey:name] isEqualToString:@""])
        name = [NSString stringWithFormat:@"%@ (%@)",name,[self.names objectForKey:name]];
    [cell setUsernameText:name withImage:[self.images objectForKey:[[self.contributors objectAtIndex:indexPath.row] objectForKey:@"avatar_url"]] withDivider:indexPath.row>0];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([self.tableView isHidden]||!self.contributors)
        return 0;
    return [self.contributors count];
}

- (void)viewDidLoad {
    [self.tableView registerClass:[UIContributorsCell class] forCellReuseIdentifier:@"ContributorsCell"];
}

@end
