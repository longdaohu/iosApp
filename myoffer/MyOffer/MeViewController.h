//
//  MeViewController.h
//  MyOffer
//
//  Created by Blankwonder on 6/7/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionTableViewController.h"

@interface MeViewController : ActionTableViewController {
    IBOutlet UIImageView *_avatarImageView;
    IBOutlet UILabel *_usernameLabel;
    IBOutlet UIButton *_logoutButton;
    IBOutlet UIImageView *_coverImageView;
}

- (IBAction)logout;


@end
