//
//  filterContentFrame.h
//  myOffer
//
//  Created by sara on 16/5/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//
typedef enum {
    XcellStateRealHeight = 0,
    XcellStateBaseHeight,
    XcellStateHeightZero
} XcellState;

#import <Foundation/Foundation.h>
#import "FiltContent.h"

@interface FilterContentFrame : NSObject
@property(nonatomic,assign)CGRect logoFrame;
@property(nonatomic,assign)CGRect titleFrame;
@property(nonatomic,assign)CGRect detailFrame;
@property(nonatomic,assign)CGRect upFrame;
@property(nonatomic,assign)CGRect bgFrame;
@property(nonatomic,strong)NSArray *itemFrames;
@property(nonatomic,assign)CGFloat cellHeigh;
@property(nonatomic,assign)XcellState cellState;
@property(nonatomic,strong)NSArray *items;

@property(nonatomic,strong)FiltContent *content;


@end
