//
//  myofferMenuCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/1/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "myofferMenuCell.h"

@interface  myofferMenuCell()
@property(nonatomic,strong)UIImageView *accessoryImageView;
@property(nonatomic,strong)UILabel *accessoryLab;
@property(nonatomic,strong)UIImageView *bottomLine;

@end

@implementation myofferMenuCell

static NSString *identify = @"myoffer";

+ (instancetype)cellWithTalbeView:(UITableView *)tableView{
    
    myofferMenuCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        
        cell =[[myofferMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
    }

    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.textLabel.font =  [UIFont systemFontOfSize:14];
        self.textLabel.textColor = XCOLOR_TITLE;
    }
    
    return self;
}

- (UIView *)bottomLine{
    
    if (!_bottomLine) {
        
        UIImageView *bottomLine = [UIImageView new];
        [bottomLine setImage:[UIImage KD_imageWithColor:XCOLOR_line]];
        _bottomLine = bottomLine;
        bottomLine.hidden = true;
        [self.contentView addSubview:bottomLine];
    }
    
    return  _bottomLine;
}

- (UIImageView *)accessoryImageView{
    
    if (!_accessoryImageView) {
        
        _accessoryImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"about_weibo"]];
        _accessoryImageView.contentMode =  UIViewContentModeScaleAspectFit;
    }
    
    return _accessoryImageView;
}

- (UILabel *)accessoryLab{
    
    if (!_accessoryLab) {
        
        _accessoryLab = [[UILabel alloc] init];
        _accessoryLab.font =  [UIFont systemFontOfSize:12];
        _accessoryLab.textColor = XCOLOR_SUBTITLE;
    }
    
    return _accessoryLab;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    if (!self.bottomLine.hidden) {
        
        CGFloat  line_x = 20;
        CGFloat  line_w = XSCREEN_WIDTH;
        CGFloat  line_h = LINE_HEIGHT;
        CGFloat  line_y = self.bounds.size.height - LINE_HEIGHT;
        self.bottomLine.frame = CGRectMake(line_x, line_y, line_w, line_h);
    }
    
}


- (void)setItem:(myOfferMenuItem *)item{
    
    _item = item;
    
    self.imageView.image = [UIImage imageNamed:item.icon];
    self.textLabel.text = item.title;
    self.accessoryType = item.accessoryArrow ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
    
    if (item.accessory_image.length>0) {
        self.accessoryImageView.image = [UIImage imageNamed:item.accessory_image];
        self.accessoryView = self.accessoryImageView;
    }
    
    if (item.accessory_title.length>0) {
        self.accessoryLab.text = item.accessory_title;
        [self.accessoryLab sizeToFit];
        self.accessoryView = self.accessoryLab;
    }
}

- (void)bottomLineWithHiden:(BOOL)hiden{
    
    self.bottomLine.hidden = hiden;
}



@end
