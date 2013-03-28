//
//  SecondViewController.m
//  Multithreading
//
//  Created by Juxue Chen on 13-3-28.
//
//

#import "SecondViewController.h"

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
    
    //堵塞主线程了，UI无法及时。。。。
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    for (int j = 0; j < 10; j++) {
        NSInvocationOperation *op = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(addView:) object:[NSNumber numberWithInt:j]];
        [queue addOperation:op];
    }
}

- (void)addView:(NSNumber *)num{
    @synchronized(self){
        int j = [num intValue];
        NSLog(@"num %@",num);
        UILabel *label= [[UILabel alloc] initWithFrame:CGRectMake(60, 10 + 20 * (j++), 200, 10)];
        label.backgroundColor = [UIColor greenColor];
        label.text = [NSString stringWithFormat:@"第%d个执行",serialNumber++];
        
        [self.view addSubview:label];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
