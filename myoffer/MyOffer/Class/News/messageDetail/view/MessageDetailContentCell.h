//
//  MessageSecondTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageDetailFrame;
@interface MessageDetailContentCell : UITableViewCell
@property(nonatomic,strong)MessageDetailFrame *MessageFrame;
+(instancetype)CreateCellWithTableView:(UITableView *)tableView;

@end
