//
//  ResultTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 15/11/6.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UniversityFrame;
@protocol ResultTableViewCellDelegate <NSObject>

- (void)selectResultTableViewCellItem:(UIButton *)sender withUniversityInfo:(NSString *)universityID;

@end

@interface ResultTableViewCell : UITableViewCell

@property(nonatomic,assign)BOOL isStart;

@property(nonatomic,copy)NSString *optionOrderBy;

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property(nonatomic,weak)id<ResultTableViewCellDelegate> delegate;

+(instancetype)cellInitWithTableView:(UITableView *)tableView;

- (void)configureWithUniversityFrame:(UniversityFrame *)uniFrame;

- (void)configrationCellLefButtonWithTitle:(NSString  *)title imageName:(NSString *)imageName;

- (void)separatorLineShow:(BOOL)show;

@end




