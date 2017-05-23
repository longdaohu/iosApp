//
//  ZhiXunCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/22.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYLXGroup.h"
@class ZhiXunCell;

@protocol ZiXunCellDelegate   <NSObject>

- (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath   textFieldDidBeginEditing:(UITextField *)textField;
- (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath   textFieldDidEndEditing:(UITextField *)textField;
- (void)zixunCell:(ZhiXunCell *)cell indexPath:(NSIndexPath *)indexPath didClickWithTextField:(UITextField *)textField;

@end


@interface ZhiXunCell : UITableViewCell

@property(nonatomic,strong)WYLXGroup *group;

@property(nonatomic,strong)UITextField *inputTF;

@property(nonatomic,weak)id<ZiXunCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

@end
