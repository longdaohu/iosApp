//
//  XWGJTabBarController.h
//  MyOffer
//
//  Created by sara on 15/10/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWGJTabBarController : UITabBarController
@property(nonatomic,strong)UIImage *navImage;
//用于监听主页面是否打开状态
-(void)contentViewIsOpen:(BOOL)open;
@end
