//
//  XUTopToolView.h
//  XUObject
//
//  Created by xuewuguojie on 16/4/18.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XBTopToolView;
@protocol XTopToolViewDelegate  <NSObject>
-(void)XTopToolView:(XBTopToolView *)topToolView andButtonItem:(UIButton *)sender;
@end

@interface XBTopToolView : UIView
@property(nonatomic,weak)id<XTopToolViewDelegate> delegate;
//监听选项
@property(nonatomic,assign)NSInteger selectedIndex;
//按钮名称数组
@property(nonatomic,strong)NSArray *itemNames;


@end
