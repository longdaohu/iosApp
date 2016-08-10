//
//  XUTopToolView.h
//  XUObject
//
//  Created by xuewuguojie on 16/4/18.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XTopToolView;
@protocol XTopToolViewDelegate  <NSObject>
-(void)XTopToolView:(XTopToolView *)topToolView andButtonItem:(UIButton *)sender;

@end

@interface XTopToolView : UIView

@property(nonatomic,weak)id<XTopToolViewDelegate> delegate;
@property(nonatomic,strong)NSArray *itemImages;
+(instancetype)View;
-(void)SelectButtonIndex:(NSInteger)index;

@end
