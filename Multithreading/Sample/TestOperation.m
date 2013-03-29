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

//是否允许并发 默认no
- (BOOL)isConcurrent {
    return YES;
}

//执行任务主函数，线程运行的入口函数
- (void)start {
    if (![self isCancelled]) {
        //很多任务同时执行。
        NSLog(@"start 第%d个任务",self.i);
        
        for(int b = 0; b < 5000; b++)
            for(int aa = 0; aa < 50000; aa++);
    }
    
    [super start];
}


@end
