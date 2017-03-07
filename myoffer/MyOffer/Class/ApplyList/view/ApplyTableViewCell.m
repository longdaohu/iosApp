//
//  ApplyTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/5/9.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "ApplyTableViewCell.h"

@interface ApplyTableViewCell ()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UIImageView *iconView;
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
 
        self.titleLab =[UILabel labelWithFontsize:KDUtilSize(Uni_subject_FontSize) TextColor:XCOLOR_BLACK TextAlignment:NSTextAlignmentLeft];
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
    
    if (!Edit) self.iconView.image = nil;
    
}

-(void)setIsSelected:(BOOL)isSelected{

    _isSelected = isSelected;
    
    if (self.Edit) {
        
        [(UIImageView *)self.accessoryView setImage:nil];
        
        [self cellIsSelected:isSelected];
        
    }else{
        
        NSString *imageName = isSelected ? @"check-icons-yes": @"check-icons";
        
        [(UIImageView *)self.accessoryView setImage:[UIImage imageNamed:imageName]];
    }

}

-(void)cellIsSelected:(BOOL)selected{
    
    NSString *iconName = selected ?  @"check-icons-yes" : @"check-icons";
    
    self.iconView.image = [UIImage imageNamed:iconName];
    
}


-(void)layoutSubviews
{
    [super layoutSubviews];
 
    CGSize contentSize = self.bounds.size;

    CGFloat iconX = ITEM_MARGIN;
    CGFloat iconY = 0;
    CGFloat iconW = self.Edit ? 34 : 0;
    CGFloat iconH = contentSize.height;
    self.iconView.frame = CGRectMake(iconX, iconY, iconW, iconH);

    CGFloat titleX = iconX + iconW  + 5;
    CGFloat titleY = iconY;
    CGFloat titleW = self.Edit ? contentSize.width - titleX : contentSize.width - titleX - 44;
    CGFloat titleH = iconH;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
}



@end
