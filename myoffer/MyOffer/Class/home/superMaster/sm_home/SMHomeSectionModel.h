//
//  SMHomeItem.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SMTagModel.h"

@interface SMHomeSectionModel : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *accessory_title;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)NSArray *item_all;
@property(nonatomic,assign)NSInteger index;
//@property(nonatomic,assign)BOOL showMore;
@property(nonatomic,assign)BOOL showAll;
@property(nonatomic,assign)NSInteger limit_count;
//@property(nonatomic,assign)BOOL have_footer;

+ (instancetype)sectionInitWithTitle:(NSString *)title Items:(NSArray *)items  index:(NSInteger)index;

@end
