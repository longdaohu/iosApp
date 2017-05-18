//
//  MyOfferViewController.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/8.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "MyOfferViewController.h"
#import "EmptyDataView.h"

@interface MyOfferViewController ()
@property (weak, nonatomic) IBOutlet UILabel *notiLabel;
@end

@implementation MyOfferViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"myOffer";

    self.notiLabel.text = GDLocalizedString(@"myOffer-001");
    
    
    EmptyDataView *emptyView  =[EmptyDataView emptyViewWithBlock:^{}];
    emptyView.errorLab.text = @"亲，您的offer无法在app上显示，请登录myoffer网站查看。";
    [self.view addSubview:emptyView];
    emptyView.center = self.view.center;
 
  
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page — 我的Offer"];
    
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page — 我的Offer"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
