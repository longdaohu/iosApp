//
//  DefaultTableView.h
//  OfferDemo
//
//  Created by xuewuguojie on 2016/12/23.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DefaultTableViewBlock)();

@interface DefaultTableView : UITableView
@property(nonatomic,copy)DefaultTableViewBlock actionBlock;

- (void)emptyViewWithHiden:(BOOL)hiden;
- (void)emptyViewWithError:(NSString *)error;

@end
