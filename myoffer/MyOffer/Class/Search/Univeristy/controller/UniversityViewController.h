//
//  UniversityViewController.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/24.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface UniversityViewController : BaseViewController
@property(nonatomic,copy)NSString *uni_id;
- (instancetype)initWithUniversityId:(NSString *)Uni_id;

@end
