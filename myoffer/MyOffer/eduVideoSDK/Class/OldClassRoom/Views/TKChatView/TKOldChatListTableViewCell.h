//
//  TKChatListTableViewCell.h
//  EduClass
//
//  Created by admin on 2018/6/6.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TKMacro.h"
#import "TKChatMessageModel.h"



@interface TKOldChatListTableViewCell : UITableViewCell

@property (nonatomic, strong) TKChatMessageModel *chatModel;
@property (nonatomic, strong) UIButton *iTranslationButton;//翻译按钮

+ (CGFloat)heightFromText:(NSString *)text withLimitWidth:(CGFloat)width;
+ (CGSize)sizeFromText:(NSString *)text withLimitHeight:(CGFloat)height Font:(UIFont*)aFont;
+ (CGSize)sizeFromText:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont;
+ (CGSize)sizeFromAttributedString:(NSString *)text withLimitWidth:(CGFloat)width Font:(UIFont*)aFont;

@end
