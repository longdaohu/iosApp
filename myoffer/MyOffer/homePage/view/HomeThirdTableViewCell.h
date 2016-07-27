//
//  HomeThirdTableViewCell.h
//  myOffer
//
//  Created by sara on 16/3/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomeThirdTableViewCell;

@protocol HomeThirdTableViewCellDelegate <NSObject>
-(void)HomeThirdTableViewCell:(HomeThirdTableViewCell *)cell andDictionary:(NSDictionary *)response;

@end

@interface HomeThirdTableViewCell : UITableViewCell
@property(nonatomic,strong)NSArray *uniFrames;
@property(nonatomic,weak)id<HomeThirdTableViewCellDelegate> delegate;

+(instancetype)cellInitWithTableView:(UITableView *)tableView;

@end