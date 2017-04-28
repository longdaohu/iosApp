//
//  FilterTableViewCell.h
//  TESTER
//
//  Created by xuewuguojie on 15/12/15.
//  Copyright © 2015年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltContent.h"
#import "FilterContentFrame.h"

@class FilterTableViewCell;

typedef void(^cellButtonBlock)(UIButton *);

@protocol FilterTableViewCellDelegate  <NSObject>

-(void)FilterTableViewCell:(FilterTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender WithIndexPath:(NSIndexPath *)indexPath;

@end


@interface FilterTableViewCell : UITableViewCell
//收放按钮
@property(nonatomic,strong)UIButton *upButton;
@property(nonatomic,copy)NSString *itemTitle;
@property(nonatomic,copy)cellButtonBlock actionBlock;
@property(nonatomic,strong)NSIndexPath *indexPath;
//已选择参数
@property(nonatomic,copy)NSString *selected_item;
//数据模型
@property(nonatomic,strong)FilterContentFrame *filterFrame;

@property(nonatomic,weak)id <FilterTableViewCellDelegate> delegate;

+(instancetype)cellInitWithTableView:(UITableView *)tableView;


@end
