//
//  XUToolbar.m
//  myOffer
//
//  Created by xuewuguojie on 16/4/14.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "XUToolbar.h"

@implementation XUToolbar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.clearsContextBeforeDrawing = YES;

    }
    return self;
}

+(instancetype)toolBar{
    
   return [[self alloc] initWithFrame:CGRectMake(0, 20, XSCREEN_WIDTH, 44)];
}



// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 

@end
