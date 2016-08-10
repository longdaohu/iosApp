//
//  InputAccessoryToolBar.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/8.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputAccessoryToolBarDelegate <NSObject>

- (void)tabBarDidSelectWithItem:(UIBarButtonItem *)item;

@end

@interface InputAccessoryToolBar : UIView

@property (nonatomic, weak) id<InputAccessoryToolBarDelegate> delegate;


@end
