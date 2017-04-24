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
@property(nonatomic,assign)CGFloat base_Height;
@property(nonatomic,strong)NSArray *areas;
@property(nonatomic,copy)UniversityCourseFilterViewBlock actionBlock;

@end
