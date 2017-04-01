//
//  ServiceProtocalBottomView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/31.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^protocalBottomBlock)(BOOL isAgree);

@interface ServiceProtocalBottomView : UIView
@property(nonatomic,copy)protocalBottomBlock actionBlock;


@end
