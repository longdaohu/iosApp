//
//  MessageSectionHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/7.
//  Copyright © 2017年 UVIC. All rights reserved.
//

 
#import <UIKit/UIKit.h>

typedef void(^MessageBlock)(UIButton *sender);

@interface MessageSectionHeaderView : UIView
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,copy)MessageBlock actionBlock;

+ (instancetype)headerWithAction:(MessageBlock)actionBlock;

@end


