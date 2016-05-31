//
//  XprofileTableViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/8.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class XprofileTableViewCell;
@protocol XprofileTableViewCellDelegate  <NSObject>
-(void)XprofileTableViewCell:(XprofileTableViewCell *)tableViewCell  WithButtonItem:(UIButton *)sender;

@end
@interface XprofileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *countryTF;
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (weak, nonatomic) IBOutlet UITextField *applySubjectTF;
@property (weak, nonatomic) IBOutlet UITextField *universityTF;
@property (weak, nonatomic) IBOutlet UITextField *subjectedTF;
@property (weak, nonatomic) IBOutlet UITextField *GPATF;
@property (weak, nonatomic) IBOutlet UITextField *gradeTF;
@property (weak, nonatomic) IBOutlet UITextField *avgTF;
@property (weak, nonatomic) IBOutlet UITextField *lowTF;
@property(nonatomic,weak)id<XprofileTableViewCellDelegate>delegate;

@end
