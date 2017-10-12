//
//  ServiceProductDescriptCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/9/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServiceProductDescriptCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *comment;
@property(nonatomic,assign)CGFloat cell_height;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@end
