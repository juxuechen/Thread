//
//  TestOperation.h
//  Multithreading
//
//  Created by Chen Yang on 12-3-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestOperationDelegate 

@required
- (void)addView:(UIView *)view num:(int)num;

@end

@interface TestOperation : NSInvocationOperation{
    id<TestOperationDelegate>  delegate;
    int i;
}

- (id)initWithDelegate:(id)d num:(int)num;

@end
