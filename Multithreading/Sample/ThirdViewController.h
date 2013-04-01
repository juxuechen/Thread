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
}

@property (nonatomic,strong) IBOutlet UILabel *label;

@end
