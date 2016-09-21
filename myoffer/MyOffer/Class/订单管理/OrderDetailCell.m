//
//  OrderDetailTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/22.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#import "OrderDetailCell.h"
@interface OrderDetailCell ()
@property(nonatomic,strong)UILabel *leftLab;
@property(nonatomic,strong)UILabel *righttLab;
@end
@implementation OrderDetailCell
+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    OrderDetailCell *cell =[tableView dequeueReusableCellWithIdentifier:@"orderDetail"];
    
    if (!cell) {
        
        cell =[[OrderDetailCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"orderDetail"];
    }
    
    UIColor *cellColor =  indexPath.row % 2 ?XCOLOR_BG  :  XCOLOR_WHITE;
    cell.contentView.backgroundColor = cellColor;
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.leftLab = [UILabel labelWithFontsize:15 TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        self.leftLab.numberOfLines = 0;
        [self.contentView addSubview:self.leftLab];
        
        self.righttLab = [UILabel labelWithFontsize:15 TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        self.righttLab.numberOfLines = 0;
        [self.contentView addSubview:self.righttLab];
        
    }
    
    return self;
}

-(void)layoutSubviews{
    
    [super layoutSubviews];

    self.leftLab.frame = CGRectMake(10, 0, XScreenWidth  * 0.5 - 10, self.bounds.size.height);
    self.righttLab.frame = CGRectMake( XScreenWidth  * 0.5, 0, XScreenWidth  * 0.5 - 10, self.bounds.size.height);
    
}

-(void)setLeftItem:(OrderServiceItem *)leftItem{
   
    _leftItem = leftItem;
    
    self.leftLab.text = leftItem.name;
    
}


-(void)setRightItem:(OrderServiceItem *)rightItem{
    
    _rightItem = rightItem;
    
    self.righttLab.text = rightItem.name;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
