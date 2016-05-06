//
//  XmyShareButton.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/21.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

//typedef  NSString * (^optionBlcok)();
@interface XWGJShareButton : UIButton

+(instancetype)myShareButtonWithNormalTitle:( NSString *)normal_title seletedTitle:(NSString * )selected_title normalImage:(NSString *)normal_Image seletedImage:(NSString *)selected_Image actionType:(NSInteger)shareType;

@end
