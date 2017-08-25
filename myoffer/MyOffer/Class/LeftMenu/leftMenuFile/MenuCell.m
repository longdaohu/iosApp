//
//  MenuCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/28.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell ()
@property(nonatomic,strong)UILabel *countLab;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end


@implementation MenuCell


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    [super setSelected:selected animated:animated];

}


static NSString *cellIdentifier = @"menu";

+(instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath
{
    MenuCell *cell =[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        
        cell =[[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    cell.selectionStyle  = UITableViewCellSelectionStyleNone;
    cell.indexPath = indexPath;
    
    return cell;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.textLabel.font = [UIFont systemFontOfSize:20];
        self.textLabel.textColor = [UIColor whiteColor];
        
        UIView *lineView2 =[[UIView alloc] initWithFrame:CGRectMake(35,49, self.contentView.frame.size.width, 1)];
        lineView2.backgroundColor =[UIColor blackColor];
        UIView *lineView1 =[[UIView alloc] initWithFrame:CGRectMake(35,50, self.contentView.frame.size.width
                                                                    , 1)];
        lineView1.backgroundColor =[UIColor darkGrayColor];
        
        [self.contentView addSubview:lineView1];
        [self.contentView addSubview:lineView2];
        
        
        self.countLab =[[UILabel alloc] init];
        self.countLab.layer.cornerRadius = REDSPOT_HEIGHT * 0.5;
        self.countLab.layer.masksToBounds = YES;
        self.countLab.backgroundColor =[UIColor redColor];
        self.countLab.textColor = [UIColor whiteColor];
        self.countLab.textAlignment =NSTextAlignmentCenter;
        self.countLab.font = [UIFont systemFontOfSize:13];
        self.countLab.hidden = YES;
        [self.contentView addSubview:self.countLab];
        
    }
    return self;
}


-(void)setItem:(MenuItem *)item{
    
    _item =item;
    
    self.textLabel.text = item.name;
    
    self.imageView.image =[UIImage imageNamed:item.icon];
    
    self.countLab.hidden = item.messageCount.integerValue == 0;
    
    self.countLab.text = item.messageCount.integerValue  >= 100 ? @"99+": item.messageCount;
    
    CGFloat countw  = REDSPOT_HEIGHT;
    
    if (self.countLab.text.length > 1) {
        
        CGSize countSize = [self.countLab.text KD_sizeWithAttributeFont:[UIFont systemFontOfSize:13]];
        countw = countSize.width  + 8;
     }
    
    CGFloat countx  = XSCREEN_WIDTH * 0.8 - 70;
    CGFloat county  = 0.5 * (self.bounds.size.height - 18);
    CGFloat counth  = REDSPOT_HEIGHT;
    self.countLab.frame =  CGRectMake(countx,county,countw,counth);
}





@end
