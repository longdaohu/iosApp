//
//  XWGJJiBengTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/2/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWGJPeronInfoItem;
@class XWGJJiBengTableViewCell;
@protocol XWGJJiBengTableViewCellDelegate <NSObject>

-(void)JiBengTableViewCell:(XWGJJiBengTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath EditedTextField:(UITextField *)textField;
-(void)JiBengTableViewCell:(XWGJJiBengTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath textFieldDidBeginEditing:(UITextField *)textField;
-(void)JiBengTableViewCell:(XWGJJiBengTableViewCell *)cell  withIndexPath:(NSIndexPath *)indexPath didClick:(UIBarButtonItem *)sender;

@end

@interface XWGJJiBengTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *ItemLab;
@property (weak, nonatomic) IBOutlet UITextField *ContentTF;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,weak)id<XWGJJiBengTableViewCellDelegate> delegate;
@property(nonatomic,strong)XWGJPeronInfoItem *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end



