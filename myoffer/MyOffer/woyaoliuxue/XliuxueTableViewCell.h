//
//  XliuxueTableViewCell.h
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XliuxueTableViewCell;

@protocol XliuxueTableViewCellDelegate   <NSObject>
-(void)XliuxueTableViewCell:(XliuxueTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath   textFieldDidBeginEditing:(UITextField *)textField;
-(void)XliuxueTableViewCell:(XliuxueTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath didClick:(UIBarButtonItem *)sender;

@end
 
@interface XliuxueTableViewCell : UITableViewCell 
@property(nonatomic,strong)XTextField  *titleTF;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)id<XliuxueTableViewCellDelegate> delegate;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
