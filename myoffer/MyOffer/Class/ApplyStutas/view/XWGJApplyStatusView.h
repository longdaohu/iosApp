//
//  ApplyStatusView.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UniversityObj;
@class UniversityFrameObj;
@interface XWGJApplyStatusView : UITableViewHeaderFooterView
//学校模型数据
@property(nonatomic,strong)UniversityObj *uniObj;
//学校Frame模型数据
@property(nonatomic,strong)UniversityFrameObj *uni_Frame;
//判断是世界、本国排名
@property(nonatomic,copy)NSString *optionOrderBy;
+(instancetype)CreateSectionViewWithTableView:(UITableView *)tableView;
@end
