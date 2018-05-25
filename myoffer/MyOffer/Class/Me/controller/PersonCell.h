//
//  PersonCell.h
//  myOffer
//
//  Created by xuewuguojie on 2017/8/21.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWGJAbout;

@interface PersonCell : UITableViewCell

@property(nonatomic,strong)XWGJAbout *item;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
- (void)bottomLineShow:(BOOL)show;
- (void)redSpodShow:(BOOL)show;

@end
