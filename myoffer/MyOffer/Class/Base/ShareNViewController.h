//
//  ShareNViewController.h
//  myOffer
//
//  Created by xuewuguojie on 2017/2/8.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversitydetailNew.h"

typedef void(^shareBlock)(NSString *item);

@interface ShareNViewController : UIViewController
@property(nonatomic,strong)NSDictionary *shareInfor;

+ (instancetype)shareView;
- (instancetype)initWithUniversity:(UniversitydetailNew *)Uni;

- (void)show;

@end
