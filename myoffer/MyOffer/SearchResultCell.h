//
//  SearchResultCell.h
//  MyOffer
//
//  Created by Blankwonder on 6/10/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchResultCell : UITableViewCell

@property (nonatomic) IBOutlet LogoView *logoView;

@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UILabel *subtitleLabel;

@property (nonatomic) IBOutlet UILabel *descriptionLabel;

- (void)configureWithInfo:(NSDictionary *)info;
- (void)configureWithInfo:(NSDictionary *)info ranking:(NSString *)ranking;

@end
