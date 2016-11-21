//
//  PipeiCountryCell.h
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PipeiCountryCellBlock)(NSString *);
@interface PipeiCountryCell : UITableViewCell
@property(nonatomic,copy)NSString *countryName;
@property(nonatomic,copy)PipeiCountryCellBlock valueBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end

