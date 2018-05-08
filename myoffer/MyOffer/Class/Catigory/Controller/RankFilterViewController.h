//
//  RankFilterViewController.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/10/13.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rankFilter.h"
typedef void(^RankFilterViewControllerBlock)(void);
@interface RankFilterViewController : UIViewController
//排序筛选数据
@property(nonatomic,strong)rankFilter *rankFilterModel;
@property(nonatomic,copy)RankFilterViewControllerBlock actionBlock;
@end
