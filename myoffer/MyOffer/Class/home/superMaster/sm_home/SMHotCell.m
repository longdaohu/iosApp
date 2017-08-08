//
//  SMHotCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMHotCell.h"
#import "SMHotModel.h"

@interface SMHotCell ()
@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UIImageView *tagIV;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *nameLab;
@property(nonatomic,strong)UILabel *uni_Lab;
@property(nonatomic,strong)UIView *bottom_line;
@property(nonatomic,strong)UIImageView *playIV;

@end

@implementation SMHotCell

static NSString *identify = @"sm_hot";

+ (instancetype)cellWithTableView:(UITableView *)tableView{

    SMHotCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    
    if (!cell) {
        
        cell =[[SMHotCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self makeUI];
    }
    
    return self;
}

- (void)makeUI{
    
    UIImageView *iconView = [[UIImageView alloc] init];
    self.iconView = iconView;
    iconView.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:iconView];
    iconView.clipsToBounds = YES;
    
    UIImageView *tagIV = [[UIImageView alloc] init];
    self.tagIV = tagIV;
    tagIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:tagIV];

    UIImageView *playIV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sm_play_cell"]];
    self.playIV = playIV;
    playIV.contentMode = UIViewContentModeScaleAspectFit;
    [self.contentView addSubview:playIV];
    
    
    UILabel *titleLab = [[UILabel alloc] init];
    self.titleLab = titleLab;
    [self addLable:titleLab fontSize:16 textColor:XCOLOR_TITLE];
    
    
    UILabel *nameLab = [[UILabel alloc] init];
    self.nameLab = nameLab;
    [self addLable:nameLab fontSize:14 textColor:XCOLOR_SUBTITLE];
    

    UILabel *uni_Lab = [[UILabel alloc] init];
    self.uni_Lab = uni_Lab;
    [self addLable:uni_Lab fontSize:14 textColor:XCOLOR_SUBTITLE];
    
    UIView *bottom_line = [UIView  new];
    bottom_line.backgroundColor = XCOLOR_line;
    self.bottom_line = bottom_line;
    [self.contentView addSubview:bottom_line];
    
}

- (void)addLable:(UILabel *)itemLable fontSize:(CGFloat)size textColor:(UIColor *)textColor{
    
    itemLable.font = [UIFont systemFontOfSize:size];
    itemLable.textColor = textColor;
    itemLable.numberOfLines = 2;
    [self.contentView addSubview:itemLable];
    
}


- (void)setHotFrame:(SMHotFrame *)hotFrame{

    _hotFrame = hotFrame;
    
    self.iconView.frame = hotFrame.icon_Frame;
    self.titleLab.frame = hotFrame.title_Frame;
    self.nameLab.frame = hotFrame.name_Frame;
    self.uni_Lab.frame = hotFrame.uni_Frame;
    self.tagIV.frame = hotFrame.tag_Frame;
    self.playIV.frame = hotFrame.play_Frame;
    
    
    self.bottom_line.frame = hotFrame.bottom_line_Frame;
    [self.iconView sd_setImageWithURL:[NSURL URLWithString:hotFrame.hot.ad_icon]];
    self.titleLab.text = hotFrame.hot.main_title;
    self.nameLab.text = hotFrame.hot.guest_name;
    self.uni_Lab.text = hotFrame.hot.guest_university;
    self.tagIV.image = [UIImage imageNamed:hotFrame.hot.type_name];
    [self.tagIV sizeToFit];
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
