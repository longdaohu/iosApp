//
//  ServiceSKUCell.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/27.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ServiceSKU;
#import "ServiceSKUFrame.h"

@interface ServiceSKUCell : UITableViewCell
@property(nonatomic,strong)ServiceSKUFrame *SKU_Frame;
 
+ (instancetype)cellWithTableView:(UITableView *)tableView  indexPath:(NSIndexPath *)indexPath SKU_Frame:(ServiceSKUFrame *)SKU_Frame;

- (void)bottomLineShow:(BOOL)show;

@end
