//
//  ServiceItemBottomView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/3/30.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^bottomViewBlock)(UIButton *sender);

@interface ServiceItemBottomView : UIView
@property(nonatomic,copy)NSString *price;
@property(nonatomic,copy)bottomViewBlock acitonBlock;
@end
