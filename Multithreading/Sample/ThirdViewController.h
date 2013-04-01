//
//  ThirdViewController.h
//  Multithreading
//
//  Created by Juxue Chen on 13-3-29.
//
//

#import <UIKit/UIKit.h>

@interface ThirdViewController : UIViewController {
    int i;
    NSCondition *codition;
//实现多线程同步
}

@property (nonatomic,strong) IBOutlet UILabel *label;

@end
