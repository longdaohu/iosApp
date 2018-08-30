//
//  HomeYaSiHeaderView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YaSiHomeModel;

@interface HomeYaSiHeaderView : UIView
@property(nonatomic,strong)YaSiHomeModel *ysModel;
@property(nonatomic,assign)BOOL userSigned;
@property(nonatomic,copy)void(^actionBlock)();

@end

