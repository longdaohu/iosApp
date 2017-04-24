//
//  UniversitySubjectListViewController.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface UniversitySubjectListViewController : BaseViewController
- (instancetype)initWithUniversityID:(NSString *)ID;
@property (readonly) NSString *universityID;

@end
