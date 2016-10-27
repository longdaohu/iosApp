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
@property(nonatomic,assign)BOOL isEdit;
@property(nonatomic,copy)sectionBlock actionBlock;
@property(nonatomic,copy)newSectionBlock newActionBlock;
@property(nonatomic,assign)BOOL isSelected;
@property(nonatomic,copy)NSString *optionOrderBy;
@property(nonatomic,assign)BOOL isStart;

+(instancetype)sectionHeaderViewWithTableView:(UITableView *)tableView;
-(void)addButtonHiden;
@end
