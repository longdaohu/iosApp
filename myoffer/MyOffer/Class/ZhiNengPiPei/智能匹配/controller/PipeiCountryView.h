//
//  PipeiCountryView.h
//  myOffer
//
//  Created by xuewuguojie on 2016/11/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PipeiCountryViewBlock)(NSString *);

@interface PipeiCountryView : UIView
@property(nonatomic,copy)NSString *contryName;
@property(nonatomic,copy)PipeiCountryViewBlock actionBlock;

- (void)countryIsSelected:(BOOL)select;

@end
