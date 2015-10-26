//
//  ApplySectionView.m
//  MyOffer
//
//  Created by xuewuguojie on 15/10/14.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ApplySectionView.h"

@interface ApplySectionView ()
@property (weak, nonatomic) IBOutlet LogoView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;


@end

@implementation ApplySectionView




- (IBAction)addButtonPressed:(UIButton *)sender {
    
    if (self.actionBlock) {
        self.actionBlock();
    }
}

-(void)setSectionInfo:(NSDictionary *)sectionInfo
{
    _sectionInfo = sectionInfo;
    
    self.titleLabel.text = sectionInfo[@"name"];
    self.subTitleLabel.text = sectionInfo[@"official_name"];
    
    
    self.rankLabel.text = [NSString stringWithFormat:@"%@：%@ - %@\n%@：%@", GDLocalizedString(@"UniversityDetail-005"), sectionInfo[@"country"], sectionInfo[@"state"], GDLocalizedString(@"ApplicationStutasVC-001"),[sectionInfo[@"ranking_ti"] intValue] == 99999 ? @"暂无排名" : sectionInfo[@"ranking_ti"]];
    
    [self.logoImageView.logoImageView KD_setImageWithURL:sectionInfo[@"logo"]];
    
}
@end
