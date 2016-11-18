//
//  PipeiEditCell.h
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PipeiGroup.h"
@class PipeiEditCell;
@protocol PipeiEditCellDelegate <NSObject>

-(void)PipeiEditCellPush;
-(void)PipeiEditCell:(PipeiEditCell *)cell  textFieldDidEndEditing:(UITextField *)textField;
-(void)PipeiEditCell:(PipeiEditCell *)cell  textFieldDidBeginEditing:(UITextField *)textField;


@end
@interface PipeiEditCell : UITableViewCell
@property(nonatomic,strong)PipeiGroup *group;
@property(nonatomic,weak)id<PipeiEditCellDelegate>delegate;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
