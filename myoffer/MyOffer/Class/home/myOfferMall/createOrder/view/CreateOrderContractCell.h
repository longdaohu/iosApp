//
//  CreateOrderContractCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/3.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,CreateOrderContractDownloadStyle) {
    CreateOrderContractDownloadStyleNomal = 0,
    CreateOrderContractDownloadStyleLoading,
    CreateOrderContractDownloadStyleLoaded,
};

@interface CreateOrderContractCell : UITableViewCell
@property(nonatomic,assign)BOOL contactStatus;
@property(nonatomic,assign)CreateOrderContractDownloadStyle  type;
@property(nonatomic,copy)void(^actionBlock)(BOOL isDownLoadButtonClick);

@end
