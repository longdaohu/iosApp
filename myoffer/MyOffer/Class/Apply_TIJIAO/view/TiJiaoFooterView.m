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
@property(nonatomic,strong)UIButton *submit;

@end

typedef NS_ENUM(NSInteger,TiJiaoFooterViewButtonType) {

    TiJiaoFooterViewButtonTypeDefault = 0,
    TiJiaoFooterViewButtonTypeDesc,
    TiJiaoFooterViewButtonTypeSubmit
};


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
    selectBtn.tag = TiJiaoFooterViewButtonTypeDefault;
    
    UIButton *descBtn =[[UIButton alloc] init];
    [descBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [descBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    descBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    descBtn.titleLabel.numberOfLines = 0;
    [self addSubview:descBtn];
    self.descBtn = descBtn;
    descBtn.tag = TiJiaoFooterViewButtonTypeDesc;

    
    UIButton *submit =[[UIButton alloc] init];
    [submit setTitle:@"提交审核" forState:UIControlStateNormal];
    [submit setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_RED] forState:UIControlStateNormal];
    [submit setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_Disable] forState:UIControlStateDisabled];
    [submit setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    [submit addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [submit setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
    submit.titleLabel.font = [UIFont systemFontOfSize:14];
    [self addSubview:submit];
    submit.enabled = NO;
    self.submit = submit;
    submit.tag = TiJiaoFooterViewButtonTypeSubmit;
    submit.layer.cornerRadius = CORNER_RADIUS;
    submit.layer.masksToBounds = true;
    
    self.backgroundColor = XCOLOR_WHITE;

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
 
    
    if (sender == self.selectBtn) {
        
        sender.selected    = !sender.selected;
        self.submit.enabled    =  sender.selected;
        
        return;
    }
    
    
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
        
        CGFloat des_X = CGRectGetMaxY(self.selectBtn.frame) + 5;
        CGFloat des_Y = CGRectGetMinY(self.selectBtn.frame);
        CGFloat des_W = contentSize.width - des_X - ITEM_MARGIN;
        
        CGSize titleSize =[self.title boundingRectWithSize:CGSizeMake(des_W, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]} context:nil].size;
        
        CGFloat des_H = titleSize.height;
        
        self.descBtn.frame =CGRectMake(des_X, des_Y, des_W, des_H);
        
        CGFloat sub_Y = des_H + des_Y + 25;

        self.submit.frame = CGRectMake(25, sub_Y, contentSize.width - 50, 50);
        
        self.frame    = CGRectMake(0, 0, contentSize.width, CGRectGetMaxY(self.submit.frame) + 25);
    }
    
   

}

@end

