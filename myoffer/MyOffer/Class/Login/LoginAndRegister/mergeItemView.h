//
//  mergeItemView.h
//  myOffer
//
//  Created by xuewuguojie on 2016/11/10.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^mergeItemViewBlock)(NSString *itemID);
@interface mergeItemView : UIView
@property(nonatomic,strong)UIImageView *logoView;
@property(nonatomic,copy)mergeItemViewBlock actionBlock;
@property(nonatomic,strong)NSDictionary *itemAccout;

- (void)mergeItemViewInSelected:(BOOL)selected;

@end
