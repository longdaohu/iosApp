//
//  LeftMenuHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 2016/11/1.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIImageView *userIconView;
@property(nonatomic,strong)NSDictionary *response;
-(void)headerViewWithUserLoginOut;
@end
