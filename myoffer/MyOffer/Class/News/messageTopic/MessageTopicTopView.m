//
//  MessageTopicTopView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/6.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "MessageTopicTopView.h"
#import "messageCatigroySubModel.h"

@interface MessageTopicTopView ()
@property(nonatomic,strong)UIScrollView *topView;
@property(nonatomic,strong)UIView *indicatorView;
@property(nonatomic,strong)UIScrollView *subView;
@property(nonatomic,assign)BOOL refresh;
@property(nonatomic,strong)messageCatigroyModel *catigory_last;

@end


@implementation MessageTopicTopView

+ (instancetype)topViewWithBlock:(topicTopViewBlock)actionBlock{
    
    MessageTopicTopView *topView = [[MessageTopicTopView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 120)];
    
    topView.actionBlock = actionBlock;
    
    return topView;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = XCOLOR_BG;
        
        UIScrollView *topView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, XSCREEN_WIDTH, 60)];
        topView.showsVerticalScrollIndicator = NO;
        topView.showsHorizontalScrollIndicator = NO;
        [self addSubview:topView];
        topView.backgroundColor = [UIColor whiteColor];
        self.topView = topView;
        
        
        UIScrollView *subView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + 15, XSCREEN_WIDTH, 30)];
        subView.showsVerticalScrollIndicator = NO;
        subView.showsHorizontalScrollIndicator = NO;
        [self addSubview:subView];
        self.subView = subView;
        
    }
    return self;
}


- (UIView *)indicatorView{
    
    if (!_indicatorView) {
        
        _indicatorView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 60, 2)];
        _indicatorView.backgroundColor = XCOLOR_LIGHTBLUE;
        
    }
    
    return _indicatorView;
}

- (void)setCatigoryCountry:(messageCatigroyCountryModel *)catigoryCountry{
    
    _catigoryCountry = catigoryCountry;
    
    catigoryCountry.isSelected = YES;
    
    //1 选择国家选项是清空所有的下二级三级选择数据
    for (messageCatigroyModel *catigory in catigoryCountry.subs) {
        catigory.isSelected = NO;
        for (messageCatigroySubModel *sub_catigory in catigory.subs) {
            sub_catigory.isSelected = NO;
        }
    }
    
    //2 清空二级所选参数
    self.catigory_last = nil;
    
    //3 清空二级筛选条件按钮
    [self.topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //4 回到二级筛滚回左侧
    [self.topView setContentOffset:CGPointZero animated:YES];
    
    
    CGFloat top_W = 80;
    CGFloat top_H = self.topView.mj_h;
    CGFloat top_Y = 0;
    //5 创建二级筛选条件按钮
    for (int index = 0; index < catigoryCountry.subs.count; index++) {
        
        messageCatigroyModel *catigory = catigoryCountry.subs[index];
        
        
        UIButton *topBtn = [[UIButton alloc] init];
        topBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        topBtn.frame = CGRectMake(index * top_W, top_Y, top_W, top_H);
        [topBtn setTitle:catigory.name forState:UIControlStateNormal];
        [topBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        [topBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        [self.topView addSubview:topBtn];
        topBtn.tag = index;
        [topBtn addTarget:self action:@selector(catigroyOnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        //5-1 点击国家 > 设置 二级catigroy第一个为默认项
        if (!self.catigory_last) {
            
            self.catigory_last = catigory;
            self.catigory_last.isSelected = YES;
            
        }
        
    }
    //6 设置二级View 的contentSize
    self.topView.contentSize = CGSizeMake(self.topView.subviews.count * top_W, 0);
    
    
    //7 默认第一个按钮点击事件
    if (self.topView.subviews.count > 0) [self catigroyOnclick:(UIButton *)self.topView.subviews.firstObject];
    
}


//点击二级筛选条件
- (void)catigroyOnclick:(UIButton *)sender{
    
    [self topicOnclick:sender refresh:YES];
}

- (void)topicOnclick:(UIButton *)sender refresh:(BOOL)refresh{
    
    self.refresh = refresh;
    
    //1 清空所有二级条件按钮
    for (UIButton *sub_btn in self.topView.subviews) {
        sub_btn.enabled = YES;
    }
    sender.enabled = NO;
    
    //2 设置当前选项
    self.catigory_last = nil;
    self.catigory_last = self.catigoryCountry.subs[sender.tag];
    self.catigory_last.isSelected = YES;
    
    //3 根据当前所选二级条件更改
    [self catigroyOnclikWithCatigory : self.catigory_last];
    
    [self.topView addSubview:self.indicatorView];
//    UIButton *topBtn = self.topView.subviews.firstObject;
    _indicatorView.mj_y = self.topView.mj_h - _indicatorView.mj_h;
    _indicatorView.center = CGPointMake(sender.center.x,  _indicatorView.center.y);
    
}


//根据二级条件更新三级子项条件
- (void)catigroyOnclikWithCatigory:(messageCatigroyModel *)catigory{
    
    //1 清空子项
    [self.subView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    CGFloat sub_W = 80;
    CGFloat sub_H = self.subView.mj_h;
    CGFloat sub_Y = 0;
    CGFloat margin = 10;
    //2 创建三级子项
    for (int index = 0; index < catigory.subs.count + 1; index++) {
        
        UIButton *subBtn = [[UIButton alloc] initWithFrame:CGRectMake( margin + index * (sub_W + margin), sub_Y, sub_W, sub_H)];
        [subBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        [subBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        subBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.subView addSubview:subBtn];
        subBtn.layer.cornerRadius = CORNER_RADIUS;
        subBtn.layer.masksToBounds = YES;
        subBtn.backgroundColor = XCOLOR_WHITE;
        subBtn.layer.borderWidth = 1;
        [subBtn addTarget:self action:@selector(subBtnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        subBtn.tag =  index;
        NSString *title = @"全部";
        
        //2-1 对第一个按钮特殊处理
        if (index != 0) {
            messageCatigroySubModel *catigroy_sub = catigory.subs[index - 1];
            title = catigroy_sub.name;
        }
        [subBtn setTitle:title forState:UIControlStateNormal];
        
    }
    
    //3 设置三级参数 View contentSize
    self.subView.contentSize = CGSizeMake(self.subView.subviews.count* (sub_W + margin), 0);
    
    //4 默认第一个按钮点击事件
    if (self.subviews.count > 0)
    {
      [self subBtnOnclick:(UIButton *)self.subView.subviews.firstObject];
    }
    
    
}



- (void)subBtnOnclick:(UIButton *)sender{
    
    //1 清空subViews所有数据选项
    for (messageCatigroySubModel *catigroy_sub in self.catigory_last.subs) {
        catigroy_sub.isSelected = NO;
    }
    
    //2 清空subViews所有数据选项
    for (UIButton *sub_btn in self.subView.subviews) {
        sub_btn.enabled = YES;
        sub_btn.layer.borderColor = XCOLOR_WHITE.CGColor;
    }
    sender.enabled = NO;
    sender.layer.borderColor = XCOLOR_LIGHTBLUE.CGColor;
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:self.catigoryCountry.code  forKey:@"first"];
    [parameters setValue:self.catigory_last.code  forKey:@"second"];
    [parameters setValue:@(0)  forKey:@"page"];
    
    if (sender.tag != 0) {
        
        messageCatigroySubModel *catigroy_sub =  self.catigory_last.subs[sender.tag - 1];
        catigroy_sub.isSelected = YES;
        [parameters setValue:catigroy_sub.code  forKey:@"third"];
        
        NSLog(@"third  = %@",catigroy_sub.name);
        
    }
    
    
    NSLog(@"second  = %@",self.catigory_last.name);
    NSLog(@"first  = %@",self.catigoryCountry.name);
    
    //self.topView  滚动到对应位置
    NSInteger page = [self.catigoryCountry.subs indexOfObject:self.catigory_last];
    [self topViewScrollSubviewsToIndex:page];
    
    
    if (!self.refresh) return;
    
    if (self.actionBlock) {
        
        self.actionBlock(parameters,page);
        
    }
    
}

//移动UIScrollView到对应位置
- (void)topViewScrollSubviewsToIndex:(NSInteger)index{
    
    UIButton *sender = self.topView.subviews[index];
    
    CGFloat centerX = sender.center.x;
    
    CGFloat move = centerX- self.center.x;
    
    BOOL  isOver = (centerX  + self.center.x - self.topView.contentSize.width) > 0;
    
    CGPoint  po = CGPointZero;
    
    if (isOver) {
        
        po = CGPointMake(self.topView.contentSize.width - self.mj_w, 0);
        
    }else if(sender.center.x < self.center.x){
        
        po = CGPointZero;
        
    }else{
        
        po = CGPointMake(move, 0);
    }
    
    [UIView animateWithDuration:ANIMATION_DUATION animations:^{
        
        _indicatorView.center = CGPointMake(sender.center.x,  _indicatorView.center.y);

    } completion:^(BOOL finished) {
        
        [self.topView setContentOffset:po animated:YES];

    }];
    
 
    
    
    
}


//内容滚动带动主题切换
- (void)superViewSetScrollViewToCatigoryIndex:(NSInteger)page{
    
    UIButton *sender = self.topView.subviews[page];
    
    NSInteger current_page = [self.catigoryCountry.subs indexOfObject:self.catigory_last];
    
    if (current_page == page) return;
    
    [self topicOnclick:sender refresh:YES];
    
}

/**
 计算字符串长度
 
 @param string string
 @param font font
 @return 字符串长度
 */
- (CGFloat)getWidthWithString:(NSString *)string font:(UIFont *)font {
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [string boundingRectWithSize:CGSizeMake(0, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size.width;
}


@end





