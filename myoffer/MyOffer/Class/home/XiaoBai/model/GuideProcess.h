//
//  GuideProcess.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/11/15.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GuideProcess : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *desc;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,assign)BOOL line_hiden;
@property(nonatomic,assign)CGFloat item_offset_x;
@property(nonatomic,assign)NSInteger current_index;
@property(nonatomic,assign)NSInteger row;

@end
