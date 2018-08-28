//
//  HomeYasiVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeYasiVC.h"
#import "HomeYaSiHeaderView.h"
#import "YaSiHomeModel.h"
#import "YSMyCourseVC.h"
#import "YaSiScheduleVC.h"

@interface HomeYasiVC ()
@property(nonatomic,strong)YaSiHomeModel *ysModel;

@end

@implementation HomeYasiVC



- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.ysModel = [[YaSiHomeModel alloc] init];
    [self makeYSHeaderView];
}

- (void)caseaaaa{
    
    YaSiScheduleVC *vc = [[YaSiScheduleVC alloc] init];
    PushToViewController(vc);
}

- (void)makeYSHeaderView{
    
    HomeYaSiHeaderView *header = [[HomeYaSiHeaderView alloc] initWithFrame:self.ysModel.header_frame];
    header.ysModel = self.ysModel;
    self.headerView = header;
    header.actionBlock = ^{
        [self caseaaaa];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
