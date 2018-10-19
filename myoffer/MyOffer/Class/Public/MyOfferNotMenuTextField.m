//
//  MyOfferNotMenuTextField.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/10/19.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "MyOfferNotMenuTextField.h"

@implementation MyOfferNotMenuTextField

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    return NO;
}


@end
