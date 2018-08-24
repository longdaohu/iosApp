//
//  RoomCountryModel.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/22.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomCountryModel.h"

@interface RoomCountryModel()

@property(nonatomic,strong)NSArray *UKtitles;
@property(nonatomic,strong)NSArray *AUtitles;

@end

@implementation RoomCountryModel


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.current = KEY_UK;
    }
    return self;
}

- (NSArray *)UKtitles{
    
    if(!_UKtitles){
         _UKtitles  = [self.uk valueForKeyPath:@"header_title"];
    }
    
    return _UKtitles;
}

- (NSArray *)AUtitles{
    
    if(!_AUtitles){
        _AUtitles  = [self.au valueForKeyPath:@"header_title"];
    }
    
    return _AUtitles;
}

- (NSArray *)group{
  
    if ([self.current isEqualToString:KEY_UK]) {
        _group = self.uk;
    }else{
        _group = self.au;
    }
 
    return _group;
}



- (NSArray *)titles{
    
    NSArray *items = nil;
    if ([self.current isEqualToString:KEY_UK]) {
        items = self.UKtitles;
    }else{
        items = self.AUtitles;
    }
    
    return items;
}

@end
