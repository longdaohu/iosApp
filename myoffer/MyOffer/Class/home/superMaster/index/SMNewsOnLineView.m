//
//  SMNewsOnLineView.m
//  myOffer
//
//  Created by xuewuguojie on 2017/7/20.
//  Copyright © 2017年 UVIC. All rights reserved.
//

#import "SMNewsOnLineView.h"

@interface SMNewsOnLineView ()
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end

@implementation SMNewsOnLineView


- (void)setOffline:(NSDictionary *)offline{

    _offline = offline;
    
    self.titleLab.text = offline[@"main_title"];

}
- (IBAction)tap:(id)sender {
    
    if (self.actionBlock)  self.actionBlock(self.offline[@"offline_url"]);
    
}


@end
