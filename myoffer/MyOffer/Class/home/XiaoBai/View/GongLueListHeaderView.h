//
//  GongLueListHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface GongLueListHeaderView : UIView
@property(nonatomic,strong)NSDictionary *gongLueDic;
@property(nonatomic,strong)UILabel *headerTitleLab;
//传入tableView的contentOffsetY
@property(nonatomic,assign)CGFloat contentOffsetY;
//小MO头像及其他控件背景
@property(nonatomic,strong)UIView *moBgView;

@end
