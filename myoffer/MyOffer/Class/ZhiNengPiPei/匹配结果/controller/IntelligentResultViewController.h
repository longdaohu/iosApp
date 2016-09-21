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
@property(nonatomic,assign)BOOL isComeBack;
@end
