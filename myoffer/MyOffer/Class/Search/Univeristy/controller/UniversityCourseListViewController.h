//
//  UniversityCourseListViewController.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/12.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface UniversityCourseListViewController : BaseViewController
- (instancetype)initWithUniversityID:(NSString *)ID;
@property (readonly) NSString *universityID;

@end
