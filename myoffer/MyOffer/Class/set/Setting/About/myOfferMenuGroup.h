//
//  myOfferMenuGroup.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/1/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface myOfferMenuGroup : NSObject

@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)CGFloat header_heigh;
@property(nonatomic,assign)CGFloat footer_heigh;
@property(nonatomic,copy)NSString *more_title;
@property(nonatomic,assign)BOOL    arrow;
@property(nonatomic,strong)NSArray *items;
@property(nonatomic,copy)NSString *active;

+ (instancetype)itemWithTitle:(NSString *)title  items:(NSArray *)items moreTitle:(NSString *)moreTitle headerHeigh:(CGFloat) headerHeigh  footerHeigh:(CGFloat)footerHeigh  arrow:(BOOL)arrow  active:(NSString *)active;

@end


