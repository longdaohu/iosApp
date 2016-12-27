//
//  MessageHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^MessageBlock)(UIButton *);
@interface XWGJMessageButtonItemView : UIView
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,copy)MessageBlock ActionBlock;
@property(nonatomic,assign)NSInteger LastIndex;

@end
