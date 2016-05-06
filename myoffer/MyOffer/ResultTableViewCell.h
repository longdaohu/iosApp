//
//  ResultTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 15/11/6.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ResultTableViewCellDelegate <NSObject>

- (void)selectResultTableViewCellItem:(UIButton *)sender withUniversityInfo:(NSString *)universityID;

@end

@interface ResultTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet LogoView *logoView;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property(nonatomic,weak)id<ResultTableViewCellDelegate> delegate;

- (void)configureWithInfo:(NSDictionary *)info;
- (void)configureWithInfo:(NSDictionary *)info ranking:(NSString *)ranking;



@end




