//
//  UniDetailGroups.m
//  myOffer
//
//  Created by xuewuguojie on 16/9/2.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniDetailGroup.h"

@implementation UniDetailGroup

+(instancetype)groupWithTitle:(NSString *)title contentes:(NSArray *)items groupType:(GroupType)type haveFooter:(BOOL)footer{

    UniDetailGroup *group = [[UniDetailGroup  alloc] init];
    
    group.type = type;
    
    group.header_title = title;
    
    group.section_footer_height =  footer ? Section_footer_Height_nomal: HEIGHT_ZERO;
    
    group.items = items;
    
    
    return group;

}


-(void)setItems:(NSArray *)items{

    _items = items;
    
    
    if (items.count > 0) {
   
        self.section_header_height =  self.header_title.length > 0 ? Section_header_Height_nomal : HEIGHT_ZERO;
        
    }else{
    
        self.section_footer_height = HEIGHT_ZERO;

    }
 
}





@end
