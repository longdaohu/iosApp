//
//  MessageTopicView.m
//  MYOFFERDEMO
//
//  Created by xuewuguojie on 2017/7/10.
//  Copyright © 2017年 xuewuguojie. All rights reserved.
//

#import "MessageTopicView.h"
#import "messageCatigroyModel.h"

@interface MessageTopicView ()

@property(nonatomic,strong)UIScrollView *bgView;
@property(nonatomic,strong)UIButton *btn_current;
@property(nonatomic,strong)UIView *bottom_line;
@property(nonatomic,strong)UIView *focusView;
@end

@implementation MessageTopicView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_WHITE;
        
        UIScrollView *bgView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        self.bgView = bgView;
        [self addSubview:bgView];
        
        UIView *line = [[UIView alloc] init];
        [self addSubview:line];
        self.bottom_line = line;
        self.bottom_line.backgroundColor = XCOLOR_line;
        
        
//        UIView *focusView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 2)];
//        [self addSubview:focusView];
//        self.focusView = focusView;
//        self.focusView.backgroundColor = XCOLOR_LIGHTBLUE;
        
        
    }
    return self;
}

- (void)setCatigories:(NSArray *)catigories{
    
    _catigories = catigories;
    
    [self.bgView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    CGFloat tag_w = 100;
    CGFloat tag_h = self.bgView.mj_h;
    CGFloat tag_y = 0;
    for (NSInteger index = 0 ; index < catigories.count; index++) {

        messageCatigroyModel *topic  = catigories[index];
        
        UIButton *tagBtn = [[UIButton alloc] initWithFrame:CGRectMake(index * tag_w, tag_y, tag_w, tag_h)];
        [tagBtn setTitle:topic.name forState:UIControlStateNormal];
        [tagBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        [tagBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        [self.bgView addSubview:tagBtn];
        [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        tagBtn.tag = index;
        
        if (!self.btn_current) {
            
            self.btn_current = tagBtn;
            self.btn_current.enabled = NO;
            
        }
        
    }

    self.bgView.contentSize = CGSizeMake(tag_w * self.bgView.subviews.count, 0);
    
}


- (void)tagBtnClick:(UIButton *)sender{

    //1 切换当前选择项按钮
    self.btn_current.enabled = YES;
    
    sender.enabled = NO;
    
    self.btn_current = sender;
    
    //2 传出当前选择项
    if (self.actionBlock) {
        
        messageCatigroyModel *topic  = self.catigories[sender.tag];
        
        self.actionBlock(topic.code,sender.tag);
    }
    
    //3 按钮滚动到对页位置
    [self catigoryBtnClick:self.btn_current];

}

//移动UIScrollView到对应位置
- (void)secrollToCatigoryIndex:(NSInteger)index{
    
    //1 确认当前选择项按钮
    UIButton *sender = self.bgView.subviews[index];
    
    self.btn_current.enabled = YES;
    
    sender.enabled = NO;
    
    self.btn_current = sender;
  
    //2 滚动到当前选择项按钮
    [self catigoryBtnClick:sender];
    
}

//移动UIScrollView到对应位置
- (void)catigoryBtnClick:(UIButton *)sender{
    
//    CGFloat center = 0.5 * (self.bgView.mj_w - sender.mj_w);
//    
//    if (center > sender.mj_x) return;
//    
//    CGFloat distance =  sender.mj_x - center;
//    
//    [self.bgView setContentOffset:CGPointMake(distance, 0) animated:YES];
 
    if ((self.bgView.contentSize.width -  (sender.tag - 1) * sender.mj_w) > self.bgView.mj_w) {
        
        [self.bgView setContentOffset:CGPointMake(sender.tag * sender.mj_w, 0) animated:YES];
        
    }
    
}


- (void)superViewScrollViewDidScrollContentOffset:(CGPoint)offset{

    
}



- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat  bt_line_y =  contentSize.height - LINE_HEIGHT;
    CGFloat  bt_line_w =  contentSize.width;
    CGFloat  bt_line_h =  LINE_HEIGHT;
    self.bottom_line.frame = CGRectMake(0, bt_line_y, bt_line_w, bt_line_h);
    
//    self.focusView.mj_y = contentSize.height - self.focusView.mj_h;

}

@end
