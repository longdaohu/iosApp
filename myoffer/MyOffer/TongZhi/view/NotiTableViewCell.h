//
//  NotiTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/31.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWGJNoti;
@interface NotiTableViewCell : UITableViewCell
//@property(nonatomic,strong)NSDictionary *cellInfor;
@property(nonatomic,strong)XWGJNoti *noti;
@property(nonatomic,strong)UIImageView *NewImageView;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
