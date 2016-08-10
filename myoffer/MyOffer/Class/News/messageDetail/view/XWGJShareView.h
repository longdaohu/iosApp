//
//  XWshareView.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ActionBlock)(UIButton *);
@interface XWGJShareView : UIView
@property(nonatomic,copy)ActionBlock ShareBlock;

+ (instancetype)shareView;
-(void)ShareButtonClickAndViewHiden:(BOOL)Hiden;

@end
