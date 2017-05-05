//
//  ApplySectionHeaderView.h
//  myOffer
//
//  Created by sara on 16/1/6.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UniversityFrameNew;

typedef void(^sectionBlock)(UIButton *);
typedef void(^newSectionBlock)(NSString *);
@interface ApplySectionHeaderView : UITableViewHeaderFooterView
@property(nonatomic,strong)UniversityFrameNew *uniFrame;
//判断cell是否需要做动画效果
//@property(nonatomic,assign)BOOL cell_Animation;
//tableView 是否处于编辑状态
@property(nonatomic,assign,getter=isEdit)BOOL edit;
//tableView处于非编辑状态时，cell内部按钮实现跳转
@property(nonatomic,copy)sectionBlock actionBlock;
//点击 cell 实现跳转到学校详情
@property(nonatomic,copy)newSectionBlock newActionBlock;
//tableView 处于编辑状态时，是否被选中
@property(nonatomic,assign)BOOL isSelected;
//排名方式
@property(nonatomic,copy)NSString *optionOrderBy;
//澳大利亚排名方式  是否显示为星号
@property(nonatomic,assign)BOOL isStart;

+(instancetype)sectionHeaderViewWithTableView:(UITableView *)tableView;
//添加按钮隐藏
-(void)addButtonWithHiden:(BOOL)hiden;
//是否显示底部分隔线
- (void)showBottomLineHiden:(BOOL)hiden;

@end
