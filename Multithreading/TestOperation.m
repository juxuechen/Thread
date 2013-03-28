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


- (BOOL)isConcurrent {//异步方式
    return YES;
}

- (void)start {
    if (![self isCancelled]) {
        //很多任务同时执行。
        NSLog(@"start 第%d个任务",self.i);
        
        
        for(int bb = 0; bb < 10000; bb++)
            for(int aa = 0; aa < 10000; aa++);
        
         NSLog(@"start 第%d个任务  --- 运算完毕",self.i);
    }
    
    [super start];
}




@end
