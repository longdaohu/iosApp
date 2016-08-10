//
//  XWGJSubjectCollectionViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 16/2/29.
//  Copyright © 2016年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XWGJCatigorySubject;
@interface XWGJSubjectCollectionViewCell : UICollectionViewCell
@property(nonatomic,strong)XWGJCatigorySubject *subject;
@property(nonatomic,strong)NSDictionary *helpItem;


@end
