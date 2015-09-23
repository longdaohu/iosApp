//
//  NewVersionView.m
//  MyOffer
//
//  Created by xuewuguojie on 15/9/21.
//  Copyright (c) 2015年 UVIC. All rights reserved.
//

#import "NewVersionView.h"

@implementation NewVersionView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)onclick:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/cn/app/id1016290891?mt=8"]];
}



@end
