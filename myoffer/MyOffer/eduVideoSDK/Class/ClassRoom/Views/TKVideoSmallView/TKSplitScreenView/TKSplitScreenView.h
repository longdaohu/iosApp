//
//  TKSplitScreenView.h
//  EduClassPad
//
//  Created by lyy on 2017/11/21.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKVideoSmallView.h"

@interface TKSplitScreenView : UIView

@property (nonatomic, strong) NSMutableArray *videoSmallViewArray;
/**
 *添加视频窗口
 */
- (void)addVideoSmallView:(TKVideoSmallView *)view;
/**
 *删除指定视频窗口
 */
- (void)deleteVideoSmallView:(TKVideoSmallView *)view;
/**
 *删除所有视频窗口
 */
- (void)deleteAllVideoSmallView;

- (void)refreshSplitScreenView;

@end
