//
//  MyOfferInputView.h
//  myOffer
//
//  Created by xuewuguojie on 2017/5/25.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WYLXGroup.h"
@class MyOfferInputView;

@protocol MyOfferInputViewDelegate   <NSObject>

- (void)cell:(MyOfferInputView *)cell textFieldDidBeginEditing:(UITextField *)textField;
- (void)cell:(MyOfferInputView *)cell textFieldDidEndEditing:(UITextField *)textField;
- (void)cell:(MyOfferInputView *)cell  textFieldShouldReturn:(UITextField *)textField;
- (void)cell:(MyOfferInputView *)cell  shouldChangeCharacters:(NSString *)content;
- (void)sendVertificationCodeWithCell:(MyOfferInputView *)cell;


@end
@interface MyOfferInputView : UIView
@property(nonatomic,strong)WYLXGroup *group;
@property(nonatomic,strong)UITextField *inputTF;
@property(nonatomic,weak)id<MyOfferInputViewDelegate> delegate;

- (void)checKTextFieldWithGroupValue;
- (void)changeVertificationCodeButtonEnable:(BOOL)enable;
- (void)vertificationTimerShow:(BOOL)show;

@end
