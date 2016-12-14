//
//  mergeAccountViewController.m
//  myOffer
//
//  Created by xuewuguojie on 2016/11/10.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "mergeAccountViewController.h"
#import "mergeItemView.h"
#import "mergeSuccessViewController.h"

@interface mergeAccountViewController ()
//提示文字
@property(nonatomic,strong)UILabel *notiLab;
//第三方
@property(nonatomic,strong)mergeItemView *thisView;
//手机项
@property(nonatomic,strong)mergeItemView *thatView;
//提交按钮
@property(nonatomic,strong)UIButton *mergeBtn;
//网络请求信息
@property(nonatomic,strong)NSDictionary *response;
//选择合并ID
@property(nonatomic,copy)NSString *selected_id;

@end

@implementation mergeAccountViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [MobClick beginLogPageView:@"page选择留取账号"];
    
}


-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    [super viewWillDisappear:animated];
    
    [MobClick endLogPageView:@"page选择留取账号"];
    
}


 

- (void)viewDidLoad {
    
    [super viewDidLoad];

    [self makeUI];

    [self getDataSource];
    
}

//网络请求
- (void)getDataSource{


    NSString *path = [NSString stringWithFormat:@"GET api/account/tomerge?that_phonenumber=%@",self.mergePhone];
    [self startAPIRequestUsingCacheWithSelector:path parameters:nil success:^(NSInteger statusCode, id response) {
 
        [self updateUIWithResponse:response];
        
    }];
    
  
}

//更新UI
- (void)updateUIWithResponse:(id)response{
    
    self.response = response;

    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    NSString *provider = [ud valueForKey:@"provider"];
    
    NSString *imageName;
    if ([[provider lowercaseString]  containsString:@"qq"]) {
        imageName = @"meger_QQ";
    }else if ([[provider lowercaseString]  containsString:@"weibo"]){
        imageName = @"meger_wb";
    }else{
        imageName = @"meger_wx";
    }
    
    self.thisView.itemAccout = response[@"this_account"];
    self.thisView.logoView.image = [UIImage imageNamed:imageName];
    
    self.thatView.itemAccout  = response[@"that_account"];
    self.thatView.logoView.image = [UIImage imageNamed:@"meger_Phone"];
    
}



- (void)makeUI{
    
    self.title = @"选择留取账号";
    
    //提示文字
    CGFloat notiX = 20;
    CGFloat notiW = XSCREEN_WIDTH - notiX * 2;
    NSString *notiStr = @"请选择您要保留的账号，合并账号后另一个账号资料将被替换";
    CGSize notiSize = [notiStr boundingRectWithSize:CGSizeMake(notiW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : XFONT(16)} context:nil].size;
    CGFloat notiY = 30;
    CGFloat notiH = notiSize.height;
    UILabel *notiLab = [UILabel labelWithFontsize:16 TextColor:XCOLOR_BLACK  TextAlignment:NSTextAlignmentLeft];
    notiLab.frame = CGRectMake(notiX, notiY, notiW, notiH);
    [self.view addSubview:notiLab];
    notiLab.numberOfLines = 0;
    self.notiLab = notiLab;
    notiLab.text =  notiStr;
    
    
     //第三方
    CGFloat thisX = notiX;
    CGFloat thisY = CGRectGetMaxY(notiLab.frame)  + 20;
    CGFloat thisW = notiW;
    CGFloat thisH = 80;
    mergeItemView *thisView = [[mergeItemView  alloc] initWithFrame:CGRectMake( thisX, thisY, thisW, thisH )];
    self.thisView = thisView;
    [self.view addSubview:thisView];
    thisView.actionBlock = ^(NSString *item){
        
        self.selected_id = item;
        [self mergeViewWithItem:self.thatView];
        
    };
    
    //手机
    CGFloat phoneX = thisX;
    CGFloat phoneY = CGRectGetMaxY(thisView.frame)  + 10;
    CGFloat phoneW = thisW;
    CGFloat phoneH = thisH;
    mergeItemView *thatView = [[mergeItemView  alloc] initWithFrame:CGRectMake(phoneX, phoneY, phoneW, phoneH)];
    self.thatView  = thatView;
    [self.view addSubview:thatView];
    thatView.actionBlock = ^(NSString *item){
        
         self.selected_id = item;
        [self mergeViewWithItem:self.thisView];
        
    };
    
    //提交按钮
    CGFloat mergeX = phoneX;
    CGFloat mergeY = CGRectGetMaxY(thatView.frame) + 50;
    CGFloat mergeW = phoneW;
    CGFloat mergeH = 50;
    UIButton *mergeBtn = [[UIButton alloc] initWithFrame:CGRectMake(mergeX, mergeY, mergeW, mergeH)];
    [self.view addSubview:mergeBtn];
    [mergeBtn setTitle:@"同意合并"  forState:UIControlStateNormal];
    [mergeBtn addTarget:self action:@selector(caseMerge:) forControlEvents:UIControlEventTouchUpInside];
    mergeBtn.titleLabel.font = XFONT(16);
    mergeBtn.layer.cornerRadius = CORNER_RADIUS;
    self.mergeBtn = mergeBtn;
    [mergeBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    [mergeBtn setTitleColor:XCOLOR_DARKGRAY forState:UIControlStateDisabled];
    mergeBtn.backgroundColor = XCOLOR_LIGHTGRAY;
    mergeBtn.enabled = NO;
    
    
    UIButton *leftBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    [leftBtn addTarget:self action:@selector(caseNoClick) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"close_button"] style:UIBarButtonItemStyleDone target:self action:@selector(caseBack)];
    
 
}

//合并项切换
- (void)mergeViewWithItem:(mergeItemView *)item{
    
    
    if (item == self.thisView) {
        
        [self.thisView mergeItemViewInSelected:NO];
        
        [self.thatView mergeItemViewInSelected:YES];
        
    }else{
        
        [self.thisView mergeItemViewInSelected:YES];
        
        [self.thatView mergeItemViewInSelected:NO];
        
    }
    
    if (!self.mergeBtn.enabled) {
        
         self.mergeBtn.enabled = YES;
         self.mergeBtn.backgroundColor = XCOLOR_RED;
        [self.mergeBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        
    }
    
    

}

//提交合并
- (void)caseMerge:(UIButton *)sender{
  
    XWeakSelf
    [self startAPIRequestWithSelector:@"POST api/account/merge"  parameters:@{@"that_account_id": self.response[@"that_account"][@"_id"], @"final_account_id":  self.selected_id}  expectedStatusCodes:nil showHUD:YES showErrorAlert:YES errorAlertDismissAction:nil additionalSuccessAction:^(NSInteger statusCode, id response) {
        
        [weakSelf.navigationController  pushViewController:[[mergeSuccessViewController alloc] init]  animated:YES];
        
    } additionalFailureAction:^(NSInteger statusCode, NSError *error) {
        
        
    }];
    
    
}

//返回当前页
- (void)caseBack{

    [[AppDelegate sharedDelegate] logout];
    
    [MobClick profileSignOff];/*友盟第三方统计功能统计退出*/
    
    [APService setAlias:@"" callbackSelector:nil object:nil];  //设置Jpush用户所用别名为空
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)caseNoClick{
    
    KDClassLog(@"没反应");
    
}


-(void)dealloc{
    
    KDClassLog(@"选择留取账号  dealloc");
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
