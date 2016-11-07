//
//  TiJiaoFooterView.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "TiJiaoFooterView.h"

@implementation TiJiaoFooterView

+ (instancetype)footerViewWithContent:(NSString *)content{

    TiJiaoFooterView *footer = [[TiJiaoFooterView alloc] init];
    
    footer.title = content;
    
    return footer;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.selectBtn =[[UIButton alloc] init];
        self.selectBtn.tag = 10;
        [self.selectBtn addTarget:self action:@selector(isClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.selectBtn setImage:[UIImage imageNamed:@"check-icons"] forState:UIControlStateNormal];
        [self.selectBtn setImage:[UIImage imageNamed:@"check-icons-yes"] forState:UIControlStateSelected];
        [self addSubview:self.selectBtn];
        
        self.descriptionBtn =[[UIButton alloc] init];
        self.descriptionBtn.tag = 11;
        [self.descriptionBtn addTarget:self action:@selector(isClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.descriptionBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        self.descriptionBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        self.descriptionBtn.titleLabel.numberOfLines = 0;
        [self addSubview:self.descriptionBtn];
        
    }
    return self;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    CGFloat selectX = ITEM_MARGIN;
    CGFloat selectY = ITEM_MARGIN;
    CGFloat selectW = 30;
    CGFloat selectH = 30;
    self.selectBtn.frame = CGRectMake(selectX, selectY, selectW, selectH);
    
    
    CGFloat desX = CGRectGetMaxY(self.selectBtn.frame) + 5;
    CGFloat desY = CGRectGetMinY(self.selectBtn.frame);
    CGFloat desW = XScreenWidth - desX - ITEM_MARGIN;
    
    CGSize titleSize =[title boundingRectWithSize:CGSizeMake(desW, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
  
    self.descriptionBtn.frame =CGRectMake(desX, desY, desW, titleSize.height);
    
    
    NSRange keyRangne =[title rangeOfString:GDLocalizedString(@"ApplicationProfile-keyword")];
    NSMutableAttributedString *AtributeStr = [[NSMutableAttributedString alloc] initWithString:title];
    [AtributeStr addAttribute:NSForegroundColorAttributeName value:XCOLOR_RED range: keyRangne];
    [AtributeStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:keyRangne];
    [self.descriptionBtn setAttributedTitle: AtributeStr forState:UIControlStateNormal];
    
    self.frame    = CGRectMake(0, 0, XScreenWidth, CGRectGetMaxY(self.descriptionBtn.frame) + 50);

}


-(void)isClick:(UIButton *)sender{

    if ([self.delegate respondsToSelector:@selector(TiJiaoFooterView:didClick:)]) {
        
        [self.delegate TiJiaoFooterView:self didClick:sender];
    }
    
}


@end
