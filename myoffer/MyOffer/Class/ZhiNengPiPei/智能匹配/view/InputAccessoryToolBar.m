//
//  InputAccessoryToolBar.m
//  myOffer
//
//  Created by xuewuguojie on 16/1/8.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "InputAccessoryToolBar.h"

@implementation InputAccessoryToolBar

- (IBAction)hidenItem:(UIBarButtonItem *)sender {
    
    if ([self.delegate respondsToSelector:@selector(tabBarDidSelectWithItem:)]) {
        [self.delegate tabBarDidSelectWithItem:sender];
    }
}

- (void)awakeFromNib{

    [super awakeFromNib];
    
     self.frame = CGRectMake(0, 0,XSCREEN_WIDTH, 44);

}



@end
