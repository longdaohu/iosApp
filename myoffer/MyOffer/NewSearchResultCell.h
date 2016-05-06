//
//  NewSearchResultCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/6.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UniversityFrameObj;

@interface NewSearchResultCell : UITableViewCell
@property(nonatomic,copy)NSString *optionOrderBy;         //显示排名方式
@property(nonatomic,strong)UniversityFrameObj *uni_Frame;  //传入学校信息字典
@property(nonatomic,strong)NSDictionary *UniversityInfo;  //传入学校信息字典
@property(nonatomic,assign)BOOL isStart;
+(instancetype)CreateCellWithTableView:(UITableView *)tableView;

@end
