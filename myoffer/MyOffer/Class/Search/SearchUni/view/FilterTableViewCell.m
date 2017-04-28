//
//  FilterTableViewCell.m
//  TESTER
//
//  Created by xuewuguojie on 15/12/15.
//  Copyright © 2015年 xuewuguojie. All rights reserved.
//
#define CELLITEMFONT 18
#define DefaultColor [UIColor colorWithRed:231.0/255 green:231.0/255 blue:231.0/255 alpha:1]
#import "FilterTableViewCell.h"

@interface FilterTableViewCell()

@property(nonatomic,strong)UIImageView *iconView;
@property(nonatomic,strong)UILabel *titleLab;
@property(nonatomic,strong)UILabel *detailLab;
@property(nonatomic,strong)UIButton *lastButton;
@property(nonatomic,strong)UIView *bgView;

@end

@implementation FilterTableViewCell

+(instancetype)cellInitWithTableView:(UITableView *)tableView{
    
    FilterTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"filter"];
    
    if (!cell) {
        
        cell =[[FilterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"filter"];
        
    }
    
    
    return cell;
}


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconView =[[UIImageView alloc] init];
        self.iconView.contentMode = UIViewContentModeLeft;
        [self addSubview:self.iconView];
        
        
        self.titleLab =[[UILabel alloc] init];
        self.titleLab.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titleLab];
        
        self.detailLab =[[UILabel alloc] init];
        self.detailLab.font = [UIFont systemFontOfSize:16];
        self.detailLab.textColor = XCOLOR_RED;
        [self addSubview:self.detailLab];
        
        self.bgView =[[UIView alloc] init];
        [self addSubview:self.bgView];
        
        self.upButton =[[UIButton alloc] init];
        [self.upButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [self.upButton setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateSelected];
        [self.upButton addTarget:self action:@selector(upClick:) forControlEvents:UIControlEventTouchUpInside];
        self.upButton.tag = DEFAULT_NUMBER;
        [self addSubview:self.upButton];
        
        
    }
    return self;
}


-(void)setIndexPath:(NSIndexPath *)indexPath{
    
    _indexPath = indexPath;
}




-(void)setFilterFrame:(FilterContentFrame *)filterFrame
{
    _filterFrame = filterFrame;
    
    FiltContent *filter = filterFrame.filter;
    
    self.iconView.image =[UIImage imageNamed:filter.icon];
    self.iconView.frame = filterFrame.iconFrame;
    
    
    self.titleLab.frame = filterFrame.titleFrame;
    self.titleLab.text = filter.title;
    
    
    self.detailLab.frame = filterFrame.subtitleFrame;
    self.detailLab.text = filter.subtitle;
    
    
    self.upButton.frame = filterFrame.upFrame;
    self.upButton.selected = (filterFrame.cellState == FilterCellStateRealHeight);


    
    self.bgView.frame  = filterFrame.bgFrame;
    for (int index = 0; index < filterFrame.itemFrames.count; index++) {
        
        NSValue *itemValue =  filterFrame.itemFrames[index];
        
        NSString *senderName = filter.optionItems[index];
        
        UIButton *sender = [self makeButtonWithTitle:senderName tagIndex:index frame:itemValue.CGRectValue];
        
        [self.bgView addSubview:sender];
        
        if ([filter.selectedValue isEqualToString:senderName] ) {

                sender.selected = YES;
                self.lastButton = sender;
                self.detailLab.text = sender.titleLabel.text;
            
        }else{
        
                sender.selected = NO;
        }
        
        
    }
    
}


- (UIButton *)makeButtonWithTitle:(NSString *)title tagIndex:(NSInteger)tag frame:(CGRect)frame{

    UIButton *sender = [[UIButton alloc]init];
    [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_BG] forState:UIControlStateNormal];
    [sender setBackgroundImage:[UIImage KD_imageWithColor:XCOLOR_RED] forState:UIControlStateSelected];
    sender.layer.cornerRadius = CORNER_RADIUS;
    sender.layer.masksToBounds = YES;
    sender.tag = tag;
    sender.titleLabel.font = [UIFont systemFontOfSize:15];
    [sender addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    sender.frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 30);
    [sender setTitle:title forState:UIControlStateNormal];
    
    
    return sender;

}


-(void)onClick:(UIButton *)sender{
    
    
    if (self.upButton.hidden){
    
        [self upClick:sender];
        
        return;
    }
    
    
    NSString *detailStr;
    if (self.lastButton &&  (self.lastButton == sender)) {
        
        detailStr = @"全部";
        self.lastButton.selected = NO;
        self.lastButton = nil;
      
        
    }else{
        
        self.lastButton.selected = NO;
        self.lastButton = sender;
        self.lastButton.selected = YES;
        detailStr = sender.titleLabel.text;

    }
    
    self.detailLab.text = detailStr;
    self.filterFrame.filter.selectedValue = [detailStr isEqualToString:@"全部"] ? nil : detailStr;
    
    
    
    [self upClick:sender];

}



-(void)upClick:(UIButton *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(FilterTableViewCell:WithButtonItem:WithIndexPath:)]) {
        
        [self.delegate FilterTableViewCell:self WithButtonItem:sender WithIndexPath:self.indexPath];
    }
}







@end

