//
//  KeyboardToolar.h
//  myOffer
//
//  Created by sara on 16/2/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWGJKeyboardToolar;
@protocol KeyboardToolarDelegate <NSObject>
-(void)KeyboardToolar:(XWGJKeyboardToolar *)toolView didClick:(UIBarButtonItem *)sender;
@end

@interface XWGJKeyboardToolar : UIView
@property(nonatomic,weak)id<KeyboardToolarDelegate> delegate;

@end
