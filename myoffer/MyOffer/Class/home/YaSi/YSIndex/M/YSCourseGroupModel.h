//
//  YSCourseGroupModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/29.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSInteger,YSCourseGroupType) {
    YSCourseGroupTypeDefault,
    YSCourseGroupTypeFinished
};

@interface YSCourseGroupModel : NSObject
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)NSArray *IN_PROGRESS;
@property(nonatomic,strong)NSArray *FINISHED;
@property(nonatomic,strong,readonly)NSArray *curent_items;
@property(nonatomic,assign)YSCourseGroupType type;
@property(nonatomic,assign)CGFloat cell_height;

//@property(nonatomic,strong)NSArray *EXPIRED;
/*
 过期: 'EXPIRED',
 完成: 'FINISHED',
 进行中: 'IN_PROGRESS',
 NO_COURSE
 NOT_START
 IN_PROGRESS
 FINISHED
 EXPIRED
 */
@end


