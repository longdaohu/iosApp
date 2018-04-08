//
//  EmptyDataView.h
//  OfferDemo
//
//  Created by xuewuguojie on 2016/12/23.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^EmptyDataViewBlock)(void);

@interface EmptyDataView : UIView
+ (instancetype)emptyViewWithBlock:(EmptyDataViewBlock)actionBlock;
@property(nonatomic,copy)EmptyDataViewBlock  actionBlock;
@property(nonatomic,copy)NSString *errorStr;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *btn_title;


@end
