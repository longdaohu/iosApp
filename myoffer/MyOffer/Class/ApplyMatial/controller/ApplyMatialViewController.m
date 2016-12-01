//
//  ApplyMatialViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ApplyMatialViewController.h"
@interface ApplyMatialViewController ()


@end

@implementation ApplyMatialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = GDLocalizedString(@"ApplyMater-001");  // @"我的申请材料"
    
    
    XWGJnodataView *noDataView =[XWGJnodataView noDataView];
    noDataView.contentLabel.text =  GDLocalizedString(@"myOffer-001");
    [self.view addSubview:noDataView];
    
    
//    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
//    [leftBtn addTarget:self action:@selector(xxxxx) forControlEvents:UIControlEventTouchUpInside];
//    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page申请材料"];
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}


- (void)viewWillDisappear:(BOOL)animated
{
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;

    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page申请材料"];
    
}

//- (void)caseBack{
//
//    [self.navigationController popViewControllerAnimated:YES];
//}

//- (void)xxxxx{
//
//    NSLog(@"xxxxx 测试");
//}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
