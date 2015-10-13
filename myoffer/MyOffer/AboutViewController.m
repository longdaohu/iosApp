//
//  AboutViewController.m
//  MyOffer
//
//  Created by Blankwonder on 6/23/15.
//  Copyright (c) 2015 UVIC. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UITextView *engTextView;



@end

@implementation AboutViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.hidesBottomBarWhenPushed = YES;

    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
 
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _textView.textContainerInset = UIEdgeInsetsMake(15, 15, 15, 15);
    
    self.title = GDLocalizedString(@"Setting-004");//@"关于";

    
 
    
}

@end
