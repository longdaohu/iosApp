//
//  RecommendUniTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UniversityObj;
typedef void(^RecommendSectionViewBlock)(UIButton *sender);
@interface XWGJRecommendUniTableViewCell : UITableViewCell
@property(nonatomic,strong)UniversityObj *uni;
@property(nonatomic,copy)RecommendSectionViewBlock ActionBlock;
+(instancetype)CreateCellWithTableView:(UITableView *)tableView;

@end
