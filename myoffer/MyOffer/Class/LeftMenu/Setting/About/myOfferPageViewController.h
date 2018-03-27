//
//  myOfferPageViewController.h
//  MyOffer
//
//  Created by xuewuguojie on 2018/1/24.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,myOfferPageType){
    
    myOfferPageTypeAbout = 0,
    myOfferPageTypeHelp,
    myOfferPageTypeOther
};

@interface myOfferPageViewController : BaseViewController
@property(nonatomic,assign)myOfferPageType pageType;
@end
