//
//  NewSearchRstViewController.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface NewSearchRstViewController : BaseViewController
- (instancetype)initWithSearchText:(NSString *)text key:(NSString *)key orderBy:(NSString *)orderBy;
- (instancetype)initWithSearchText:(NSString *)text orderBy:(NSString *)orderBy;
@end
