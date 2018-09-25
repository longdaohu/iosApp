//
//  JHAnnotationView.h
//  newOffer
//
//  Created by xuewuguojie on 2018/9/21.
//  Copyright © 2018年 徐金辉. All rights reserved.
//

#import <Mapbox/Mapbox.h>

@interface JHAnnotationView : MGLAnnotationView
@property(nonatomic,copy)void(^actionBlock)(id sender);
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)BOOL annotationViewState;

@end
