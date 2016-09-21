//
//  GlHeaderView.h
//  myOffer
//
//  Created by xuewuguojie on 16/9/19.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GlHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *subTitleLab;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *headerTitleLab;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *downconstraintHeight;
@property (weak, nonatomic) IBOutlet UIImageView *logoView;
@property(nonatomic,copy)NSString *subTitle;

@property(nonatomic,assign)CGFloat HeaderHeight;
@end
