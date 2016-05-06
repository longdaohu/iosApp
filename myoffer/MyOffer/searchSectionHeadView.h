//
//  searchSectionHeadView.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityObj.h"
typedef void(^headBock)(UIButton *);
typedef void(^universityBlock)(NSString *);
@interface searchSectionHeadView : UITableViewHeaderFooterView
@property(nonatomic,copy)universityBlock actionBlock;
@property(nonatomic,strong)UniversityObj *uniObj;   //学校模型数据
@property(nonatomic,copy)NSString *optionOrderBy;   //判断是世界、本国排名
@property(nonatomic,strong)UIImageView *RecommendMV;//推荐图标
@property(nonatomic,assign)BOOL isStart;            //判断是否出现*图标
+(instancetype)CreateSectionViewWithTableView:(UITableView *)tableView;


@end
