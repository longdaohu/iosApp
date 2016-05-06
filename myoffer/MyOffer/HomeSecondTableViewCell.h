//
//  HomeSecondTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeSecondTableViewCell;
@protocol HomeSecondTableViewCellDelegate <NSObject>
-(void)HomeSecondTableViewCell:(HomeSecondTableViewCell *)cell andDictionary:(NSDictionary *)response;

@end

@interface HomeSecondTableViewCell : UITableViewCell
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,weak)id<HomeSecondTableViewCellDelegate> delegate;
+(instancetype)cellInitWithTableView:(UITableView *)tableView;
@end

