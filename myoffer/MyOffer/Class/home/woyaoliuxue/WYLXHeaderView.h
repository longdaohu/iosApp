//
//  XliuxueHeaderView.h
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYLXHeaderView : UIView
@property(nonatomic,copy)NSString *content;
+(instancetype)headViewWithContent:(NSString *)content;
@end
