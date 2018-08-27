//
//  RoomMapVC.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomMapVC.h"

@interface RoomMapVC ()<UITextFieldDelegate,UICollectionViewDataSource,UICollectionViewDelegate>

@end

@implementation RoomMapVC

-(void)viewWillAppear:(BOOL)animated
{
    NavigationBarHidden(YES);
    [MobClick beginLogPageView:@"page51Room房源详情"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:@"page51Room房源详情"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self makeUI];
    [self makeData];
}

- (void)makeUI{
    
    CGFloat left_margin = 20;
    CGFloat item_y = XStatusBar_Height + 20;
    CGSize item_size = CGSizeMake(36, 36);
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(left_margin, item_y , item_size.width, item_size.height)];
    backBtn.layer.cornerRadius = item_size.height * 0.5;
    [backBtn setImage:XImage(@"back_arrow_black") forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(casePop) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    backBtn.backgroundColor = XCOLOR_WHITE;
    backBtn.layer.cornerRadius = item_size.height * 0.5;
    

    CGFloat search_x = left_margin + item_size.width + 10;
    CGFloat search_w = XSCREEN_WIDTH - left_margin - search_x;
    UITextField *searchTF = [[UITextField alloc] initWithFrame:CGRectMake(search_x, item_y, search_w , item_size.height)];
    [self.view addSubview:searchTF];
    searchTF.font = XFONT(10);
    searchTF.backgroundColor = XCOLOR_WHITE;
    searchTF.layer.cornerRadius = item_size.height * 0.5;
    searchTF.placeholder = @"输入关键字搜索城市，大学，公寓";
    searchTF.clearButtonMode =  UITextFieldViewModeAlways;
    searchTF.layer.shadowColor = XCOLOR_BLACK.CGColor;
    searchTF.layer.shadowOffset = CGSizeMake(0, 3);
    searchTF.layer.shadowOpacity = 0.1;
 
    UIImageView *leftView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 13)];
    leftView.contentMode = UIViewContentModeScaleAspectFit;
    [leftView setImage:XImage(@"home_application_search_icon")];
    searchTF.leftView = leftView;
    searchTF.leftViewMode =  UITextFieldViewModeUnlessEditing;
    searchTF.delegate = self;
    
    
    UICollectionViewFlowLayout  *flow = [[UICollectionViewFlowLayout alloc] init];
    CGFloat bg_x  = 0;
    CGFloat bg_h  = 150;
    CGFloat bg_y  = self.view.mj_h - bg_h;
    CGFloat bg_w  = XSCREEN_WIDTH;
    flow.itemSize = CGSizeMake(bg_w, bg_h);
    flow.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flow.minimumLineSpacing = 0;
    UICollectionView *bgView = [[UICollectionView alloc] initWithFrame:CGRectMake(bg_x, bg_y, bg_w, bg_h) collectionViewLayout:flow];
    bgView.backgroundColor = XCOLOR_RANDOM;
    [self.view addSubview:bgView];
    bgView.dataSource = self;
    bgView.delegate = self;
    bgView.pagingEnabled = YES;
    [bgView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];

}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 10;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UICollectionViewCell" forIndexPath:indexPath];
    cell.contentView.backgroundColor = XCOLOR_RANDOM;
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark : 数据请求

- (void)makeData{
    
}

#pragma mark : UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
//    [self.navigationController popViewControllerAnimated:YES];
    
    return NO;
}

#pragma mark : 事件处理
- (void)casePop{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
