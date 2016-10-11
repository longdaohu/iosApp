//
//  RankTypeTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "RankTypeTableViewCell.h"

@implementation RankTypeTableViewCell

+(instancetype)cellInitWithTableView:(UITableView *)tableView{
 
    RankTypeTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"rank"];
    
    if (!cell) {
        
        cell =[[NSBundle mainBundle] loadNibNamed:@"RankTypeTableViewCell" owner:self options:nil].lastObject;
        
    }
    return cell;
}


-(void)setTitle:(NSString *)title
{
    _title = title;
    
    self.TitleLab.text = self.title;
    
}


- (void)awakeFromNib {
    // Initialization code
    
    [super awakeFromNib];

    
    self.accessoryMV.contentMode = UIViewContentModeCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
