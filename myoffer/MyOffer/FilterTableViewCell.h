//
//  FilterTableViewCell.h
//  TESTER
//
//  Created by xuewuguojie on 15/12/15.
//  Copyright © 2015年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FiltContent.h"
#import "FilterSection.h"
#import "FilterItem.h"


@class FilterTableViewCell;
typedef void(^cellButtonBlock)(UIButton *);

@protocol FilterTableViewCellDelegate  <NSObject>

-(void)FilterTableViewCell:(FilterTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender WithIndexPath:(NSIndexPath *)indexPath;

@end


@interface FilterTableViewCell : UITableViewCell
@property(nonatomic,copy)NSString *itemTitle;
@property(nonatomic,strong)FiltContent *fileritem;
@property(nonatomic,copy)cellButtonBlock actionBlock;
@property(nonatomic,strong)UILabel *detailNameLabel;
@property(nonatomic,assign)NSInteger  selectButtonTag;
@property(nonatomic,strong)NSIndexPath *indexPath;
@property(nonatomic,strong)UIView *contentBackView;

@property(nonatomic,weak)id <FilterTableViewCellDelegate> delegate;

+(instancetype)cellInitWithTableView:(UITableView *)tableView;

@end
