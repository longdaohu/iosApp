//
//  OneGroupView.h
//  OfferDemo
//
//  Created by xuewuguojie on 16/8/23.
//  Copyright © 2016年 xuewuguojie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityNewFrame.h"
typedef void(^OneGroupViewBlock)(NSString *subjectName,NSInteger index);
@interface UniGroupOneView : UIView
@property(nonatomic,strong)UniversityNewFrame *contentFrame;
@property(nonatomic,copy)OneGroupViewBlock     actionBlock;

@end
