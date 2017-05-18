//
//  ApplyMatialViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ApplyMatialViewController.h"
#import "EmptyDataView.h"

@interface ApplyMatialViewController ()


@end

@implementation ApplyMatialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = GDLocalizedString(@"ApplyMater-001");  // @"我的申请材料"
    
    
    EmptyDataView *emptyView  =[EmptyDataView emptyViewWithBlock:^{}];
    emptyView.errorLab.text = GDLocalizedString(@"myOffer-001");
    [self.view addSubview:emptyView];
    emptyView.center = self.view.center;
  
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page申请材料"];
    
}

 
- (void)viewWillDisappear:(BOOL)animated
{
  
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page申请材料"];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
