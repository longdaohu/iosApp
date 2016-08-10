//
//  AdvertiView.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/11.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AdvertiViewBlock)();
@interface AdvertiView : UIView
@property(nonatomic,copy)AdvertiViewBlock actionBlock;

@end
