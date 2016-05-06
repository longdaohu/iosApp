//
//  ResultTableViewCell.m
//  myOffer
//
//  Created by xuewuguojie on 15/11/6.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "ResultTableViewCell.h"
@interface ResultTableViewCell ()
@property(nonatomic,copy)NSString *universityID;
@end


@implementation ResultTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.selectButton addTarget:self action:@selector(selectCellID:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)configureWithInfo:(NSDictionary *)info {
    
    [self configureWithInfo:info ranking:@"ranking_ti"];
}

- (void)configureWithInfo:(NSDictionary *)universityInfo ranking:(NSString *)ranking {
   
    self.universityID = universityInfo[@"_id"];
    self.titleLabel.text = universityInfo[@"name"];
    self.subtitleLabel.text = universityInfo[@"official_name"];
    self.descriptionLabel.text = [NSString stringWithFormat:@"%@：%@ - %@\n%@：%@", GDLocalizedString(@"UniversityDetail-005"), universityInfo[@"country"], universityInfo[@"state"], GDLocalizedString(@"ApplicationStutasVC-001"),[universityInfo[ranking] intValue] == 99999 ?GDLocalizedString(@"UniversityDetail-noRank") : universityInfo[ranking]];
    [self.logoView.logoImageView KD_setImageWithURL:universityInfo[@"logo"]];
}


-(void)selectCellID:(UIButton *)sender
{

    if ([self.delegate respondsToSelector:@selector(selectResultTableViewCellItem:withUniversityInfo:)]) {
        
        [self.delegate selectResultTableViewCellItem:sender withUniversityInfo:self.universityID];
    }

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
