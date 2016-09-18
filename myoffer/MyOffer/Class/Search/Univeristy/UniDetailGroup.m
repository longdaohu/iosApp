//
//  UniDetailGroups.m
//  myOffer
//
//  Created by xuewuguojie on 16/9/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniDetailGroup.h"

@implementation UniDetailGroup

+(instancetype)groupWithTitle:(NSString *)title contentes:(NSArray *)items  andFooter:(BOOL)footer{

    UniDetailGroup *group = [[UniDetailGroup  alloc] init];
    
    group.HeaderTitle = title;
    
    group.items = items;

    if (items.count == 0) {
        
        group.HaveHeader = NO;
        group.HaveFooter = NO;
        
    }else{
        
        group.HaveFooter = footer;
        group.HaveHeader = title.length > 0;
    
    }
    
    return group;
}

-(void)setItems:(NSArray *)items{

    _items = items;
    
    if (items.count == 0) {
        
        self.HaveHeader = NO;
        self.HaveFooter = NO;
        
    }else{
          self.HaveHeader =  self.HeaderTitle.length > 0;
     }

    
}





@end
