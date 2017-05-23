//
//  WYLXGroup.h
//  myOffer
//
//  Created by xuewuguojie on 2016/12/15.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYLXGroup : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSString *placeHolder;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,copy)NSString *key;
@property(nonatomic,assign)BOOL spod;

@property(nonatomic,assign)CGRect titleFrame;
@property(nonatomic,assign)CGRect inputFrame;
@property(nonatomic,assign)CGRect spodFrame;
@property(nonatomic,assign)CGRect lineFrame;
@property(nonatomic,assign)CGFloat cell_Height;


+ (instancetype)groupWithTitle:(NSString *)title placeHolder:(NSString *)placeHolder content:(NSString *)content groupKey:(NSString *)key spod:(BOOL)spod;

@end
