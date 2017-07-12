//
//  myofferAnchorButton.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/12.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^myofferAnchorButtonBlock)(UIButton *);

@interface myofferAnchorButton : UIView

@property(nonatomic,copy)NSString *title;

@property(nonatomic,copy)myofferAnchorButtonBlock actionBlock;

- (void)titleButtonOnClick;

@end
