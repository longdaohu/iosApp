//
//  ShareViewController.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/31.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversitydetailNew.h"

typedef void(^ShareViewBlock)();
@interface ShareViewController : UIViewController
@property(nonatomic,strong)NSDictionary *shareInfor;
@property(nonatomic,copy)ShareViewBlock actionBlock;
- (instancetype)initWithUniversity:(UniversitydetailNew *)Uni;
-(void)show;
@end
