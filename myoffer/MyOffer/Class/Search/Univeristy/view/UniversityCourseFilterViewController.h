//
//  UniversityCourseFilterViewController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/4/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UniversityCourseFilterViewBlock)(NSString *value,NSString *key);

@interface UniversityCourseFilterViewController : UIViewController
//保证self.View最小高度
@property(nonatomic,assign)CGFloat base_Height;

@property(nonatomic,strong)NSDictionary *leftInfo;
@property(nonatomic,strong)NSDictionary *rightInfo;
//当前已选择项
@property(nonatomic,copy)NSString *current_Level;
@property(nonatomic,copy)NSString *current_area;


@property(nonatomic,copy)UniversityCourseFilterViewBlock actionBlock;

- (instancetype)initWithActionBlock:(UniversityCourseFilterViewBlock)actionBlock;

@end
