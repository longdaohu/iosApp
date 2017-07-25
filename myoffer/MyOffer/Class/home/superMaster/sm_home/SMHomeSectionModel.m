//
//  SMHomeItem.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMHomeSectionModel.h"

@implementation SMHomeSectionModel

+ (instancetype)sectionInitWithTitle:(NSString *)title Items:(NSArray *)items  index:(NSInteger)index{

    SMHomeSectionModel *sectionM = [[SMHomeSectionModel alloc] init];
    sectionM.items = items;
    sectionM.index = index;
    sectionM.title = title;
    
    return sectionM;
}

- (void)setShowMore:(BOOL)showMore{

    _showMore = showMore;
    
    if (showMore) {
        
        self.items = self.item_all;
        
    }
 
}


//- (BOOL)have_footer{
//
//    return (self.item_all.count > 3) ? YES : NO;
//}
//


@end
