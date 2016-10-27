//
//  MessageTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWGJMessageFrame;
@interface MessageCell : UITableViewCell
@property(nonatomic,strong)XWGJMessageFrame *messageFrame;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
