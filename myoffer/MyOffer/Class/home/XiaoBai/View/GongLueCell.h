//
//  GongLueListCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/4/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyOfferArticle.h"

@interface GongLueCell : UITableViewCell
@property(nonatomic,strong)MyOfferArticle *item;
+(instancetype)cellWithTableView:(UITableView *)tableView;

@end
