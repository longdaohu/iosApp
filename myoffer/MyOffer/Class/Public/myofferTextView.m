//
//  myofferTextView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/2.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "myofferTextView.h"

@implementation myofferTextView

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
   
    [self resignFirstResponder];

    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}

@end
