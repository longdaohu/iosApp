//
//  RankTypeTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RankTypeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *accessoryMV;
@property (weak, nonatomic) IBOutlet UILabel *TitleLab;
@property(nonatomic,copy)NSString *title;

+(instancetype)cellInitWithTableView:(UITableView *)tableView;

@end
