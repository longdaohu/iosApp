//
//  XWGJnodataView.h
//  myOffer
//
//  Created by xuewuguojie on 16/1/6.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XWGJnodataView : UIView
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *DuangImageView;
+(instancetype)noDataView;

@end
