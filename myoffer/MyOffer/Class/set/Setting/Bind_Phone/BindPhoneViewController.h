//
//  BindPhoneViewController.h
//  myOffer
//
//  Created by xuewuguojie on 15/10/29.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface BindPhoneViewController : BaseViewController<UITableViewDataSource, UITableViewDelegate> {
    IBOutlet UITableView *_tableView;
}
@property(nonatomic,copy)NSString *phoneNumber;

@end