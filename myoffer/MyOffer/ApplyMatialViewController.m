//
//  ApplyMatialViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ApplyMatialViewController.h"

@interface ApplyMatialViewController ()
@property (weak, nonatomic) IBOutlet UILabel *notiLabel;

@end

@implementation ApplyMatialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = GDLocalizedString(@"ApplyMater-001");  // Apply Materianls  @"我的申请材料"
    
    self.notiLabel.text =  GDLocalizedString(@"myOffer-001");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
