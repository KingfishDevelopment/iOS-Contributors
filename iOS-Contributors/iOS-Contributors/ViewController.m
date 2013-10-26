//
//  ViewController.m
//  iOS-Contributors
//
//  Created by Bryce Pauken on 10/25/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (id)init {
    self = [super init];
    if (self) {
        self.demoInterface = [[DemoInterface alloc] init];
        [self.view addSubview:self.demoInterface];
        self.demoInterface .autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)viewDidLoad {
    [self.demoInterface setFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
}

@end
