//
//  NSAttributedString+TKEmoji.h
//  EduClass
//
//  Created by lyy on 2017/11/16.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import <Foundation/Foundation.h>
//@import UIKit;
#import <UIKit/UIKit.h>
@interface NSAttributedString (TKEmoji)
+ (NSAttributedString *)emojiAttributedString:(NSString *)string withFont:(UIFont *)font withColor:(UIColor *)color;
+ (void)matchURL:(NSString *)text;
+ (NSString *)removeEmojiAttributedString:(NSString *)string withFont:(UIFont *)font withColor:(UIColor *)color;

+ (NSInteger)getStringLengthWithString:(NSString *)string;
@end
