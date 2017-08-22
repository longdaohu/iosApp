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
    
    CGFloat  line_y = self.bounds.size.height - LINE_HEIGHT;
    CGFloat  line_x = 20;
    self.bottom_line.frame = CGRectMake(line_x, line_y, XSCREEN_WIDTH, LINE_HEIGHT);
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




@end
