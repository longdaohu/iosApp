//
//  SMAudioCell.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMAudioItemFrame.h"

@interface SMAudioCell : UITableViewCell
@property(nonatomic,strong)SMAudioItemFrame *audioFrame;

+ (instancetype)cellWithTableView:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath;

- (void)bottomLineWithHiden:(BOOL)hiden;

@end
