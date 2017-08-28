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

+ (instancetype)footerWithContent:(TJFooterFrame *)footerFrame actionBlock:(TiJiaoFooterViewBlock)actionBlock{

    TiJiaoFooterView *footer = [[TiJiaoFooterView alloc] init];
    
    footer.footerFrame = footerFrame;
    
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



- (void)setFooterFrame:(TJFooterFrame *)footerFrame{

    _footerFrame = footerFrame;
    
    NSRange keyRangne =[footerFrame.footer_title rangeOfString:GDLocalizedString(@"ApplicationProfile-keyword")];
    NSMutableAttributedString *AtributeStr = [[NSMutableAttributedString alloc] initWithString:footerFrame.footer_title];
    [AtributeStr addAttribute:NSForegroundColorAttributeName value:XCOLOR_RED range: keyRangne];
    [AtributeStr addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:keyRangne];
    [self.descBtn setAttributedTitle: AtributeStr forState:UIControlStateNormal];

  
    self.selectBtn.frame = footerFrame.select_frame;
    self.descBtn.frame = footerFrame.title_frame;
    self.submit.frame  = footerFrame.sbm_frame;
    
    self.frame = footerFrame.footer_frame;
    
    
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




@end

