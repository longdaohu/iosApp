//
//  XliuxueHeaderView.h
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XliuxueHeaderView : UIView
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)CGFloat Height;

+(instancetype)headView;
@end
