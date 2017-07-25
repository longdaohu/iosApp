//
//  UniDetailGroups.h
//  myOffer
//
//  Created by xuewuguojie on 16/9/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UniDetailGroup : NSObject
//分组数组数据
@property(nonatomic,strong)NSArray  *items;
//分组header
@property(nonatomic,copy)NSString   *HeaderTitle;
@property(nonatomic,copy)NSString   *accessory_title;
//行高
@property(nonatomic,assign)CGFloat   cellHeight;
//是否是分组footer
@property(nonatomic,assign)BOOL      HaveFooter;
//是否是分组header
@property(nonatomic,assign)BOOL      HaveHeader;
+(instancetype)groupWithTitle:(NSString *)title contentes:(NSArray *)items  andFooter:(BOOL)footer;

@end
