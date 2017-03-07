//
//  NewSearchRstTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "NewSearchRstTableViewCell.h"
@interface NewSearchRstTableViewCell()
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *levelLab;
@property(nonatomic,strong)UILabel *areaLab;
@end

@implementation NewSearchRstTableViewCell
#pragma mark - 初始化
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @" NewSearchResult";
    NewSearchRstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[NewSearchRstTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    return cell;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLab =[[UILabel alloc] init];
        self.titleLab.font = [UIFont systemFontOfSize:14];
        self.titleLab.numberOfLines = 0;
        self.titleLab.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:self.titleLab];
        
        self.levelLab = [[UILabel alloc] init];
        self.levelLab.textColor =[UIColor darkGrayColor];
        self.levelLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.levelLab];
        
        self.areaLab = [[UILabel alloc] init];
        self.areaLab.textColor =[UIColor darkGrayColor];
        self.areaLab.font = [UIFont systemFontOfSize:12];
        [self.contentView addSubview:self.areaLab];
    }
    
    return self;
}


-(void)setItemInfo:(NSDictionary *)itemInfo
{
    _itemInfo = itemInfo;

    self.titleLab.text = itemInfo[@"official_name"];
    self.levelLab.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"UniCourseDe-006"),itemInfo[@"level"]];

    NSMutableString *areaStr =[NSMutableString stringWithFormat:@"%@: ",GDLocalizedString(@"UniCourseDe-005")];
    
    for (NSString *item in itemInfo[@"subjects"] ) {
       
         [areaStr appendFormat:@" %@ ",item];
    }
     self.areaLab.text = [NSString stringWithFormat:@"%@",areaStr];
}

 
-(void)layoutSubviews
{
    [super layoutSubviews];
    
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat leftMargin = 15;
    CGFloat topMargin = 0;
    CGFloat titleX = leftMargin;
    CGFloat titleY = topMargin;
    CGFloat titleW = contentSize.width - leftMargin;
    CGFloat titleH = 40;
    self.titleLab.frame = CGRectMake(titleX, titleY, titleW, titleH);
    
    CGFloat levelX = leftMargin;
    CGFloat levelY = CGRectGetMaxY(self.titleLab.frame) + 5;
    CGFloat levelW = 130;
    CGFloat levelH = 20;
    self.levelLab.frame = CGRectMake(levelX, levelY, levelW, levelH);
    
    
    CGFloat areaX = CGRectGetMaxX(self.levelLab.frame);
    CGFloat areaY = levelY;
    CGFloat areaW = contentSize.width - areaX;
    CGFloat areaH = levelH;
    self.areaLab.frame = CGRectMake(areaX, areaY, areaW, areaH);
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
