//
//  FourthViewController.m
//  Multithreading
//
//  Created by Juxue Chen on 13-4-1.
//
//

#import "FourthViewController.h"

@interface FourthViewController ()

@end

@implementation FourthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateLabelWithText:(NSString *)text{
    
}

- (void)updateLabel1Text:(NSString *)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label1.text = [self.label1.text stringByAppendingString:text];
    });
}

- (void)updateLabel2Text:(NSString *)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label2.text = [self.label2.text stringByAppendingString:text];
    });
}

- (void)updateLabel3Text:(NSString *)text{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.label3.text = [self.label3.text stringByAppendingString:text];
    });
}

- (void)doSomethingIntensiveWith:(NSString *)str section:(int)section{
    NSLog(@"intensive with %@",str);
    
    for(int b = 0; b < 5000; b++)
        for(int aa = 0; aa < 50000; aa++);
    
    [self performSelectorOnMainThread:NSSelectorFromString([NSString stringWithFormat:@"updateLabel%dText:",section])
                           withObject:[NSString stringWithFormat:@"\t%@",str]
                        waitUntilDone:NO];
}

- (void)doSomethingWith:(NSArray *)array section:(int)section{
    NSLog(@"全部遍历执行结束");
    [self performSelectorOnMainThread:NSSelectorFromString([NSString stringWithFormat:@"updateLabel%dText:",section])
                           withObject:@"\ndone"
                        waitUntilDone:NO];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSArray *array = [[NSArray alloc] initWithObjects:@"obj1",@"obj2",@"obj3",@"obj4", nil];
    //一个dispatch group可以用来将多个block组成一组以监测这些Block全部完成或者等待全部完成时发出的消息。
    //使用函数dispatch_group_create来创建
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_group_t group = dispatch_group_create();
    //使用函数dispatch_group_async来将block提交至一个dispatch queue，同时将它们添加至一个组。
    
    for(id obj in array)
        dispatch_group_async(group, queue, ^{
            [self doSomethingIntensiveWith:obj section:1];
        });
    //等待group执行完毕
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    [self doSomethingWith:array section:1];
    
    for(NSString *obj in array)
        dispatch_group_async(group, queue, ^{
            [self doSomethingIntensiveWith:obj section:2];
        });
    dispatch_group_notify(group, queue, ^{
        //讲放doSomethingWith：在后台执行
        [self doSomethingWith:array section:2];
    });
    
    dispatch_release(group);
    
    
    dispatch_async(queue, ^{
        //调用单一block多次，并平行运算，然后等待所有运算结束.
        dispatch_apply([array count], queue, ^(size_t index){
            [self doSomethingIntensiveWith:[array objectAtIndex:index] section:3];
        });
        [self doSomethingWith:array section:3];
    });
    
    //3组在同一个queue种执行
    //方法1需要等待，所以完全执行后才开始方法2。
    //而方法2使用通知方式，所以在运行完array后就开始运行方法3了。
}

@end
