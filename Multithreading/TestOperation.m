//
//  TestOperation.m
//  Multithreading
//
//  Created by Chen Yang on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "TestOperation.h"
#import <QuartzCore/QuartzCore.h>

@implementation TestOperation

- (id)initWithDelegate:(id)d num:(int)num {
    if (self) {
        delegate = d;
        i = num;
    }
    return self;
}


- (BOOL)isConcurrent {//异步方式
    return YES;
}

- (void)start {
    if (![self isCancelled]) {
        NSLog(@"start %d",i);
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(60, 10 + 20 * (i++), 200, 10)];
        view.backgroundColor = [UIColor greenColor];
        view.layer.shadowColor= [UIColor blackColor].CGColor;
        view.layer.shadowOffset=CGSizeMake(0,0);
        view.layer.shadowOpacity=0.5; 
        view.layer.shadowRadius=10.0;
        [delegate addView:view num:i];
        
    }
}




@end
