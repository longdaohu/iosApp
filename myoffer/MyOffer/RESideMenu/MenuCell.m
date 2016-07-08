//
//  MenuCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/6/28.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "MenuCell.h"

@interface MenuCell ()
@property(nonatomic,strong)UIImageView *accessoryIconView;
@property(nonatomic,strong)NSIndexPath *indexPath;
@end


@implementation MenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
        
        
        self.accessoryIconView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"message_dot"]];
        self.accessoryIconView.frame =CGRectMake(XScreenWidth*0.8 - 70, 20 , 10, 10);
        [self.contentView addSubview:self.accessoryIconView];
   
        
    }
    return self;
}


-(void)setItem:(MenuItem *)item{
    
    _item =item;
    
    self.textLabel.text = item.name;
    self.imageView.image =[UIImage imageNamed:item.icon];
    self.accessoryIconView.hidden = !item.newMessage;
}


@end
