//
//  XliuxueHeaderView.h
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WYLXHeaderViewBlock)(void);

@interface WYLXHeaderView : UIView

@property(nonatomic,copy)WYLXHeaderViewBlock actionBlock;

+(instancetype)headViewWithTitle:(NSString *)title;

@end
