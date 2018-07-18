//
//  HomeFeeVC.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/6/20.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,HomeLandingType) {
    HomeLandingTypeMoney = 0,
    HomeLandingTypeRoom,
    HomeLandingTypeYesGlobal,
    HomeLandingTypeUVIC,
    HomeLandingTypeApplication,
};

@interface HomeFeeVC : UIViewController
@property(nonatomic,assign)HomeLandingType type;
- (void)toLoadView;
- (void)toSetTabBarhidden;

@end
