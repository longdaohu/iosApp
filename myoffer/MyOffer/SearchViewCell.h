//
//  SearchViewCell.h
//  myOffer
//
//  Created by xuewuguojie on 15/12/17.
//  Copyright © 2015年 UVIC. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FiltContent;

typedef void(^cellButtonBlock)(UIButton *);
@interface SearchViewCell : UITableViewCell
@property(nonatomic,strong)FiltContent *fileritem;
@property(nonatomic,copy)cellButtonBlock actionBlock;

@end
