//
//  NewSearchRstTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "NewSearchRstTableViewCell.h"
@interface NewSearchRstTableViewCell()
@property(nonatomic,strong)UILabel *TitleLabel;
@property(nonatomic,strong)UILabel *LevelLabel;
@property(nonatomic,strong)UILabel *AreaLabel;
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
        self.TitleLabel =[[UILabel alloc] init];
        self.LevelLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.TitleLabel];
        
        self.LevelLabel = [[UILabel alloc] init];
        self.LevelLabel.textColor =[UIColor darkGrayColor];
        self.LevelLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.LevelLabel];
        
        self.AreaLabel = [[UILabel alloc] init];
        self.AreaLabel.textColor =[UIColor darkGrayColor];
        self.AreaLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.AreaLabel];
    }
    
    return self;
}

-(void)setItemInfo:(NSDictionary *)itemInfo
{
    _itemInfo = itemInfo;
 
    self.TitleLabel.text = itemInfo[@"official_name"];
    self.LevelLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"UniCourseDe-006"),itemInfo[@"level"]];
    self.AreaLabel.text = [NSString stringWithFormat:@"%@：%@",GDLocalizedString(@"UniCourseDe-005"),[itemInfo[@"areas"] componentsJoinedByString:@","]];
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CGFloat leftMargin = 15;
    CGFloat topMargin = 10;
    CGFloat Tx = leftMargin;
    CGFloat Ty = topMargin;
    CGFloat Tw = APPSIZE.width - leftMargin;
    CGFloat Th = 25;
    self.TitleLabel.frame = CGRectMake(Tx, Ty, Tw, Th);
    
    CGFloat Lx = leftMargin;
    CGFloat Ly = CGRectGetMaxY(self.TitleLabel.frame) + 5;
    CGFloat Lw = 130;
    CGFloat Lh = 20;
    self.LevelLabel.frame = CGRectMake(Lx, Ly, Lw, Lh);
    
    
    CGFloat Ax = CGRectGetMaxX(self.LevelLabel.frame);
    CGFloat Ay = Ly;
    CGFloat Aw = APPSIZE.width - Ax;
    CGFloat Ah = Lh;
    self.AreaLabel.frame = CGRectMake(Ax, Ay, Aw, Ah);
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
