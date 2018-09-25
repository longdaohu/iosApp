//
//  JHPointAnnotation.h
//  newOffer
//
//  Created by xuewuguojie on 2018/9/21.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import <Mapbox/Mapbox.h>

@interface JHPointAnnotation : MGLPointAnnotation
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)BOOL onSelected;
 @end
