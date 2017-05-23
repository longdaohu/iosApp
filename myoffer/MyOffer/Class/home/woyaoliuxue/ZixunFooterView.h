//
//  ZixunFooterView.h
//  MyOffer
//
//  Created by xuewuguojie on 2017/5/22.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ZixunFooterViewBlock)(UIButton *);
@interface ZixunFooterView : UIView

@property(nonatomic,copy)ZixunFooterViewBlock actionBlock;

-(void)callButtonEnable:(BOOL)enable;
-(void)submitButtonEnable:(BOOL)enable;

@end
