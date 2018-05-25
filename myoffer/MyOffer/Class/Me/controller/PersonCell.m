//
//  PersonCell.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "PersonCell.h"
#import "XWGJAbout.h"

@interface PersonCell ()
@property (strong, nonatomic)UIImageView *bottom_line;
@property(nonatomic,strong)UIImageView *accessoryImageView;
@property(nonatomic,strong)UIImageView *redSpod;
@end


@implementation PersonCell

+ (instancetype)cellWithTableView:(UITableView *)tableView{

    PersonCell *cell =[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([PersonCell class])];
    
    if (!cell) {
        
        cell = [[PersonCell  alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:NSStringFromClass([PersonCell class])];
    }
    
    
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        UIImageView *bottom_line = [UIImageView new];
        self.bottom_line = bottom_line;
        [self.contentView addSubview:bottom_line];
        [self.bottom_line setImage:[UIImage KD_imageWithColor:XCOLOR_line]];
        
        self.textLabel.font =  [UIFont systemFontOfSize:14];
        self.textLabel.textColor = XCOLOR_TITLE;
        
        self.detailTextLabel.font =  [UIFont systemFontOfSize:12];
        self.detailTextLabel.textColor = XCOLOR_SUBTITLE;
        
        UIImageView *redSpod = [UIImageView new];
        self.redSpod = redSpod;
        redSpod.image = [UIImage KD_imageWithColor:XCOLOR_RED];
        redSpod.layer.cornerRadius = 4;
        redSpod.layer.masksToBounds = YES;
        redSpod.hidden = YES;
        [redSpod bringSubviewToFront:self.imageView];
        [self.contentView addSubview:redSpod];
 
    }
    
    return self;
}

- (UIImageView *)accessoryImageView{

    if (!_accessoryImageView) {
        _accessoryImageView= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
         self.accessoryView = _accessoryImageView;
    }
    
    return _accessoryImageView;
}

- (void)layoutSubviews{

    [super layoutSubviews];
    
    CGSize contentSize = self.bounds.size;
    
    CGFloat  line_h = LINE_HEIGHT;
    CGFloat  line_y = contentSize.height - line_h;
    CGFloat  line_x = 20;
    CGFloat  line_w = XSCREEN_WIDTH;
    self.bottom_line.frame = CGRectMake(line_x, line_y, line_w, line_h);
    
    CGFloat  red_h = 10;
    CGFloat  red_w = 10;
    CGFloat  red_y = CGRectGetMinY(self.imageView.frame) - red_h * 0.5;
    CGFloat  red_x = CGRectGetMaxX(self.imageView.frame) - red_w * 0.5;
    self.redSpod.frame = CGRectMake(red_x, red_y, red_w, red_h);
}


- (void)setItem:(XWGJAbout *)item{

    _item = item;
    
    self.imageView.image =[UIImage imageNamed:item.Logo];
    self.textLabel.text = item.title;
    self.detailTextLabel.text = item.acc_title;
    
    if (item.acc_icon) {
        self.accessoryImageView.image = [UIImage imageNamed:item.acc_icon];
    }else{
        self.accessoryView = nil;
    }

    if (item.accessoryType) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }else{
        self.accessoryType = UITableViewCellAccessoryNone;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)bottomLineShow:(BOOL)show{

    self.bottom_line.hidden = !show;
}
- (void)redSpodShow:(BOOL)show{
    
    self.redSpod.hidden = !show;
}



@end
