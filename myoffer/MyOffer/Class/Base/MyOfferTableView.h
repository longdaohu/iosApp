//
//  MyOfferTableView.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myofferTableViewBlock)();

@interface MyOfferTableView : UITableView
@property(nonatomic,copy)myofferTableViewBlock actionBlock;

- (void)emptyViewWithHiden:(BOOL)hiden;

- (void)emptyViewWithError:(NSString *)error;

@end
