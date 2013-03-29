//
//  SecondViewController.m
//  Multithreading
//
//  Created by Juxue Chen on 13-3-28.
//
//

#import "SecondViewController.h"
#import "TestOperation.h"

@interface SecondViewController ()

@end

@implementation SecondViewController

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

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    serialNumber = 1;
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue setMaxConcurrentOperationCount:5];
    for (int j = 1; j <= 20; j++) {
        TestOperation *op = [[TestOperation alloc] initWithTarget:self selector:@selector(addView:) object:[NSNumber numberWithInt:j]];
        op.i = j;
        [queue addOperation:op];
    }
}

- (void)addView:(NSNumber *)num{
    @synchronized(self){//只有一个线程可以访问这个函数
        NSLog(@"第%d个进来",[num intValue]);
        int j = [num intValue];

        [self performSelectorOnMainThread:@selector(updateUI:)
                               withObject:[NSNumber numberWithInt:j]
                            waitUntilDone:NO];
        //waitUntilDone是表示是否阻塞子线程
    }
}

- (void)updateUI:(NSNumber *)number {
    UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(60, 12 + 15 * serialNumber, 200, 12)];
    label.backgroundColor = [UIColor greenColor];
    label.font = [UIFont systemFontOfSize:12.];
    label.text = [NSString stringWithFormat:@"%d是第%d个添加上界面",[number intValue],serialNumber];
    [self.view addSubview:label];
    
    serialNumber++;
    
    NSLog(@"updateui %@",label);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
