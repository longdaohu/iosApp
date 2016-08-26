//
//  UniversityRightView.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityRightView.h"

@implementation UniversityRightView

- (IBAction)onClick:(UIButton *)sender {
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
        
    }
    
}


-(void)setFavorited:(BOOL)favorited{

    _favorited = favorited;
    
     NSString *tilte = favorited ?@"收藏":@"NO藏";
    
    [self.favoriteBtn  setTitle:tilte forState:UIControlStateNormal];
    
}

 

@end
