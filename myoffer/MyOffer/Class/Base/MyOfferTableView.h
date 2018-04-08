//
//  MyOfferTableView.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmptyDataView.h"

@interface MyOfferTableView : UITableView
@property(nonatomic,strong)EmptyDataView  *emptyView;
@property(nonatomic,assign)CGFloat emptyY;
@property(nonatomic,copy)NSString *btn_title;
@property(nonatomic,copy)NSString *empty_icon;

- (void)emptyViewWithHiden:(BOOL)hiden;
- (void)emptyViewWithError:(NSString *)error;

@end
