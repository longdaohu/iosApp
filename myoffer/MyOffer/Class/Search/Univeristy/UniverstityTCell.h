//
//  UniverstityTCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/17.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityFrameModel.h"

@interface UniverstityTCell : UITableViewCell

@property(nonatomic,strong)UniversityFrameNew *uniFrame;
@property(nonatomic,strong)UniversityFrameModel *uniFrameModel;
+ (instancetype)cellViewWithTableView:(UITableView *)tableView;

- (void)separatorLineShow:(BOOL)show;

@end
