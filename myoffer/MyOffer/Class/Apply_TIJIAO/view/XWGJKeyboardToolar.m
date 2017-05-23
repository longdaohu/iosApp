//
//  KeyboardToolar.m
//  myOffer
//
//  Created by sara on 16/2/20.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XWGJKeyboardToolar.h"

@implementation XWGJKeyboardToolar

- (IBAction)KeyBoardHiden:(UIBarButtonItem *)sender {
    
    if (self.actionBlock) self.actionBlock(@"收起");
    
 
    if ([self.delegate respondsToSelector:@selector(KeyboardToolar:didClick:)]) {
        
 
        [self.delegate KeyboardToolar:self didClick:sender];
    }
}

- (IBAction)NextTextField:(UIBarButtonItem *)sender {
    
    if (self.actionBlock) self.actionBlock(@"下一个");
    
    
    if ([self.delegate respondsToSelector:@selector(KeyboardToolar:didClick:)]) {
        
 
        [self.delegate KeyboardToolar:self didClick:sender];
    }
}



@end
