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
@property(nonatomic,strong)UIScrollView *subView;
@property(nonatomic,strong)messageCatigroyModel *catigory_last;
@property(nonatomic,strong)UIView *line;

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
        [self addSubview:topView];
        topView.backgroundColor = [UIColor whiteColor];
        self.topView = topView;
        
        
        UIScrollView *subView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(topView.frame) + 15, XSCREEN_WIDTH, 30)];
        [self addSubview:subView];
        self.subView = subView;
        
    }
    return self;
}


- (void)setCatigoryCountry:(messageCatigroyCountryModel *)catigoryCountry{

    _catigoryCountry = catigoryCountry;
    
    //选择国家选项是清空所有的下二级三级选择数据
    for (messageCatigroyModel *catigory in catigoryCountry.subs) {
        
        catigory.isSelected = NO;
        
        for (messageCatigroySubModel *sub_catigory in catigory.subs) {
            
            sub_catigory.isSelected = NO;
         }
        
    }
    
    //清空二级所选参数
    self.catigory_last = nil;
    
    //清空二级筛选条件按钮
    [self.topView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    //回到滚回左侧
    [self.topView setContentOffset:CGPointZero animated:YES];
    
    
    
    
    CGFloat top_W = 100;
    CGFloat top_H = self.topView.mj_h;
    CGFloat top_Y = 0;
    //创建二级筛选条件按钮
    for (int index = 0; index < catigoryCountry.subs.count; index++) {
        
        messageCatigroyModel *catigory = catigoryCountry.subs[index];
        catigory.isSelected = (index == 0);
        
        UIButton *topBtn = [[UIButton alloc] initWithFrame:CGRectMake(index * top_W, top_Y, top_W, top_H)];
        [topBtn setTitle:catigory.name forState:UIControlStateNormal];
        [topBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        [topBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        topBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.topView addSubview:topBtn];
        topBtn.tag = index;
        
        [topBtn addTarget:self action:@selector(catigroyOnclik:) forControlEvents:UIControlEventTouchUpInside];
        
        if (catigory.isSelected) self.catigory_last = catigory;
        
     }
    
    
    self.topView.contentSize = CGSizeMake(self.topView.subviews.count * top_W, 0);

    //默认第一个按钮点击事件
    if (self.subView.subviews.count > 0) [self catigroyOnclik:(UIButton *)self.topView.subviews.firstObject];
    
}


//点击二级筛选条件
- (void)catigroyOnclik:(UIButton *)sender{
    
    //清空所有二级条件按钮
    for (UIButton *sub_btn in self.topView.subviews) {
        
        sub_btn.enabled = YES;
        
    }
    sender.enabled = NO;
    
    self.catigory_last = self.catigoryCountry.subs[sender.tag];
    
    //根据当前所选二级条件更改
    [self catigroyOnclikWithCatigory : self.catigory_last];
   
}


//根据二级条件更新三级子项条件
- (void)catigroyOnclikWithCatigory:(messageCatigroyModel *)catigory{
    
     //清空子项
    [self.subView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    CGFloat sub_W = 80;
    CGFloat sub_H = self.subView.mj_h;
    CGFloat sub_Y = 0;
    CGFloat margin = 10;
    //创建三级子项
    for (int index = 0; index < catigory.subs.count + 1; index++) {
        
        UIButton *subBtn = [[UIButton alloc] initWithFrame:CGRectMake( margin + index * (sub_W + margin), sub_Y, sub_W, sub_H)];
        [subBtn setTitleColor:XCOLOR_LIGHTBLUE forState:UIControlStateDisabled];
        [subBtn setTitleColor:XCOLOR_TITLE forState:UIControlStateNormal];
        subBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [self.subView addSubview:subBtn];
        subBtn.layer.cornerRadius = CORNER_RADIUS;
        subBtn.layer.masksToBounds = YES;
        subBtn.backgroundColor = XCOLOR_WHITE;
        subBtn.layer.borderWidth = 1;
        
        [subBtn addTarget:self action:@selector(subBtnOnclick:) forControlEvents:UIControlEventTouchUpInside];
        
        
        NSString *title = @"全部";
        
        if (index != 0) {
            
            messageCatigroySubModel *catigroy_sub = catigory.subs[index - 1];
            
            title = catigroy_sub.name;
            
            subBtn.tag = (index - 1);
            
        }else{
            
            subBtn.tag = DEFAULT_NUMBER;
        }
        
        [subBtn setTitle:title forState:UIControlStateNormal];
        
    }
    
    self.subView.contentSize = CGSizeMake(self.subView.subviews.count* (sub_W + margin), 0);
    
    //默认第一个按钮点击事件
    if (self.subviews.count > 0)   [self subBtnOnclick:(UIButton *)self.subView.subviews.firstObject];
    
}



- (void)subBtnOnclick:(UIButton *)sender{
    
    //清空subViews所有数据选项
    for (messageCatigroySubModel *catigroy_sub in self.catigory_last.subs) {
      
        catigroy_sub.isSelected = NO;
        
    }
    
    
    //清空subViews所有数据选项
    for (UIButton *sub_btn in self.subView.subviews) {
        
        sub_btn.enabled = YES;
        sub_btn.layer.borderColor = XCOLOR_WHITE.CGColor;
        
    }
    
    sender.enabled = NO;
    sender.layer.borderColor = XCOLOR_LIGHTBLUE.CGColor;
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setValue:@DEFAULT_NUMBER  forKey:@"page"];
    [parameters setValue:self.catigoryCountry.code  forKey:@"first"];
    [parameters setValue:self.catigory_last.code  forKey:@"second"];
    
    if (sender.tag == DEFAULT_NUMBER) {
  
       
    }else{
 
        messageCatigroySubModel *catigroy_sub =  self.catigory_last.subs[sender.tag];
        catigroy_sub.isSelected = YES;
        [parameters setValue:catigroy_sub.code  forKey:@"third"];
        NSLog(@"third  = %@",catigroy_sub.name);
        
    }
    
    NSLog(@"second  = %@",self.catigory_last.name);
    NSLog(@"first  = %@",self.catigoryCountry.name);

    
    if (self.actionBlock) {
        
        NSInteger page = [self.catigoryCountry.subs indexOfObject:self.catigory_last];
        
         self.actionBlock(parameters,page);
        
        //self.topView  滚动到对应位置
        [self scrollToIndex:page];
        
     }
}


- (void)scrollToCatigoryIndex:(NSInteger)page{
    
    UIButton *sender = self.topView.subviews[page];
    
    [self catigroyOnclik:sender];
    
}


//移动UIScrollView到对应位置
- (void)scrollToIndex:(NSInteger)index{
    
    UIButton *sender = self.topView.subviews[index];
    
    if ((self.topView.contentSize.width -  (sender.tag - 1) * sender.mj_w) > self.topView.mj_w) {

        [self.topView setContentOffset:CGPointMake(sender.tag * sender.mj_w, 0) animated:YES];
    }
    
}


@end



 

