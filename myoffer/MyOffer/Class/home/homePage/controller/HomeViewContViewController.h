//
//  HomeViewContViewController.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

typedef enum {
    HomePageClickItemTypeNoClick,
    HomePageClickItemTypePipei,
    HomePageClickItemTypetest
}HomePageClickItemType;

@interface HomeViewContViewController : BaseViewController
//已选择服务项
@property(nonatomic,assign)HomePageClickItemType clickType;

-(void)leftViewMessage;

@end
