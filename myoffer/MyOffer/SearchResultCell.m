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

- (void)configureWithInfo:(NSDictionary *)info ranking:(NSString *)ranking {
    self.titleLabel.text = info[@"name"];
    self.subtitleLabel.text = info[@"official_name"];

    self.descriptionLabel.text = [NSString stringWithFormat:@"所在地：%@ - %@\n综合排名：%@", info[@"country"], info[@"state"], [info[ranking] intValue] == 99999 ? @"暂无排名" : info[ranking]];
    [self.logoView.logoImageView KD_setImageWithURL:info[@"logo"]];
}

@end
