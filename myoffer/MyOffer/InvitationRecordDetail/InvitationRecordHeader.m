//
//  InvitationRecordHeader.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/5/23.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "InvitationRecordHeader.h"

@interface InvitationRecordHeader ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@end

@implementation InvitationRecordHeader
//
//- (void)awakeFromNib {
//    [super awakeFromNib];
//
//    NSLog(@"")
//}


- (void)setTitle:(NSString *)title{
    
    _title = title;
    self.titleLab.text = title;
    
}

@end


