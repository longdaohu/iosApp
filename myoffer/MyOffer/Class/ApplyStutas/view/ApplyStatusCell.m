//
//  ApplyStatusTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/7.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#define StatusFont 13
#define CellConteViewHeight 60
#define Left_Margin 14
#import "ApplyStatusCell.h"
#import "ApplyStatusRecord.h"
#import "Applycourse.h"
@interface ApplyStatusCell ()
//状态
@property (nonatomic, strong) UILabel *statusLabel;
//学科名称
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation ApplyStatusCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *identi = @"record";
    
    ApplyStatusCell *cell =[tableView dequeueReusableCellWithIdentifier:identi];
    if (!cell) {
        
        cell = [[ApplyStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identi];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.statusLabel =[[UILabel alloc] init];
        self.statusLabel.font = [UIFont systemFontOfSize:StatusFont];
        self.statusLabel.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:self.statusLabel];
        
        self.contentLabel =[[UILabel alloc] init];
        self.contentLabel.font = FontWithSize(KDUtilSize(15));
        self.contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
        self.contentLabel.numberOfLines = 2;
        [self.contentView addSubview: self.contentLabel];
    }
    return self;
}


-(void)setRecord:(ApplyStatusRecord *)record
{
    _record = record;
    
    CGSize statusSize = [record.Status  KD_sizeWithAttributeFont:[UIFont systemFontOfSize:StatusFont]];
    
    CGFloat sw = statusSize.width;
    CGFloat sx = XSCREEN_WIDTH - sw - 5;
    CGFloat sy = 0;
    CGFloat sh = CellConteViewHeight;
    self.statusLabel.frame = CGRectMake(sx,sy,sw,sh);
    self.statusLabel.text = record.Status;
    
    
    CGFloat cx = Left_Margin;
    CGFloat cy = 0;
    CGFloat cw = sx - cx;
    CGFloat ch = CellConteViewHeight;
    self.contentLabel.frame = CGRectMake(cx, cy,cw, ch);
    self.contentLabel.text = record.Course.official_name;

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];


}

@end
