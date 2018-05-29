//
//  InvitationVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "InvitationVC.h"
#import "InvitationRecordsVC.h"


@interface InvitationVC ()

@end

@implementation InvitationVC
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    NavigationBarHidden(NO);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"邀请有礼";
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





@end
