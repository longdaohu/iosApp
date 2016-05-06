//
//  searchToolView.h
//  myOffer
//
//  Created by sara on 15/12/15.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^toolViewBlock)(UIButton *);
@interface searchToolView : UIView
@property(nonatomic,copy)toolViewBlock actionBlock;
@property(nonatomic,strong)XUButton *leftButton;
@end
