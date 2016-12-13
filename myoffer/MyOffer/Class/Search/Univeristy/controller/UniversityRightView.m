//
//  UniversityRightView.m
//  myOffer
//
//  Created by xuewuguojie on 16/8/26.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "UniversityRightView.h"
@interface UniversityRightView ()
//收藏
@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;
//分享
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation UniversityRightView

+ (instancetype)ViewWithBlock:(UniversityRightViewwBlock)actionBlock{

    UniversityRightView *rightView = [[NSBundle mainBundle] loadNibNamed:@"UniversityRightView" owner:self options:nil].lastObject;

    rightView.actionBlock = actionBlock;
    
    return  rightView;
}



- (void)awakeFromNib{

    [super awakeFromNib];
    
    self.favoriteBtn.tag = RightViewItemStyleFavorited;
    self.shareBtn.tag = RightViewItemStyleShare;
    
}

- (IBAction)onClick:(UIButton *)sender {
    
    if (self.actionBlock) {
        
        self.actionBlock(sender);
    }
}


- (void)shadowWithFavorited:(BOOL)favorited{

    NSString *shadowFavor = favorited ? @"Uni_favorshadow" : @"Uni_Unfavorshadow";
    
    [self.favoriteBtn  setImage:[UIImage imageNamed:shadowFavor] forState:UIControlStateNormal];
}


- (void)noShadowWithFavorited:(BOOL)favorited{
    
    NSString *nomalFavor = favorited ? @"Uni_Favor" : @"Uni_Unfavor";
    
    [self.favoriteBtn  setImage:[UIImage imageNamed:nomalFavor] forState:UIControlStateNormal];
}


- (void)shareButtonWithShadow:(BOOL)shadow{

    NSString *imageName= shadow ? @"Uni_share_shadow" : @"Uni_share";
    [self.shareBtn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];


}


@end

