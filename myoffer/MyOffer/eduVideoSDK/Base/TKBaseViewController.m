//
//  TKBaseViewController.m
//  EduClass
//
//  Created by lyy on 2018/4/19.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "TKBaseViewController.h"

@interface TKBaseViewController ()

@end

@implementation TKBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadBackGroundView];
    // Do any additional setup after loading the view.
}
- (void)loadBackGroundView{
    
    //背景图片
    UIImageView *backImageView = [[UIImageView alloc]init];
    backImageView.sakura.image(@"Login.login_bg");
    backImageView.contentMode =  UIViewContentModeScaleAspectFill;
    
    backImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    [self.view addSubview:backImageView];
    backImageView.userInteractionEnabled = YES;
    self.backgroundImageView = backImageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
