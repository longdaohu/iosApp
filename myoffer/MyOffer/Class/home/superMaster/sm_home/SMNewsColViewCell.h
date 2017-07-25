//
//  SMNewsColViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 2017/7/19.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SMNewsFrame.h"

//typedef void(^SMNewsColViewCellBlock)(NSString *message_id);

@interface SMNewsColViewCell : UICollectionViewCell

//@property(nonatomic,copy)SMNewsColViewCellBlock actionBlock;

@property(nonatomic,strong)SMNewsFrame *newsFrame;

@end
