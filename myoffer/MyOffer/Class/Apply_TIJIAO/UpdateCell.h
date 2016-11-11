//
//  UpdateCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/9/8.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^cellBlock)(NSIndexPath *indexPath,NSString *orderId);
@interface UpdateCell : UITableViewCell
@property(nonatomic,strong)NSDictionary *sku;
@property(nonatomic,copy)cellBlock actionBlock;
+ (instancetype)cellWithTableView:(UITableView *)tableView selectedIndexPaht:(NSIndexPath *)indexPath;
- (void)cellClick;

@end

