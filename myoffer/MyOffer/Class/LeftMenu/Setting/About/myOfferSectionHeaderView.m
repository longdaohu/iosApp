//
//  myOfferSectionHeaderView.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/1/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "myOfferSectionHeaderView.h"

@interface myOfferSectionHeaderView()
@property (strong, nonatomic) UIView *bgView;
@property (strong, nonatomic) UIView *panding;
@property (strong, nonatomic) UILabel *titleLab;
@property (strong, nonatomic) UIImageView *arrowView;
//更多按钮
@property (strong, nonatomic) UIButton *moreBtn;

@end

@implementation myOfferSectionHeaderView

static NSString *identify = @"header";

+ (instancetype)headerWithTableView:(UITableView *)tableView{

    myOfferSectionHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:identify];
    if (!header) {
        
        header = [[myOfferSectionHeaderView alloc] initWithReuseIdentifier:identify];
    }
    return header;
}

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithReuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self makeUI];
    }
    
    return self;
}

- (void)makeUI{
    
    self.contentView.clipsToBounds = true;
    self.contentView.backgroundColor = XCOLOR_BG;
    
    UIView *bgView = [UIView new];
    self.bgView = bgView;
    [self.contentView addSubview:bgView];
 
    UIView *panding = [UIView new];
    self.panding = panding;
    panding.backgroundColor = XCOLOR_LIGHTBLUE;
    [bgView addSubview:panding];
    panding.layer.cornerRadius = 2.5;
    panding.layer.masksToBounds = YES;
    
    UILabel *titleLab = [UILabel new];
    self.titleLab = titleLab;
    [bgView addSubview:titleLab];
    titleLab.textColor = XCOLOR_TITLE;
    titleLab.font = [UIFont systemFontOfSize:16];
    
    UIButton *moreBtn =[[UIButton alloc] init];
    self.moreBtn  = moreBtn;
    [moreBtn setTitleColor:XCOLOR_SUBTITLE forState:UIControlStateNormal];
    moreBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    moreBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [moreBtn addTarget:self action:@selector(caseMore) forControlEvents:UIControlEventTouchUpInside];
    [bgView addSubview:moreBtn];
 
    UIImageView *arrowView = [[UIImageView alloc] init];
    self.arrowView = arrowView;
    [bgView addSubview:arrowView];
    arrowView.image = [UIImage imageNamed:@"common_icon_arrow"];

}


- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize contentSize  = self.bounds.size;
    
    CGFloat pand_x = 10;
    CGFloat pand_y = 2;
    CGFloat pand_w = 5;
    CGFloat pand_h = 16;
    self.panding.frame = CGRectMake(pand_x, pand_y, pand_w, pand_h);
    
    CGFloat title_x = CGRectGetMaxX(self.panding.frame) + 5;
    CGFloat title_y = 0;
    CGFloat title_w = self.titleLab.bounds.size.width;
    CGFloat title_h = 20;
    self.titleLab.frame = CGRectMake(title_x, title_y, title_w, title_h);
    
    self.bgView.frame =  CGRectMake(0, 0.5 * (contentSize.height - pand_h), contentSize.width, title_h);
    
    CGFloat arrow_w = 20;
    CGFloat arrow_h = 20;
    CGFloat arrow_x = contentSize.width - arrow_w - pand_x;
    CGFloat arrow_y = 0;
    if(self.group.arrow){
        
        self.arrowView.frame = CGRectMake(arrow_x, arrow_y, arrow_w, arrow_h);
        self.moreBtn.frame = CGRectMake(arrow_x - arrow_w, arrow_y, arrow_w * 2, arrow_h);
    }
    
    if (self.group.more_title.length>0) {
        
        [self.moreBtn sizeToFit];
        CGFloat more_h = pand_h;
        CGFloat more_w = self.moreBtn.bounds.size.width;
        CGFloat tmp =  self.group.arrow ? (arrow_x - more_w) :(contentSize.width - more_w - pand_x);
        CGFloat more_x = tmp;
        CGFloat more_y = 0;
        self.moreBtn.frame = CGRectMake(more_x, more_y, more_w, more_h);
    }
    
    
 
}

- (void)setGroup:(myOfferMenuGroup *)group{
    
    _group = group;
    
    self.titleLab.text = group.title;
    [self.titleLab sizeToFit];
    self.arrowView.hidden = !group.arrow;
    self.moreBtn.hidden = !group.more_title;
    if (group.arrow) {
        self.moreBtn.hidden = !group.arrow;
    }
    if (group.more_title.length>0) {
        [self.moreBtn setTitle:group.more_title forState:UIControlStateNormal];
    }
}

- (void)caseMore{
    
    if (self.myOfferSectionHeaderViewBlock) {
        self.myOfferSectionHeaderViewBlock();
    }
}

@end
