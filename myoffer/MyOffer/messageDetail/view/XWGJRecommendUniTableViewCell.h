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
//@property(nonatomic,strong)NSDictionary *UniversityInfo;  //传入学校信息字典
@property(nonatomic,strong)UniversityObj *uni;
+(instancetype)CreateCellWithTableView:(UITableView *)tableView;
@property(nonatomic,copy)RecommendSectionViewBlock ActionBlock;

@end
