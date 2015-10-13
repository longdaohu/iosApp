//
//  EngAboutViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/12.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "EngAboutViewController.h"

@interface EngAboutViewController ()
@property (weak, nonatomic) IBOutlet UITextView *aboutTextView;

@end

@implementation EngAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"About";//@"关于";
    self.aboutTextView.textContainerInset = UIEdgeInsetsMake(0, 5, 0, 5);
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    

}



@end
