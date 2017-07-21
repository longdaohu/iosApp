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
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,assign)NSInteger index;

+ (instancetype)sectionInitWithTitle:(NSString *)title Items:(NSArray *)items  index:(NSInteger)index;

@end
