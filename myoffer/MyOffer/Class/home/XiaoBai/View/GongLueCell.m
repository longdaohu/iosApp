//
//  GongLueListCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "GongLueCell.h"

@interface GongLueCell ()
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UILabel     *titleLab;
@property(nonatomic,strong)UILabel     *subTitleLab;
@property(nonatomic,strong)UIImageView *line;


@end
@implementation GongLueCell
static NSString *identity = @"gonglueList";
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    GongLueCell *cell =[tableView dequeueReusableCellWithIdentifier:identity];
    
    if (!cell) {
        
        cell =[[GongLueCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         
        [self makeUI];
    }
    
    return self;
    
}

- (void)makeUI{

    self.logoView               = [[UIImageView alloc] init];
    self.logoView.contentMode   = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:self.logoView];
    
    self.line                  = [[UIImageView alloc] init];
    self.line.image            = [UIImage imageNamed:@"Black_spot"];
    self.line.contentMode      = UIViewContentModeScaleToFill;
    self.line.clipsToBounds    = YES;
    self.line.alpha = 0.2;
    [self.contentView addSubview:self.line];
    
    self.titleLab = [UILabel labelWithFontsize:KDUtilSize(18)  TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
    [self.contentView addSubview:self.titleLab];
    
    self.subTitleLab = [UILabel labelWithFontsize:KDUtilSize(13)  TextColor:XCOLOR_DARKGRAY TextAlignment:NSTextAlignmentLeft];
    self.subTitleLab.numberOfLines = 0;
    [self.contentView addSubview:self.subTitleLab];
 
}


-(void)setItem:(MyOfferArticle *)item{

    _item = item;
    
    
    self.titleLab.text    = item.title;
    self.subTitleLab.text = item.desc;
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:item.logo] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGSize contentSize = self.contentView.bounds.size;
    
    CGFloat logox = ITEM_MARGIN;
    CGFloat logoy = ITEM_MARGIN;
    CGFloat logoh = contentSize.height - 2 * logoy;
    CGFloat logow = logoh;
    self.logoView.frame = CGRectMake(logox, logoy, logow, logoh);
    
    CGFloat lineX = CGRectGetMaxX(self.logoView.frame);
    CGFloat lineY = contentSize.height -0.4;
    CGFloat lineW = contentSize.width;
    CGFloat lineH = 0.4;
    self.line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    
    if (self.titleLab.text || self.subTitleLab.text) {
        
        CGFloat titlex      = CGRectGetMaxX(self.logoView.frame) + ITEM_MARGIN;
        CGFloat titlew      = XSCREEN_WIDTH - titlex;
        CGSize titleSize    = [self.titleLab.text  KD_sizeWithAttributeFont:XFONT(KDUtilSize(18)) maxWidth:titlew];
        CGFloat titley      = logoy;
        self.titleLab.frame = CGRectMake(titlex, titley, titlew, titleSize.height);
        
        CGFloat subw           = titlew - 25;
        CGSize  subTitleSize   = [self.subTitleLab.text  KD_sizeWithAttributeFont:XFONT(KDUtilSize(13)) maxWidth:subw];
        CGFloat subx           = titlex;
        CGFloat suby           = CGRectGetMaxY(self.titleLab.frame) + ITEM_MARGIN;
        CGFloat subh           = subTitleSize.height;
        self.subTitleLab.frame = CGRectMake(subx, suby, subw, subh);
        
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state

}

@end
