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


-(void)awakeFromNib{

    [super awakeFromNib];
    
    self.favoriteBtn.tag = RightViewItemStyleFavorited;
    self.shareBtn.tag = RightViewItemStyleFavorited;
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


- (void)shadowWithShare{

    [self.shareBtn setImage:[UIImage imageNamed:@"Uni_share_shadow"] forState:UIControlStateNormal];
    
}

- (void)noShadowWithShare{

    [self.shareBtn setImage:[UIImage imageNamed:@"Uni_share"] forState:UIControlStateNormal];
    
}


@end

