//
//  ApplyViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/20/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface ApplyViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *_waitingTableView;
    IBOutlet UILabel *_selectCountLabel;
}

@property (weak, nonatomic) IBOutlet KDEasyTouchButton *submitBtn;  //提交按钮
@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *AlertLab;             //用户已提交审核，防止用户重复提交


- (IBAction)applyButtonPressed;
@property(nonatomic,assign)BOOL isFromMessage;


@end
