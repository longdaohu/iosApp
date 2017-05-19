//
//  UniverstityTCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/17.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UniverstityTCell : UITableViewCell

@property(nonatomic,strong)UniversityFrameNew *uniFrame;

+ (instancetype)cellViewWithTableView:(UITableView *)tableView;

- (void)separatorLineShow:(BOOL)show;

@end
