//
//  TiJiaoFooterView.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "TiJiaoFooterView.h"
@interface TiJiaoFooterView ()

@property(nonatomic,strong)UIButton *selectBtn;
@property(nonatomic,strong)UIButton *descBtn;

@end

@implementation TiJiaoFooterView

+ (instancetype)footerWithContent:(NSString *)content actionBlock:(TiJiaoFooterViewBlock)actionBlock{

    TiJiaoFooterView *footer = [[TiJiaoFooterView alloc] init];
    
    footer.title = content;
    
    footer.actionBlock = actionBlock;
    
    return footer;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self makeUI];
    }
    return self;
}

- (void)makeUI{

    UIButton *selectBtn =[[UIButton alloc] init];
    [selectBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [selectBtn setImage:[UIImage imageNamed:@"check-icons"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"check-icons-yes"] forState:UIControlStateSelected];
    self.selectBtn = selectBtn;
    [self addSubview:selectBtn];
    
    UIButton *descBtn =[[UIButton alloc] init];
    [descBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [descBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    descBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    descBtn.titleLabel.numberOfLines = 0;
    [self addSubview:descBtn];
    self.descBtn = descBtn;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    
    NSRange keyRangne =[title rangeOfString:GDLocalizedString(@"ApplicationProfile-keyword")];
    NSMutableAttributedString *AtributeStr = [[NSMutableAttributedString alloc] initWithString:title];
    [AtributeStr addAttribute:NSForegroundColorAttributeName value:XCOLOR_RED range: keyRangne];
    [AtributeStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:keyRangne];
    [self.descBtn setAttributedTitle: AtributeStr forState:UIControlStateNormal];
    

}


-(void)onClick:(UIButton *)sender{
    
     if (self.actionBlock) {
        
        self.actionBlock(sender);
    }
}


- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat selectX = ITEM_MARGIN;
    CGFloat selectY = ITEM_MARGIN;
    CGFloat selectW = 30;
    CGFloat selectH = 30;
    self.selectBtn.frame = CGRectMake(selectX, selectY, selectW, selectH);
    
    
    if (self.title) {
        
        CGFloat desX = CGRectGetMaxY(self.selectBtn.frame) + 5;
        CGFloat desY = CGRectGetMinY(self.selectBtn.frame);
        CGFloat desW = contentSize.width - desX - ITEM_MARGIN;
        
        CGSize titleSize =[self.title boundingRectWithSize:CGSizeMake(desW, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
        
        self.descBtn.frame =CGRectMake(desX, desY, desW, titleSize.height);
        
        
        self.frame    = CGRectMake(0, 0, contentSize.width, CGRectGetMaxY(self.descBtn.frame) + 50);
    }
    
   

}

@end

