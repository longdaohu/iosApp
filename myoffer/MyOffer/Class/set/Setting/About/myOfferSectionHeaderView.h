//
//  myOfferSectionHeaderView.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/1/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myOfferMenuGroup.h"


@interface myOfferSectionHeaderView : UITableViewHeaderFooterView
@property(nonatomic,strong)myOfferMenuGroup *group;
@property(nonatomic,copy)void(^myOfferSectionHeaderViewBlock)(void);
+ (instancetype)headerWithTableView:(UITableView *)tableView;
@end
