//
//  ApplySectionHeaderView.h
//  myOffer
//
//  Created by sara on 16/1/6.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UniversityFrameApplyObj;

typedef void(^sectionBlock)(UIButton *);
@interface ApplySectionHeaderView : UITableViewHeaderFooterView
@property(nonatomic,strong)NSDictionary *UniversityInfo;
@property(nonatomic,strong)UniversityFrameApplyObj *uniFrame;
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,copy)sectionBlock actionBlock;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,copy)NSString *optionOrderBy;
@property(nonatomic,assign)BOOL isStart;

+(instancetype)sectionHeaderViewWithTableView:(UITableView *)tableView;

@end
