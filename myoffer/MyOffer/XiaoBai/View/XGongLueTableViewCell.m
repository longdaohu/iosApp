//
//  XGongLueTableViewCell.m
//  XUObject
//
//  Created by xuewuguojie on 16/4/19.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import "XGongLueTableViewCell.h"
@interface XGongLueTableViewCell ()
@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *subtitleLab;

@end

@implementation XGongLueTableViewCell

static NSString *identity = @"gonglue";
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    XGongLueTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:identity];
    
    if (!cell) {
        
        cell =[[XGongLueTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = BACKGROUDCOLOR;
        
        self.bgView =[[UIView alloc] init];
        self.bgView.backgroundColor = [UIColor whiteColor];
        self.bgView.layer.cornerRadius = 5;
        self.bgView.layer.shadowColor =[UIColor blackColor].CGColor;
        self.bgView.layer.shadowOpacity = 0.1;
        self.bgView.layer.shadowOffset = CGSizeMake(0, 1);
        [self.contentView addSubview:self.bgView];
        
        
        self.logoView =[[UIImageView alloc] init];
        self.logoView.clipsToBounds = YES;
        self.logoView.contentMode = UIViewContentModeScaleAspectFit;
        [self.bgView addSubview:self.logoView];
        
        
        self.titleLab = [UILabel labelWithFontsize:KDUtilSize(18)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentRight];
        [self.bgView addSubview:self.titleLab];
        
        
        self.subtitleLab = [UILabel labelWithFontsize:KDUtilSize(13)  TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentRight];
        [self.bgView addSubview:self.subtitleLab];
        
    }
    
    return self;

}


-(void)setItem:(NSDictionary *)item
{
    _item = item;
    
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:item[@"logo"]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];

    self.titleLab.text = item[@"title"];

    self.subtitleLab.text =item[@"description"];
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat bgx = KDUtilSize(8);
    CGFloat bgy = 2;
    CGFloat bgw = XScreenWidth - bgx * 2;
    CGFloat bgh = FLOWLAYOUT_SubW;
    self.bgView.frame = CGRectMake(bgx, bgy, bgw, bgh);
    
    
    CGFloat logox = KDUtilSize(5);
    CGFloat logoy = logox;
    CGFloat logow =  70 + KDUtilSize(0)*3;
    CGFloat logoh =  bgh - logoy *2;
    self.logoView.frame = CGRectMake(logox, logoy, logow, logoh);
    
    
    if (self.titleLab.text || self.subtitleLab.text) {
     
        CGFloat titlex = CGRectGetMaxX(self.logoView.frame);
        CGFloat titlew = bgw - titlex - 10;
        
        CGSize titleSize =[self.titleLab.text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:KDUtilSize(18)]];   //[self getContentBoundWithTitle:self.titleLab.text andFontSize:KDUtilSize(18)  andMaxWidth:titlew];
        CGSize subTitleSize = [self.subtitleLab.text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:KDUtilSize(13)]]; //[self getContentBoundWithTitle:self.subtitleLab.text andFontSize:KDUtilSize(13)  andMaxWidth:titlew];
       
        CGFloat titley = 0.5 * (bgh  - titleSize.height - subTitleSize.height - KDUtilSize(10));

        self.titleLab.frame = CGRectMake(titlex, titley, titlew, titleSize.height);
        
        
        CGFloat subx = titlex;
        CGFloat suby = CGRectGetMaxY(self.titleLab.frame) + KDUtilSize(10);
        CGFloat subw = titlew;
        CGFloat subh = subTitleSize.height;
        self.subtitleLab.frame = CGRectMake(subx, suby, subw, subh);

    }
 
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
    
    
    self.backgroundColor =[UIColor redColor];

    
}

@end
