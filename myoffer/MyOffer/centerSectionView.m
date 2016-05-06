//
//  centerSectionView.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/24.
//  Copyright © 2015年 UVIC. All rights reserved.
//


#import "centerSectionView.h"
@interface centerSectionView()
@property (weak, nonatomic) IBOutlet UIButton *pipeiButton;

@end
@implementation centerSectionView

-(void)awakeFromNib
{
    self.pipeiLabel.text = GDLocalizedString(@"center-match");
    self.favorLabel.text = GDLocalizedString(@"center-Favourite");
}

- (IBAction)centerSectionViewButtonPressed:(UIButton *)sender {
    
    if (self.sectionBlock) {
         self.sectionBlock(sender);
    }
}



@end
