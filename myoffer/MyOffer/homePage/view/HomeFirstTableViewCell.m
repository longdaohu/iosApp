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
        
        self.contentView.backgroundColor  = BACKGROUDCOLOR;
        
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
    
    CGFloat ix = ITEM_MARGIN;
    CGFloat iy = ITEM_MARGIN;
    CGFloat iw = XScreenWidth - 2*ix;
    CGFloat ih = self.bounds.size.height - iy;
    self.IconView.frame = CGRectMake(ix, iy, iw, ih);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
}



@end
