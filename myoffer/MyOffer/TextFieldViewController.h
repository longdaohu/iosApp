//
//  BBSingleTextFieldViewController.h
//  BuddyBook
//
//  Created by Blankwonder on 9/22/13.
//  Copyright (c) 2013 Suixing Tech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldViewController : BaseViewController {
    UITableViewCell *_cell;
}

@property (nonatomic) UITableView *tableView;

@property (nonatomic, readonly) UITextField *textField;
@property (nonatomic, copy) NSString *footerText;

@property (nonatomic, copy) void(^viewDidLoadAction)(TextFieldViewController *vc);
@property (nonatomic, copy) void(^doneAction)(TextFieldViewController *vc);

@end
