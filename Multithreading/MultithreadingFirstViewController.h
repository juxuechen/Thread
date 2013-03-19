//
//  MultithreadingFirstViewController.h
//  Multithreading
//
//  Created by Chen Yang on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MultithreadingFirstViewController : UIViewController {
    int i;
    NSCondition *codition;
    
    __block dispatch_semaphore_t sem;
    dispatch_queue_t queue;
}

@property (nonatomic,strong) IBOutlet UIView *waitingView;
@property (nonatomic,strong) IBOutlet UIActivityIndicatorView *activityView;

- (IBAction)selectA:(id)sender;
- (IBAction)selectB:(id)sender;

@end
