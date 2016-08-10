//
//  ApplyTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/5/9.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "ApplyTableViewCell.h"

@interface ApplyTableViewCell ()
//@property(nonatomic,strong)UIImageView *accessoryView;
@property(nonatomic,strong)UILabel *titleLab;
@end

@implementation ApplyTableViewCell


+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    ApplyTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"apply"];
    if (!cell) {
        
        cell =[[ApplyTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"apply"];
      
        cell.accessoryView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        [(UIImageView *)cell.accessoryView setContentMode:UIViewContentModeCenter];
    }
    return cell;
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self =[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.iconView =[[UIImageView alloc] init];
        self.iconView.contentMode = UIViewContentModeCenter;
        [self.contentView addSubview:self.iconView];
 
        self.titleLab =[UILabel labelWithFontsize:KDUtilSize(UNIVERISITYTITLEFONT) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
        self.titleLab.numberOfLines = 2;
        [self.contentView addSubview:self.titleLab];
        
        
    }
    
    return self;
}

-(void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLab.text = title;
}


-(void)setEdit:(BOOL)Edit
{
    _Edit = Edit;
    
    if (!Edit) {
        
        self.iconView.image = nil;
    }

}


-(void)setContaint:(BOOL)containt
{
    _containt = containt;
    
    if (self.Edit) {
        
        [(UIImageView *)self.accessoryView setImage:nil];
        NSString *iconName =self.containt ? @"check-icons-yes": @"check-icons";
        self.iconView.image = [UIImage imageNamed:iconName];
    }
}

-(void)setContaint_select:(BOOL)containt_select
{
    _containt_select = containt_select;
    
    NSString *imageName = containt_select ? @"check-icons-yes": @"check-icons";

    [(UIImageView *)self.accessoryView setImage:[UIImage imageNamed:imageName]];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat iconX = ITEM_MARGIN;
    CGFloat iconY = 0;
    CGFloat iconW = self.Edit ? 34 : 0;
    CGFloat iconH = self.contentView.bounds.size.height;
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);
    
    
    CGFloat titleX = CGRectGetMaxX(self.iconView.frame) + 5;
    CGFloat titleY = iconY;
    CGFloat titleW = self.Edit ? XScreenWidth - titleX : XScreenWidth - titleX - 44;
    CGFloat titleH = iconH;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);

 
}


@end
