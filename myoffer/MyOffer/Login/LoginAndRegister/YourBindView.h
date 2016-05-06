//
//  YourBindView.h
//  myOffer
//
//  Created by xuewuguojie on 16/3/25.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YourBindView;

@protocol YourBindViewDelegate  <NSObject>
-(void)YourBindView:(YourBindView *)bindView didClick:(UIButton *)sender;

@end


@interface YourBindView : UIView
@property (strong, nonatomic)  UITextField *Bind_PhoneFT;
@property (strong, nonatomic)  UITextField *Bind_PastWordFT;
@property(nonatomic,weak)id<YourBindViewDelegate> delegate;

@end
