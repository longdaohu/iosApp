//
//  WebViewController.h
//  myOffer
//
//  Created by xuewuguojie on 16/9/18.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController : BaseViewController
@property(nonatomic,copy)NSString *path;
@property(nonatomic,assign)CGRect webRect;
- (instancetype)initWithPath:(NSString *)path;

@end
