//
//  HomeIndexModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/27.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "HomeIndexModel.h"

@implementation HomeIndexModel

- (instancetype)initWithTitle:(NSString *)title  backgroudImageName:(NSString *)imageName destVC:(Class)destvc indexType:(HomeIndexType)type{
    
    self = [super init];
    if (self) {
        
        self.title = title;
        self.backgroudImageName = imageName;
        self.type = type;
        if (destvc) {
            self.destVC = destvc;
        }else{
            self.destVC = [UIViewController class];
        }
        
    }
    
    return self;
}

@end
