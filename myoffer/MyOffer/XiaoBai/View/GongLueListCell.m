//
//  GongLueListCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "GongLueListCell.h"

@interface GongLueListCell ()
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *subTitleLab;
@property(nonatomic,strong)UIImageView *line;


@end
@implementation GongLueListCell
static NSString *identity = @"gonglueList";
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    GongLueListCell *cell =[tableView dequeueReusableCellWithIdentifier:identity];
    
    if (!cell) {
        
        cell =[[GongLueListCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier:identity];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle: style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
         
        self.logoView               = [[UIImageView alloc] init];
        self.logoView.clipsToBounds = YES;
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
    
    return self;
    
}


-(void)setItem:(NSDictionary *)item{

    _item = item;
    
    [self.logoView sd_setImageWithURL:[NSURL URLWithString:item[@"logo"]] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
    self.titleLab.text    = item[@"title"];
    
    self.subTitleLab.text = item[@"description"];
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGFloat logox = KDUtilSize(10);
    CGFloat logoy = ITEM_MARGIN;
    CGFloat logoh = self.contentView.bounds.size.height - 2 * logoy;
    CGFloat logow = logoh;
    self.logoView.frame = CGRectMake(logox, logoy, logow, logoh);
    
    CGFloat lineX = CGRectGetMaxX(self.logoView.frame);
    CGFloat lineY = self.contentView.bounds.size.height -0.4;
    CGFloat lineW = self.contentView.bounds.size.width;
    CGFloat lineH = 0.4;
    self.line.frame = CGRectMake(lineX, lineY, lineW, lineH);
    
    if (self.titleLab.text || self.subTitleLab.text) {
        
        CGFloat titlex      = CGRectGetMaxX(self.logoView.frame) + ITEM_MARGIN;
        CGFloat titlew      = XScreenWidth - titlex;
        CGSize titleSize    = [self getContentBoundWithTitle:self.titleLab.text andFontSize:KDUtilSize(18)  andMaxWidth:titlew];
        CGFloat titley      = logoy;
        self.titleLab.frame = CGRectMake(titlex, titley, titlew, titleSize.height);
        
        CGFloat subw           = titlew - 20;
        CGSize subTitleSize    = [self getContentBoundWithTitle:self.subTitleLab.text andFontSize:KDUtilSize(13)  andMaxWidth:subw];
        CGFloat subx           = titlex;
        CGFloat suby           = CGRectGetMaxY(self.titleLab.frame) + KDUtilSize(10);
        CGFloat subh           = subTitleSize.height;
        self.subTitleLab.frame = CGRectMake(subx, suby, subw, subh);
        
    }
    
    
}

-(CGSize)getContentBoundWithTitle:(NSString *)title  andFontSize:(CGFloat)size andMaxWidth:(CGFloat)width{
    
    return [title boundingRectWithSize:CGSizeMake(width, 999) options:NSStringDrawingUsesLineFragmentOrigin  attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:size]} context:nil].size;
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
