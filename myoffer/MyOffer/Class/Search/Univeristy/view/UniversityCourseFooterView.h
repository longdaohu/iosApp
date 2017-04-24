//
//  UniversityCourseFooterView.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^UniCourseFooterViewBlock)();
@interface UniversityCourseFooterView : UIView
@property(nonatomic,assign)NSInteger count;
@property(nonatomic,copy)UniCourseFooterViewBlock actionBlock;

@end
