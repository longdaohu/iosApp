//
//  searchSectionFootView.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UniversityNew.h"
typedef void(^universityBlock)(NSString *);
@interface searchSectionFootView : UIView
@property(nonatomic,copy)universityBlock actionBlock;

+ (instancetype)footerWithUniversity:(UniversityNew *)university actionBlock:(universityBlock)action;

@end
