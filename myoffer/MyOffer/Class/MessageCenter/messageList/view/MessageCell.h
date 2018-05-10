//
//  MessageTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyofferMessageFrame;
@interface MessageCell : UITableViewCell
@property(nonatomic,strong)MyofferMessageFrame *messageFrame;

+(instancetype)cellWithTableView:(UITableView *)tableView;

- (void)separatorLineShow:(BOOL)show;

- (void)separatorLinePaddingShow:(BOOL)show;

- (void)tagsShow:(BOOL)show;

@end
