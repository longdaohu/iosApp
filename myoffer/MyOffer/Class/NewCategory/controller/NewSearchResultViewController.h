//
//  NewSearchResultViewController.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/7.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface NewSearchResultViewController : BaseViewController

- (instancetype)initWithFilter:(NSString *)key value:(NSString *)value orderBy:(NSString *)orderBy;

@end
