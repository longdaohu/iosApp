//
//  PeiperGroup.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/3/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PeiperGroup : NSObject
@property(nonatomic,assign)BOOL selected;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,strong)UIColor *sliceColor;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *subtitle;
@property(nonatomic,strong)NSNumber *slice_count;
@property(nonatomic,strong)NSString *slice_angle;
+ (instancetype)groupWithTitle:(NSString *)title subtitle:(NSString *)subtitle items:(NSArray *)items;

@end


