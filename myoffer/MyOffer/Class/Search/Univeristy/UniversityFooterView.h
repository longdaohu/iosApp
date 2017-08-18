//
//  UniversityFooterView.h
//  myOffer
//
//  Created by xuewuguojie on 16/8/31.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^UniversityFooterViewBlock)(UIButton *sender);
@interface UniversityFooterView : UIView
@property(nonatomic,copy)NSString *uni_country;
@property(nonatomic,assign)NSInteger level;

@property(nonatomic,copy)UniversityFooterViewBlock  actionBlock;

- (void)footeTouchEnable:(BOOL)enable;

@end
