//
//  IntelligentResultViewController.h
//  myOffer
//
//  Created by xuewuguojie on 15/11/6.
//  Copyright © 2015年 UVIC. All rights reserved.
//


#import "BaseViewController.h"
@interface IntelligentResultViewController : BaseViewController
//用于标识来自结果页的方式 push
//@property(nonatomic,copy)NSString *fromStyle;
@property(nonatomic,assign)BOOL from_Edit_Pipei;
//用于标识是否需要刷新PIECHAR
@property(nonatomic,assign)NSInteger refreshCount;

@end
