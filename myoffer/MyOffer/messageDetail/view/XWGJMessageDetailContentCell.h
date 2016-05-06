//
//  MessageSecondTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWGJMessageDetailFrame;
@interface XWGJMessageDetailContentCell : UITableViewCell
@property(nonatomic,strong)XWGJMessageDetailFrame *MessageFrame;
+(instancetype)CreateCellWithTableView:(UITableView *)tableView;

@end
