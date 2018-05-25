//
//  RewardHeader.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RewardHeader : UIView
@property(nonatomic,assign)BOOL isMoney;
@property(nonatomic,copy)NSString *dollor;
@property(nonatomic,copy)NSString *title;

- (void)bottomLineHiden:(BOOL)hiden;

@end
