//
//  TKListView.h
//  EduClass
//
//  Created by lyy on 2018/4/23.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TKListView : UIView

- (id)initWithFrame:(CGRect)frame andTitle:(NSString *)title from:(NSString *)from;

- (void)show:(UIView *)view;
- (void)hidden;
- (void)dismissAlert;

@property (nonatomic, copy) dispatch_block_t dismissBlock;

@end

