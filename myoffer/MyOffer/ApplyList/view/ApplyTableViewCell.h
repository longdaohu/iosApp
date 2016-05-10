//
//  ApplyTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/5/9.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyTableViewCell : UITableViewCell
@property(nonatomic,assign)BOOL Edit;
@property(nonatomic,assign)BOOL containt;
@property(nonatomic,assign)BOOL containt_select;
@property(nonatomic,copy)NSString  *title;
@property(nonatomic,strong)UIImageView *iconView;

+ (instancetype)cellWithTableView:(UITableView *)tableView;
@end
