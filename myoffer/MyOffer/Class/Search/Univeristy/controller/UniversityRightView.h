//
//  UniversityRightView.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

typedef enum{
    RightViewItemStyleFavorited = 0,  //喜欢
    RightViewItemStyleShare          //分享
}RightViewItemStyle;


#import <UIKit/UIKit.h>
typedef void(^UniversityRightViewwBlock)(UIButton *sender);
@interface UniversityRightView : UIView
@property(nonatomic,copy)UniversityRightViewwBlock  actionBlock;

+(instancetype)ViewWithBlock:(UniversityRightViewwBlock)actionBlock;
//带阴影
- (void)shadowWithFavorited:(BOOL)favorited;
- (void)shadowWithShare;
//不带阴影
- (void)noShadowWithFavorited:(BOOL)favorited;
- (void)noShadowWithShare;

@end
