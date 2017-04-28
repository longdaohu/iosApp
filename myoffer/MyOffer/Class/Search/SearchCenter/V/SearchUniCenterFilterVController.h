//
//  SearchUniCenterFilterVController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/4/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SearchUniCenterFilterViewBlock)(id value,NSString *key);

@interface SearchUniCenterFilterVController : UIViewController
//保证self.View最小高度
@property(nonatomic,assign)CGFloat base_Height;
@property(nonatomic,copy)NSString *CoreCountry;
@property(nonatomic,copy)NSString *CoreState;
@property(nonatomic,copy)NSString *Corecity;
@property(nonatomic,copy)NSString *CoreArea;

@property(nonatomic,copy)SearchUniCenterFilterViewBlock actionBlock;

- (instancetype)initWithActionBlock:(SearchUniCenterFilterViewBlock)actionBlock;


@end
