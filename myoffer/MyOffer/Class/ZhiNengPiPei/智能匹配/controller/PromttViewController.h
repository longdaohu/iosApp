//
//  PromttViewController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/9.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^promptViewControllerBlock)();
@interface PromttViewController : UIViewController
@property(nonatomic,copy)promptViewControllerBlock actionBlock;
+ (instancetype)promptViewWithBlock:(promptViewControllerBlock)actionBlock;
@end

