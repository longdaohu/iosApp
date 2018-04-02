//
//  EvaluateSearchCollegeViewController.h
//  MyOffer
//
//  Created by xuewuguojie on 15/9/24.
//  Copyright (c) 2015年 UVIC. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^ValueBackBlock)(NSString *);

@interface EvaluateSearchCollegeViewController : BaseViewController
@property(nonatomic,copy)ValueBackBlock valueBlock;
@end
