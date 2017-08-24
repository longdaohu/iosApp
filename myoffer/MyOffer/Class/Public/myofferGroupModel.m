//
//  myofferGroupModel.m
//  myOffer
//
//  Created by xuewuguojie on 2017/8/24.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "myofferGroupModel.h"

@implementation myofferGroupModel

+ (instancetype)groupWithItems:(NSArray *)items  header:(NSString *)header{

    return  [myofferGroupModel groupWithItems:items header:header footer:nil accessory:nil];
}

+ (instancetype)groupWithItems:(NSArray *)items  header:(NSString *)header footer:(NSString *)footer{

    return  [myofferGroupModel groupWithItems:items header:header footer:footer accessory:nil];

}

+ (instancetype)groupWithItems:(NSArray *)items  header:(NSString *)header footer:(NSString *)footer accessory:(NSString *)accessory_title{

    myofferGroupModel *group = [[myofferGroupModel alloc] init];
    
    group.items = items;
    group.header_title = header;
    group.footer_title = footer;
    group.accesory_title = accessory_title;
    group.head_accesory_arrow = NO;
    
    return group;
    
}

- (void)setHeader_title:(NSString *)header_title{

    _header_title = header_title;
    
    if (header_title.length > 0 ) {
        
        self.section_header_height =  (self.items.count > 0 ) ? Section_header_Height_nomal : HEIGHT_ZERO;

    }else{
    
        self.section_header_height =   HEIGHT_ZERO ;
        
    }
    
    
}

- (void)setFooter_title:(NSString *)footer_title{

    _footer_title = footer_title;

    if (footer_title.length > 0 ) {
        
        self.section_footer_height =  (self.items.count > 0 ) ? Section_footer_Height_nomal : HEIGHT_ZERO;
        
    }else{
        
        self.section_footer_height =   HEIGHT_ZERO ;
        
    }
    
  
}

- (void)setSection_footer_height:(CGFloat)section_footer_height{

    _section_footer_height = section_footer_height;
    
    if (section_footer_height >  HEIGHT_ZERO) {
        
        self.havefooter = YES;
        
    }else{
        
        self.havefooter = NO;
        
    }
    
}

- (void)setSection_header_height:(CGFloat)section_header_height{

    _section_header_height = section_header_height;
    
    if (section_header_height >  HEIGHT_ZERO) {
        
        self.haveHeader = YES;
        
    }else{
        
        self.haveHeader = NO;
    }
    
}




@end
