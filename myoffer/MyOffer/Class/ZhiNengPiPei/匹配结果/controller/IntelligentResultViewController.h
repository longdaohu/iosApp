//
//  IntelligentResultViewController.h
//  myOffer
//
//  Created by xuewuguojie on 15/11/6.
//  Copyright © 2015年 UVIC. All rights reserved.
//


#import "BaseViewController.h"
@interface IntelligentResultViewController : BaseViewController
@property (strong, nonatomic) IBOutlet UIView *NoDataView;
@property (weak, nonatomic) IBOutlet UILabel *NoDataLabel;
//用于标识来自结果页的方式 push
@property(nonatomic,copy)NSString *fromStyle;
@property(nonatomic,assign)NSInteger refreshCount;

@end
