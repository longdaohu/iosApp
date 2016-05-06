//
//  CommitTableViewCell.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "CommitTableViewCell.h"

@interface CommitTableViewCell ()

@end

@implementation CommitTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setItem:(peronInfoItem *)item
{
    _item = item;
    
    if (item.itemTitle.length == 0) {
       
        self.contentTextF.placeholder = item.placeholder;
        
    }
    else
    {
        self.contentTextF.text = item.itemTitle;
    }
    
    if (item.isAccessory) {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
   
}
@end
