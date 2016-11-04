//
//  promptViewController.h
//  myOffer
//
//  Created by xuewuguojie on 2016/11/3.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BaseViewController.h"
typedef void(^promptViewControllerBlock)();
@interface promptViewController : BaseViewController
@property(nonatomic,copy)promptViewControllerBlock actionBlock;

- (instancetype)initWithBlock:(promptViewControllerBlock)actionBlock;

@end
