//
//  HomeFirstTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "HomeFirstTableViewCell.h"

@interface HomeFirstTableViewCell ()
@property(nonatomic,strong)UIImageView *IconView;

@end

@implementation HomeFirstTableViewCell
+(instancetype)cellInitWithTableView:(UITableView *)tableView
{
 
    static NSString *Identifier = @"first";
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
        
        self.IconView                     = [[UIImageView alloc] init];
        self.IconView.layer.cornerRadius  = 5;
        self.IconView.layer.masksToBounds = YES;
        self.IconView.contentMode         = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:self.IconView];
        self.contentView.backgroundColor  = XCOLOR_BG;
        
    }
    return self;
}


-(void)setItemInfo:(NSDictionary *)itemInfo
{
    _itemInfo = itemInfo;
    
    NSString *iconStr = [itemInfo[@"image"]  stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self.IconView sd_setImageWithURL:[NSURL URLWithString:iconStr] placeholderImage:[UIImage imageNamed:@"PlaceHolderImage"]];
    
}


-(void)layoutSubviews{
    
    [super layoutSubviews];
    
    CGFloat iconX = ITEM_MARGIN;
    CGFloat iconY = ITEM_MARGIN;
    CGFloat iconW = XScreenWidth - 2 * iconX;
    CGFloat iconH = self.bounds.size.height - iconY;
    self.IconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
}



@end
