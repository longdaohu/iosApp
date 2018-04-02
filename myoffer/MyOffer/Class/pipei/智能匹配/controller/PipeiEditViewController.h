//
//  PipeiEditViewController.h
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^PipeiEditViewControllerBlock)(NSString *);

@interface PipeiEditViewController : BaseViewController
//用于标识是否来自匹配结果页  当来自于结果页时，选择pop方式回退到结果页
@property(nonatomic,assign)BOOL isfromPipeiResultPage;
//用于判断是否来自学校详情页面
@property(nonatomic,copy)NSString *Uni_Country;
@property(nonatomic,copy)PipeiEditViewControllerBlock actionBlock;

@end
