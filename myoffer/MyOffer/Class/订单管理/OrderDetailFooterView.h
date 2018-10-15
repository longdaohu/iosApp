//
//  OrderDetailFooterView.h
//  myOffer
//
//  Created by xuewuguojie on 16/6/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, OrderDetailDownloadStyle) {
    OrderDetailDownloadStyleNomal = 0,
    OrderDetailDownloadStyleLoading,
    OrderDetailDownloadStyleLoaded,
};

typedef void(^OrderDetailFooterViewBlock)(UIButton *sender);
@interface OrderDetailFooterView : UIView
@property(nonatomic,copy)OrderDetailFooterViewBlock actionBlock;
@property(nonatomic,strong)NSDictionary *orderDict;
@property(nonatomic,assign)CGFloat headHeight;

@property(nonatomic,strong)NSDictionary *contracturls_result;
@property(nonatomic,assign)OrderDetailDownloadStyle  type;
@property(nonatomic,copy)void(^orderDetailActionBlock)(BOOL isDownLoadButtonClick);

@property(nonatomic,strong)NSDictionary *afterServiceDict;//售后服务hdr

@end



