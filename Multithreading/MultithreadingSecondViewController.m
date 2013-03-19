//
//  MultithreadingSecondViewController.m
//  Multithreading
//
//  Created by Chen Yang on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "MultithreadingSecondViewController.h"


@implementation MultithreadingSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"operation", @"operation");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _queue = [[NSOperationQueue alloc] init];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    for (int j = 0; j < 20; j++) {
//        TestOperation *op = [[TestOperation alloc] initWithDelegate:self num:j];
//        [_queue addOperation:op];
//    }
    
    
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSURL * url = [NSURL URLWithString:@"http://avatar.csdn.net/2/C/D/1_totogo2010.jpg"];
//        NSData * data = [[NSData alloc]initWithContentsOfURL:url];
//        UIImage *image = [[UIImage alloc]initWithData:data];
//        if (data != nil) {
//            dispatch_async(dispatch_get_main_queue(), ^{
//                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 100, 100)];
//                imageView.image = image;
//                [self.view addSubview:imageView];
//            });
//        }  
//    });
    
    //创建一个 __block semaphore,并将其资源初始值设置为0(不能少于0)
    //这里表示任务还没有完成,没有资源可用,主线程不要做事情.
    __block dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_queue_create("SumBlocks", NULL);
    dispatch_async(queue, ^(void) {
        int sum = 0;
        for(int i = 0; i < 10; i++)
            sum += i;
        NSLog(@" >> Sum: %d", sum);
        //增加semaphore计数，表明任务完成，有资源可用主线程可以做事情了
        dispatch_semaphore_signal(sem);
    });
    //主线程减少semaphore计数，如果资源数少于0，则表明资源还可不得，等待资源
    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    //一旦资源就绪并且得到调度了，再执行
    NSLog(@" >> end");
    dispatch_release(sem);  
    dispatch_release(queue);

}

- (void)addView:(UIView *)view num:(int)num{
    @synchronized(self){
        NSLog(@"view %d",num);
        [self.view addSubview:view];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    for (UIView *view in self.view.subviews) {
        [view removeFromSuperview];
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
