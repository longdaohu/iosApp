//
//  EmptyDataView.h
//  OfferDemo
//
//  Created by xuewuguojie on 2016/12/23.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TableViewAlertType){

    TableViewAlertTypeDefault,
    TableViewAlertTypeReload
};

typedef void(^EmptyDataViewBlock)(void);
@interface EmptyDataView : UIView
+ (instancetype)emptyViewWithBlock:(EmptyDataViewBlock)actionBlock;
@property(nonatomic,copy)EmptyDataViewBlock  actionBlock;
@property(nonatomic,assign)TableViewAlertType alertType;
@property(nonatomic,copy)NSString *alertTitle;
@property(nonatomic,copy)NSString *alertMessage;
@property(nonatomic,copy)NSString *buttonTitle;
@property(nonatomic,copy)NSString *imageName;

@end
