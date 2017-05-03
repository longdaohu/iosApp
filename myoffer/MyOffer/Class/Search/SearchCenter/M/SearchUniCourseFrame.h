//
//  SearchUniCourseFrame.h
//  myOffer
//
//  Created by xuewuguojie on 2017/5/2.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UniversityCourse.h"


@interface SearchUniCourseFrame : NSObject
@property(nonatomic,strong)UniversityCourse *course;
@property(nonatomic,assign)CGRect official_name_Frame;
@property(nonatomic,assign)CGRect option_Frame;
@property(nonatomic,assign)CGRect items_bg_Frame;
@property(nonatomic,strong)NSArray *items_Frame;
@property(nonatomic,assign)CGFloat  cell_Height;

+ (instancetype)frameWithCourse:(UniversityCourse *)course;

@end
