//
//  XWGJSectionHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/2/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWGJTJSectionGroup;
@interface XWGJSectionHeaderView : UITableViewHeaderFooterView

@property(nonatomic,strong)XWGJTJSectionGroup *group;

+(instancetype)SectionViewWithTableView:(UITableView *)tableView;

@end
