//
//  HomeFirstTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "HomeFirstTableViewCell.h"

@interface HomeFirstTableViewCell ()
@property(nonatomic,strong)UIImageView *iconView;

@end

@implementation HomeFirstTableViewCell
+(instancetype)cellInitWithTableView:(UITableView *)tableView
{
 
    static NSString *Identifier = @"home_first";
    HomeFirstTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:Identifier];
    if (!cell) {
        cell =[[HomeFirstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconView   = [[UIImageView alloc] init];
        self.iconView.contentMode  = UIViewContentModeScaleAspectFill;
        self.iconView.clipsToBounds = YES;
        [self.contentView addSubview:self.iconView];
        
        self.contentView.backgroundColor = XCOLOR_BG;
    }
    return self;
}


-(void)setItemInfo:(NSDictionary *)itemInfo
{
    _itemInfo = itemInfo;
    
    NSURL *iconUrl = [itemInfo[@"image"]  mj_url];

    NSString *path = [iconUrl.absoluteString containsString:@"http"] ? iconUrl.absoluteString : [NSString stringWithFormat:@"%@%@",DOMAINURL,iconUrl.absoluteString];

    [self.iconView sd_setImageWithURL:[NSURL URLWithString:path]];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;

    CGFloat iconX = ITEM_MARGIN;
    CGFloat iconY = 0;
    CGFloat iconW = contentSize.width - 2 * iconX;
    CGFloat iconH = contentSize.height - ITEM_MARGIN;
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];
 
}



@end
