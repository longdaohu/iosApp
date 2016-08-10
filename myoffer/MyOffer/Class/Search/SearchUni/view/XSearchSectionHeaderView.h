//
//  XSearchSectionHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityObj.h"
#import "UniversityFrameObj.h"

typedef void(^universityBlock)(NSString *);
@interface XSearchSectionHeaderView : UITableViewHeaderFooterView
//学校模型数据
@property(nonatomic,strong)UniversityObj *uniObj;
@property(nonatomic,strong)UniversityFrameObj *uni_Frame;
@property(nonatomic,copy)NSString *RANKTYPE;
@property(nonatomic,assign)BOOL IsStar;
//推荐图标
@property(nonatomic,strong)UIImageView *RecommendMV;

@property(nonatomic,copy)universityBlock actionBlock;

+(instancetype)SectionHeaderViewWithTableView:(UITableView *)tableView;

@end
 