//
//  XTextField.m
//  myOffer
//
//  Created by xuewuguojie on 16/3/28.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XTextField.h"

@implementation XTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
    }
    return self;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}


@end


