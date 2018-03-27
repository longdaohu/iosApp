//
//  myofferMenuCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/1/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "myOfferMenuItem.h"

@interface myofferMenuCell : UITableViewCell
@property(nonatomic,strong)myOfferMenuItem *item;
+ (instancetype)cellWithTalbeView:(UITableView *)tableView;
- (void)bottomLineWithHiden:(BOOL)hiden;
@end
