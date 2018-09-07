//
//  UIImagePickerController+TKLandScapeImagePicker.m
//  EduClass
//
//  Created by lyy on 2018/5/22.
//  Copyright © 2018年 talkcloud. All rights reserved.
//

#import "UIImagePickerController+TKLandScapeImagePicker.h"

@implementation UIImagePickerController (TKLandScapeImagePicker)
- (BOOL)shouldAutorotate {
    
    return YES;
    
}



- (NSUInteger)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskAll;
    
}


@end
