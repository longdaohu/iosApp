//
//  CatigaryHotCityCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/4/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HotCityCellBlock)(NSString *city);

@interface CatigaryHotCityCell : UITableViewCell

@property(nonatomic,strong)NSArray *hotCities;
@property(nonatomic,assign)BOOL lastCell;
@property(nonatomic,copy)HotCityCellBlock actionBlock;

+ (instancetype)cellInitWithTableView:(UITableView *)tableView;

@end
