//
//  SearchResultCell.m
//  MyOffer
//
//  Created by Blankwonder on 6/10/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "SearchResultCell.h"

@implementation SearchResultCell

- (void)configureWithInfo:(NSDictionary *)info {
    [self configureWithInfo:info ranking:@"ranking_ti"];
}

- (void)configureWithInfo:(NSDictionary *)universityInfo ranking:(NSString *)ranking {
  
    self.titleLabel.text = universityInfo[@"name"];
    self.subtitleLabel.text = universityInfo[@"official_name"];

    self.descriptionLabel.text = [NSString stringWithFormat:@"%@：%@ - %@\n%@：%@", GDLocalizedString(@"UniversityDetail-005"), universityInfo[@"country"], universityInfo[@"state"], GDLocalizedString(@"ApplicationStutasVC-001"),[universityInfo[ranking] intValue] == 99999 ?GDLocalizedString(@"UniversityDetail-noRank") : universityInfo[ranking]];
     [self.logoView.logoImageView KD_setImageWithURL:universityInfo[@"logo"]];
}


@end
