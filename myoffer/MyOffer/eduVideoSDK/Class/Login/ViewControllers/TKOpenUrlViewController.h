//
//  TKOpenUrlViewController.h
//  EduClassPad
//
//  Created by ifeng on 2018/1/12.
//  Copyright © 2018年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TKOpenUrlViewController : UIViewController
@property(nonatomic,assign)UIInterfaceOrientation orientation;
@property(nonatomic,copy)NSString *url;
-(void)openUrl:(NSString*)aString;
@end
