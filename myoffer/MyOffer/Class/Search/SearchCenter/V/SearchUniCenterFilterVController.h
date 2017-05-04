//
//  SearchUniCenterFilterVController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/4/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchUniCenterFilterViewBlock)(NSArray *parameters);

@interface SearchUniCenterFilterVController : UIViewController
//保证self.View最小高度
@property(nonatomic,assign)CGFloat base_Height;
@property(nonatomic,copy)NSString *coreCountry;
@property(nonatomic,copy)NSString *coreState;
@property(nonatomic,copy)NSString *corecity;
@property(nonatomic,copy)NSString *coreArea;
@property(nonatomic,copy)NSString *currentRankType;
//排名数组
@property(nonatomic,strong)NSArray *rankings;

@property(nonatomic,copy)SearchUniCenterFilterViewBlock actionBlock;

- (instancetype)initWithActionBlock:(SearchUniCenterFilterViewBlock)actionBlock;


@end
