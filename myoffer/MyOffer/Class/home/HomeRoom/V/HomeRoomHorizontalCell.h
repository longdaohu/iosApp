//
//  HomeRoomHorizontalCell.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/7/25.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeRoomHorizontalCell : UITableViewCell
@property(nonatomic,assign)SectionGroupType sectionType;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,copy)void(^actionBlock)(NSInteger index,id item);
- (void)bottomLineHiden:(BOOL)hiden;
@end
