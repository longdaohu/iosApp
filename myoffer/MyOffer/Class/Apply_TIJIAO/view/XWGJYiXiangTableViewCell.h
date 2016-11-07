//
//  XWGJYiXiangTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/2/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWGJPeronInfoItem;
@class XWGJYiXiangTableViewCell;
@protocol XWGJYiXiangTableViewCellDelegate <NSObject>

-(void)YiXiangTableViewCell:(XWGJYiXiangTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath EditedTextField:(UITextField *)textField;
-(void)YiXiangTableViewCell:(XWGJYiXiangTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath textFieldDidBeginEditing:(UITextField *)textField;
-(void)YiXiangTableViewCell:(XWGJYiXiangTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath didClick:(UIBarButtonItem *)sender;


@end

@interface XWGJYiXiangTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ItemLab;
@property (weak, nonatomic) IBOutlet UITextField *ContentTF;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)id<XWGJYiXiangTableViewCellDelegate> delegate;
@property(nonatomic,strong)XWGJPeronInfoItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
