//
//  ApplyTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/5/9.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyTableViewCell : UITableViewCell
//tableView 是否处于编辑状态
@property(nonatomic,assign)BOOL Edit;
//tableView处编辑状态时，cell是否被选中
@property(nonatomic,assign)BOOL containt;
//tableView处于非编辑状态时，cell是否被选中
@property(nonatomic,assign)BOOL containt_select;
//cell.titleLab的名称
@property(nonatomic,copy)NSString  *title;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
//tableView处编辑状态时 cell选中状态时是否打勾处理
-(void)cellIsSelected:(BOOL)selected;
@end
