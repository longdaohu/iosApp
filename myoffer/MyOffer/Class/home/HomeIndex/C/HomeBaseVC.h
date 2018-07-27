//
//  HomeBaseVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeBaseVC : BaseViewController
@property(nonatomic,strong)NSArray *groups;
@property(nonatomic,strong)UIView *headerView;

- (void)toLoadView;
- (void)toSetTabBarhidden;
- (void)reloadSection:(NSInteger)section;

@end
