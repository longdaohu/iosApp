//
//  XliuxueTableViewCell.h
//  XJHtester
//
//  Created by xuewuguojie on 16/3/29.
//  Copyright © 2016年 小米. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WYLXCell;

@protocol WYLXCellDelegate   <NSObject>
-(void)XliuxueTableViewCell:(WYLXCell *)cell withIndexPath:(NSIndexPath *)indexPath   textFieldDidBeginEditing:(UITextField *)textField;
-(void)XliuxueTableViewCell:(WYLXCell *)cell withIndexPath:(NSIndexPath *)indexPath didClick:(UIBarButtonItem *)sender;

@end
 
@interface WYLXCell : UITableViewCell 
@property(nonatomic,strong)XTextField  *titleTF;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)id<WYLXCellDelegate> delegate;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
