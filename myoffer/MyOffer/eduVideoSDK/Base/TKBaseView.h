//
//  TKBaseView.h
//  EduClass
//
//  Created by lyy on 2018/4/27.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKBaseView : UIView

- (id)initWithFrame:(CGRect)frame from:(NSString *)from;

@property (nonatomic, copy) dispatch_block_t dismissBlock;

@property (nonatomic, strong) UIImageView *backImageView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, copy) NSString *titleText;// 设置标题
@property (nonatomic, assign) CGFloat titleH ; //  标题栏高度
- (void)show:(UIView *)view;

- (void)show;
- (void)hidden;

/**
 touch事件
 */
- (void)touchOutSide;
//关闭事件可供子类重写
- (void)dismissAlert;


@end
