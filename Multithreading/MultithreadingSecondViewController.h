//
//  MultithreadingSecondViewController.h
//  Multithreading
//
//  Created by Chen Yang on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TestOperation.h"

@interface MultithreadingSecondViewController : UIViewController <TestOperationDelegate>{
    NSOperationQueue* _queue;
}

@end
