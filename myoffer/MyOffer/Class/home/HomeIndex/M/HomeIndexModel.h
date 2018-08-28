//
//  HomeIndexModel.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger,HomeIndexType){
    
    HomeIndexTypeDefault = 0,
    HomeIndexTypeYasi,
    HomeIndexTypeLXSQ,
    HomeIndexTypeFee,
    HomeIndexType51Room,
    HomeIndexTypeYouXue,
    HomeIndexTypeHYYM
};

@interface HomeIndexModel : NSObject
@property(nonatomic,copy)NSString *title;
@property (nonatomic, assign) Class destVC;
@property(nonatomic,copy)NSString *backgroudImageName;
@property(nonatomic,assign)HomeIndexType type;

- (instancetype)initWithTitle:(NSString *)title  backgroudImageName:(NSString *)imageName destVC:(Class)destvc indexType:(HomeIndexType)type;

@end
