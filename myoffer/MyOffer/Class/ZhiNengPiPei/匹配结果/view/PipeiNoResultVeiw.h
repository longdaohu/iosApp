//
//  PipeiNoResultVeiw.h
//  myOffer
//
//  Created by xuewuguojie on 2016/11/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^PipeiNoResultVeiwBlock)(void);
@interface PipeiNoResultVeiw : UIView
@property(nonatomic,copy)PipeiNoResultVeiwBlock actionBlock;
+ (instancetype)viewWithActionBlock:(PipeiNoResultVeiwBlock)actionBlock;
@end
