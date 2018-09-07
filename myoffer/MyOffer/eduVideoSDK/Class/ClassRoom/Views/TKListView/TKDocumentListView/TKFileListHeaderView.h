//
//  TKListHeaderView.h
//  EduClass
//
//  Created by lyy on 2018/4/26.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TKFileListHeaderViewDelegate <NSObject>
- (void)fileType:(FileType)type;
- (void)nameSort:(SortFileType)type;
- (void)typeSort:(SortFileType)type;
- (void)timeSort:(SortFileType)type;
@end

@interface TKFileListHeaderView : UIView

@property (nonatomic, weak)id<TKFileListHeaderViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame fileType:(BOOL)type;

@end
