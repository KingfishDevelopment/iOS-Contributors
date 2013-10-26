//
//  DemoTextField.m
//  iOS-Contributors
//
//  Created by Bryce Pauken on 10/25/13.
//  Copyright (c) 2013 Kingfish. All rights reserved.
//

#import "DemoTextField.h"

@implementation DemoTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

@end
