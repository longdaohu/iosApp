//
//  XWshareView.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^shareViewBlock)(UIButton *sender,BOOL isHiden);
@interface XWGJShareView : UIView
@property(nonatomic,copy)shareViewBlock actionBlock;
+ (instancetype)shareView;
-(void)ShareButtonClickAndViewHiden:(BOOL)Hiden;

@end
