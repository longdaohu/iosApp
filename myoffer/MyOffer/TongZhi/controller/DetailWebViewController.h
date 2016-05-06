//
//  NotiDetailViewController.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/30.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import "BaseViewController.h"

@interface DetailWebViewController : BaseViewController
@property(nonatomic,copy)NSString *notiID;
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,copy)NSString *path;
@property(nonatomic,strong)UIImage *navigationBgImage;

@end
