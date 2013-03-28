//
//  MultithreadingFirstViewController.m
//  Multithreading
//
//  Created by Chen Yang on 12-3-19.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "FirstViewController.h"

@implementation FirstViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"thread", @"thread");
        self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
        sem = dispatch_semaphore_create(0);
    }
    return self;
}
							
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)dealloc {
    dispatch_release(sem);
    dispatch_release(queue);
    
    [self.activityView stopAnimating];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    i = 0;
    codition = [[NSCondition alloc] init];
    
    self.waitingView.hidden = YES;
    [self.activityView startAnimating];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)methodF:(id)sender {
    NSLog(@"1 log  %d",i);
    
    [codition lock];
    while (i == 0)
        [codition wait];
    NSLog(@"3 wait over log  %d",i);
    i++; 
    // Do real work here.
    [codition unlock];
}

- (void)methodS:(id)sender {
//    @synchronized(sender)
//    {
//        NSLog(@"i=%d,%@",i++,sender);
//    }
    NSLog(@"2 my  %d",i);
    [codition lock];
    [NSThread sleepForTimeInterval:0.5];
    i++;
    [codition signal];
    [codition unlock];
}


- (void)treadObserver {
    NSLog(@"thread change");
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self 
                                             selector:@selector(treadObserver) 
                                                 name:NSWillBecomeMultiThreadedNotification 
                                               object:nil];
    
    //[NSThread detachNewThreadSelector:@selector(log:) toTarget:self withObject:nil];
    
    NSThread *fr = [[NSThread alloc] initWithTarget:self selector:@selector(methodF:) object:@"fr"];
    NSThread *sr = [[NSThread alloc] initWithTarget:self selector:@selector(methodS:) object:@"sr"];
    [fr start];
    [sr start];
    
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    dispatch_queue_t myCustomQueue;
    myCustomQueue = dispatch_queue_create("com.example.MyCustomQueue", NULL);
    
    //后台处理数据，然后回到主界面更新UI
    /*dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"在全局并发队列做一些事情");
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"回到主线程中");
        });
    });
    
    //先从主线程取数据，然后在后台动作。
    dispatch_queue_t bgQueue = myCustomQueue;
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"get view data");
        dispatch_async(bgQueue, ^{
            NSLog(@"use stringValue in the background now");
        });
    });
    
    //提交一个队列的Job   在全局并发队列
    //调用dispatch_async函数，传入一个队列和一个block。
    //队列会在轮到这个block执行时执行这个block的代码。
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"提交一个队列的Job1");
    });
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"提交一个队列的Job2");
    });
    
    
    __block NSString *stringValue;
    dispatch_sync(bgQueue, ^{
        stringValue = @"完成了";
    });
    NSLog(@"%@",stringValue);
    
    
    //dispatch group
    NSArray *array = [[NSArray alloc] initWithObjects:@"abc",@"def",@"abba",@"cddc", nil];
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t group = dispatch_group_create();
//    for(NSString *obj in array)
//        dispatch_group_async(group, queue, ^{
//            [self doSomethingIntensiveWith:obj];
//        });
//    dispatch_group_notify(group, queue, ^{
//        [self doSomethingWith:array];
//    });
//    dispatch_release(group);
//    
//    [self doSomethingWith:array];
    
    dispatch_async(queue, ^{
        dispatch_apply([array count], queue, ^(size_t index){
            [self doSomethingIntensiveWith:[array objectAtIndex:index]];
        });
        [self doSomethingWith:array];
    });*/
    
    queue = dispatch_queue_create("SumBlocks", NULL);
}

- (void)doSomethingIntensiveWith:(NSString *)str {
    NSLog(@"intensive with %@",str);
}

- (void)doSomethingWith:(NSArray *)array {
    NSLog(@"全部遍历执行结束");
}


- (IBAction)selectA:(id)sender {
    NSLog(@"选择A");
    
    sem = dispatch_semaphore_create(0);
    dispatch_async(queue, ^(void) {
        NSLog(@"开始计时");
        
        int sum = 0;
        for(int b = 0; b < 10000; b++) {
            sum = 0;
            for(int aa = 0; aa < 100000; aa++)
                sum += aa;
        }
        NSLog(@" >> Sum: %d", sum);
        NSLog(@"计时结束");
        
        dispatch_semaphore_signal(sem);
    });
}

- (IBAction)selectB:(id)sender {
    NSLog(@"选择B");
    self.waitingView.hidden = NO;

//    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
//    NSLog(@"等待结束");
//    sem = dispatch_semaphore_create(1);
//    
//    NSLog(@"完成B");
    /***B的等待，如果在主线程，会影响UI，所以在全局队列中等待，等待后回到主线程。改为如下做法。***/
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        NSLog(@"等待结束");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"完成B");
            self.waitingView.hidden = YES;
            sem = dispatch_semaphore_create(1);
            
        });
    });
}



@end