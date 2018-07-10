//
//  IntroCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/28.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "IntroCell.h"

@interface IntroCell ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *subLab;
@property(nonatomic,strong)UIButton *closeBtn;

@end
@implementation IntroCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIImageView *iconView = [UIImageView new];
        iconView.contentMode = UIViewContentModeScaleToFill;
        self.iconView = iconView;
        [self.contentView addSubview:iconView];
        
        
        UILabel *titleLab = [UILabel new];
        titleLab.font = XFONT(20);
        titleLab.textAlignment = NSTextAlignmentCenter;
        titleLab.textColor = XCOLOR(63, 63, 63, 1);
        titleLab.numberOfLines = 0;
        self.titleLab = titleLab;
        [self.contentView addSubview:titleLab];
        
        UILabel *subLab = [UILabel new];
        subLab.font = XFONT(16);
        subLab.numberOfLines = 0;
        subLab.textColor = XCOLOR(128, 128, 128, 1);
        self.subLab = subLab;
        [self.contentView addSubview:subLab];
        
        UIButton *itemBtn = [UIButton new];
        self.closeBtn = itemBtn;
        [itemBtn setTitle:@"开启留学之旅3.0" forState:UIControlStateNormal];
        itemBtn.backgroundColor = XCOLOR_LIGHTBLUE;
        itemBtn.layer.cornerRadius = CORNER_RADIUS;
        itemBtn.titleLabel.font = XFONT(14);
        [itemBtn setTitleColor:XCOLOR_WHITE forState:UIControlStateNormal];
        [self.contentView addSubview:itemBtn];
        [itemBtn addTarget:self action:@selector(click) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}


- (void)setItem:(NSDictionary *)item{
    
    _item = item;
    [self.iconView setImage:XImage(item[@"icon"])];
    self.titleLab.text = item[@"title"];
    
    NSString *summary =  item[@"summary"];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:summary];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 10.0;
    NSDictionary *dic  = @{NSParagraphStyleAttributeName:paragraphStyle,NSKernAttributeName:@3};
    [attribute addAttributes:dic range:NSMakeRange(0, summary.length)];
    self.subLab.attributedText = attribute;
    self.subLab.textAlignment = NSTextAlignmentCenter;
    self.closeBtn.hidden = ![self.titleLab.text isEqualToString:@"移民签证"];
    
}

- (void)click{

    if (self.acitonBlock) {
        self.acitonBlock();
    }
}
- (void)layoutSubviews{
    
    [super layoutSubviews];
 
    
    CGFloat icon_w =  IsIphoneMiniScreen ? XSCREEN_WIDTH * 0.65 : XSCREEN_WIDTH * 0.8;
    CGFloat icon_h =   icon_w * 1296.0/1038;
    CGFloat icon_x =   (XSCREEN_WIDTH - icon_w) * 0.5;
    CGFloat icon_y =   0;
    
    CGFloat title_w =   XSCREEN_WIDTH ;
    CGFloat title_x =   0;
    CGFloat title_y =   icon_h + icon_y + 10;
    CGFloat title_h =   30;
    
    CGFloat sub_w =   XSCREEN_WIDTH;
    CGFloat sub_x =   0;
    CGFloat sub_y =   title_y + title_h + 10;
    CGFloat sub_h =   60;
    
    CGFloat  margin = self.bounds.size.height  - (icon_h + title_h + sub_h);
    icon_y = margin * 0.4;
    title_y =  icon_h + icon_y + 10;
    sub_y =   title_y + title_h + 10;
    self.titleLab.frame = CGRectMake(title_x, title_y, title_w,title_h);
    self.iconView.frame = CGRectMake(icon_x, icon_y, icon_w,icon_h);
    self.subLab.frame = CGRectMake(sub_x, sub_y, sub_w,sub_h);
    
    
    CGFloat item_h = 50;
    CGFloat item_y = CGRectGetMaxY(self.subLab.frame) + 20;
    if (IsIphoneMiniScreen) {
        CGFloat margin = (XSCREEN_HEIGHT - CGRectGetMaxY(self.subLab.frame) - item_h);
        item_y = CGRectGetMaxY(self.subLab.frame) + margin * 0.5;
    }
    CGFloat item_w = 160;
    CGFloat item_x = (self.bounds.size.width - item_w) * 0.5;
    self.closeBtn.frame = CGRectMake(item_x, item_y, item_w, item_h);
    
}


@end
