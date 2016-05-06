//
//  searchSectionHeadView.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^headBock)(UIButton *);
typedef void(^universityBlock)(NSString *);
@interface searchSectionHeadView : UIView
@property(nonatomic,strong)NSDictionary *universityInfo;
@property(nonatomic,copy)headBock followBlock;
@property(nonatomic,copy)universityBlock actionBlock;


@end
