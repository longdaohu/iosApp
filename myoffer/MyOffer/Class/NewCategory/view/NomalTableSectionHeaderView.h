//
//  UniversitySearchHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/7.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NomalTableSectionHeaderView : UITableViewHeaderFooterView
-(void)sectionHeaderWithTitle:(NSString *)title FontSize:(CGFloat)fontSize;
+(instancetype)sectionViewWithTableView:(UITableView *)tableView;

@end
