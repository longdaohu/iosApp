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
//logoView
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *lastButton;
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
        
        self.logoView =[[UIImageView alloc] init];
        self.logoView.contentMode = UIViewContentModeLeft;
        [self addSubview:self.logoView];
        
        
        self.titleLabel =[[UILabel alloc] init];
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.titleLabel];
        
        self.detailNameLabel =[[UILabel alloc] init];
        self.detailNameLabel.font = [UIFont systemFontOfSize:16];
        self.detailNameLabel.textColor = XCOLOR_RED;
        [self addSubview:self.detailNameLabel];
        
        self.contentBackView =[[UIView alloc] init];
        [self addSubview:self.contentBackView];
        
        self.upButton =[[UIButton alloc] init];
        [self.upButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
        [self.upButton addTarget:self action:@selector(up:) forControlEvents:UIControlEventTouchUpInside];
        self.upButton.tag = 999;
        [self addSubview:self.upButton];
        
        
    }
    return self;
}


-(void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
}


-(void)setFileritem:(FiltContent *)fileritem
{
    _fileritem =fileritem;
    
    self.titleLabel.text = fileritem.titleName;
    
    self.detailNameLabel.text = fileritem.detailTitleName;
    CGSize titleSize = [fileritem.titleName KD_sizeWithAttributeFont:[UIFont systemFontOfSize:CELLITEMFONT]];
    
    self.titleLabel.frame = CGRectMake(15,10, titleSize.width, 20);
    
    self.detailNameLabel.frame = CGRectMake(CGRectGetMaxX(self.titleLabel.frame)+5,10,APPSIZE.width - 100, 20);
    
    //第一个 label的起点
    CGSize startSize = CGSizeMake(0, 10);
    //间距
    CGFloat padding = 10.0;
    
    CGFloat MAXWidth = [UIScreen  mainScreen].bounds.size.width - 30;
    
    
    
    for (int i = 0; i < fileritem.buttonArray.count; i ++) {
        
        CGFloat keyWordWidth = [fileritem.buttonArray[i] KD_sizeWithAttributeFont:[UIFont systemFontOfSize:CELLITEMFONT]].width +15;
        
        if (keyWordWidth > MAXWidth) {
            
            keyWordWidth = MAXWidth;
        }
        if (MAXWidth - startSize.width < keyWordWidth) {
            
            startSize.height += 35.0;
            
            startSize.width = 0;
        }
        //创建 label点击事件
        UIButton *sender = [[UIButton alloc]init];
        sender.tag = i;
        [sender addTarget:self action:@selector(cellButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        sender.frame =CGRectMake(startSize.width, startSize.height, keyWordWidth, 25);
        sender.layer.cornerRadius = 5;
        [sender setTitle:fileritem.buttonArray[i] forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont systemFontOfSize:15];
        
        
        
        if ([self.selectItem isEqualToString: fileritem.buttonArray[i]]) {
            
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sender.backgroundColor =XCOLOR_RED;
            self.lastButton = sender;
            self.detailNameLabel.text = sender.titleLabel.text;
            
        }else{
            
            sender.backgroundColor = BACKGROUDCOLOR;
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
        
        
        
        
        [self.contentBackView addSubview:sender];
        
        
        //起点 增加
        startSize.width += keyWordWidth + padding;
    }
    //    self.contentBackView.frame =  CGRectMake(15,CGRectGetMaxY(self.titleLabel.frame),[UIScreen mainScreen].bounds.size.width - 30, fileritem.contentheigh);
    
}
-(void)cellButtonItemPressed:(UIButton *)sender
{
    
    
    if ([self.delegate respondsToSelector:@selector(FilterTableViewCell:WithButtonItem:WithIndexPath:)]) {
        
        [self.delegate FilterTableViewCell:self WithButtonItem:sender WithIndexPath:self.indexPath];
    }
    
    
    if (self.upButton.hidden) {
        
        return;
    }
    
    
    if (self.lastButton) {
        
        [self.lastButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        self.lastButton.backgroundColor = BACKGROUDCOLOR;
        
        if (self.lastButton == sender) {
            
            self.detailNameLabel.text = GDLocalizedString(@"SearchResult_All");
            self.lastButton = nil;
            
        }else{
            
            self.detailNameLabel.text = sender.titleLabel.text;
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sender.backgroundColor = XCOLOR_RED;
            self.lastButton = sender;
        }
        
        
    }else{
        
        self.detailNameLabel.text = sender.titleLabel.text;
        [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        sender.backgroundColor = XCOLOR_RED;
        self.lastButton = sender;
    }
    
    
}


-(void)up:(UIButton *)sender
{
    
    if ([self.delegate respondsToSelector:@selector(FilterTableViewCell:WithButtonItem:WithIndexPath:)]) {
        
        [self.delegate FilterTableViewCell:self WithButtonItem:sender WithIndexPath:self.indexPath];
    }
}




-(void)setFilterFrame:(FilterContentFrame *)filterFrame
{
    _filterFrame = filterFrame;
    
    FiltContent *fileritem = filterFrame.content;
    
    self.logoView.image =[UIImage imageNamed:fileritem.logoName];
    self.logoView.frame = filterFrame.logoFrame;
    
    self.titleLabel.frame = filterFrame.titleFrame;
    self.titleLabel.text = fileritem.titleName;
    
    self.detailNameLabel.frame = filterFrame.detailFrame;
    self.detailNameLabel.text = fileritem.detailTitleName;
    self.upButton.frame = filterFrame.upFrame;
    self.contentBackView.frame  = filterFrame.bgFrame;
    
    
    if (filterFrame.cellState == 1) {
        
        [self.upButton setImage:[UIImage imageNamed:@"arrow_down"] forState:UIControlStateNormal];
    }
    
    if (filterFrame.cellState == 0) {
        
        [self.upButton setImage:[UIImage imageNamed:@"arrow_up"] forState:UIControlStateNormal];
    }
    
    for (int index = 0; index < filterFrame.itemFrames.count; index++) {
        
        NSValue *xvalue =  filterFrame.itemFrames[index];
        CGRect itemRect =  xvalue.CGRectValue;
        
        UIButton *sender = [[UIButton alloc]init];
        sender.tag = index;
        [sender addTarget:self action:@selector(cellButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
        sender.frame = CGRectMake(itemRect.origin.x, itemRect.origin.y, itemRect.size.width, 30);
        sender.layer.cornerRadius = 5;
        [sender setTitle:fileritem.buttonArray[index] forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont systemFontOfSize:15];
        
        
        
        if ([self.selectItem isEqualToString: fileritem.buttonArray[index]]) {
            
            [sender setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sender.backgroundColor =XCOLOR_RED;
            self.lastButton = sender;
            self.detailNameLabel.text = sender.titleLabel.text;
            
        }else{
            
            sender.backgroundColor = BACKGROUDCOLOR;
            [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            
        }
        
        
        [self.contentBackView addSubview:sender];
        
        
    }
    
}



@end
