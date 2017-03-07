//
//  ApplyStatusTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/7.
//  Copyright © 2016年 UVIC. All rights reserved.
//
#define StatusFont 13
#define Left_Margin 14
#import "ApplyStatusCell.h"
#import "ApplyStatusRecord.h"
#import "Applycourse.h"
@interface ApplyStatusCell ()
//状态
@property (nonatomic, strong) UILabel *statusLab;
//学科名称
@property (nonatomic, strong) UILabel *subjectLab;

@end

@implementation ApplyStatusCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *recordReuse = @"record";
    
    ApplyStatusCell *cell =[tableView dequeueReusableCellWithIdentifier:recordReuse];
    if (!cell) {
        
        cell = [[ApplyStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recordReuse];
    }
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UILabel *statusLab = [[UILabel alloc] init];
        statusLab.font = [UIFont systemFontOfSize:StatusFont];
        statusLab.textColor = [UIColor darkGrayColor];
        [self.contentView addSubview:statusLab];
        self.statusLab =  statusLab;
        
        UILabel *subjectLab = [[UILabel alloc] init];
        self.subjectLab = subjectLab;
        subjectLab.font = FontWithSize(KDUtilSize(15));
        subjectLab.lineBreakMode = NSLineBreakByCharWrapping;
        subjectLab.numberOfLines = 2;
        [self.contentView addSubview: subjectLab];
        
    }
    return self;
}


-(void)setRecord:(ApplyStatusRecord *)record
{
    _record = record;
    
    self.statusLab.text = record.Status;
    [self.statusLab sizeToFit];

    self.subjectLab.text = record.Course.official_name;

}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    
    
    if (self.record) {
        
        CGSize contentSize = self.contentView.bounds.size;
        
        CGRect newRect = self.statusLab.frame;
        newRect.size.height = contentSize.height;
        newRect.origin.x    = contentSize.width - self.statusLab.frame.size.width - 5;
        self.statusLab.frame = newRect;
        
        
        CGFloat subjectx = Left_Margin;
        CGFloat subjecty = 0;
        CGFloat subjectw = CGRectGetMinX(self.self.statusLab.frame) - subjectx;
        CGFloat subjecth = contentSize.height;
        self.subjectLab.frame = CGRectMake(subjectx, subjecty,subjectw, subjecth);
        
    }
    

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];


}

@end
