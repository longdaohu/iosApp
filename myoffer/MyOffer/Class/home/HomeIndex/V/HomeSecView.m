//
//  HomeSecView.m
//  newOffer
//
//  Created by xuewuguojie on 2018/6/4.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import "HomeSecView.h"

@interface HomeSecView ()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *subLab;
@property(nonatomic,strong)UIButton *accesoryBtn;

@end

@implementation HomeSecView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeSubView];
    }
    return self;
}

- (void)makeSubView{
 
    self.backgroundColor = XCOLOR_WHITE;
    self.clipsToBounds =YES;
    
    UILabel *titleLab = [UILabel new];
    titleLab.font = [UIFont boldSystemFontOfSize:20];
    titleLab.textColor =  XCOLOR_BLACK;
    [self addSubview:titleLab];
    self.titleLab = titleLab;
    
    UIButton *accesoryBtn = [UIButton new];
    accesoryBtn.titleLabel.font = XFONT(12);
    [accesoryBtn setTitleColor:XCOLOR(162, 162, 162, 1) forState:UIControlStateNormal];
    [self addSubview:accesoryBtn];
    self.accesoryBtn = accesoryBtn;
    [accesoryBtn addTarget:self action:@selector(caseMore) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)setGroup:(myofferGroupModel *)group{
    _group = group;
    
    self.titleLab.text = group.header_title;
    [self.accesoryBtn setTitle:group.accesory_title forState:UIControlStateNormal];
    
}

- (void)caseMore{
    if (self.actionBlock) {
        self.actionBlock(self.group.type);
    }
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
 
    switch (self.group.type) {
        case SectionGroupTypeApplyDestination:
        {
            if (CGRectEqualToRect(self.titleLab.frame, CGRectZero)) {
                
                CGFloat title_x = self.leftMargin > 0 ? self.leftMargin:14;
                CGFloat title_w = contentSize.width;
                CGFloat title_h = self.titleLab.font.lineHeight;

                CGFloat acc_w = contentSize.width;
                CGFloat acc_x = title_x;
                CGFloat acc_h = self.accesoryBtn.titleLabel.font.lineHeight;
                
                CGFloat title_y = (contentSize.height - title_h - acc_h - 2) * 0.5;
                self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
                
                CGFloat acc_y = title_y + title_h + 2;
                self.accesoryBtn.frame = CGRectMake(acc_x, acc_y, acc_w, acc_h);
                self.accesoryBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            }
        }
            break;
        default:{
            
            if (CGRectEqualToRect(self.titleLab.frame, CGRectZero)) {
                
                CGFloat title_x = self.leftMargin > 0 ? self.leftMargin:14;
                CGFloat title_w = contentSize.width;
                CGFloat title_h = self.titleLab.font.lineHeight;
                CGFloat title_y = self.titleInMiddle?   (contentSize.height - title_h) * 0.5 : (contentSize.height - title_h - 10);
                self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
                
                if (self.accesoryBtn.currentTitle.length > 0 ) {
                    CGSize accesory_size =  [self.accesoryBtn.currentTitle stringWithfontSize:12];
                    CGFloat acc_w = accesory_size.width;
                    CGFloat acc_x =  contentSize.width - title_x - acc_w;
                    CGFloat acc_h = accesory_size.height + 10;
                    CGFloat acc_y = contentSize.height - acc_h - 10;
                    self.accesoryBtn.frame = CGRectMake(acc_x, acc_y, acc_w, acc_h);
                }
                
            }
        }
            break;
    }
    
    if (self.group.items.count == 0 && self.group.type != SectionGroupTypeA) {
        self.mj_h = 0;
    }
 
}

@end

