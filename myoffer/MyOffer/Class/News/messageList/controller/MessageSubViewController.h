//
//  MessageSubViewController.h
//  MYOFFERDEMO
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 xuewuguojie. All rights reserved.
//

#import "BaseViewController.h"

@interface MessageSubViewController : BaseViewController
@property(nonatomic,strong)NSArray *catigories;
@property(nonatomic,assign)CGFloat cell_Height;

- (void)superViewScroll:(UITableView * )superView contentOffsetY:(CGFloat)Y;
- (void)superViewScrollEnable:(BOOL)enable;

@end
