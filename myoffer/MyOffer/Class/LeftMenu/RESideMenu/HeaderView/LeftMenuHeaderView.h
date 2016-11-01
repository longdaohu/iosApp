//
//  LeftMenuHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 2016/11/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuHeaderView : UIView
//头像
@property (weak, nonatomic) IBOutlet UIImageView *userIconView;
//根据网络请求数据加载header
@property(nonatomic,strong)NSDictionary *response;
//判断是否有头像
@property(nonatomic,assign)BOOL haveIcon;
//用户登出后还原头像
-(void)headerViewWithUserLoginOut;
@end
