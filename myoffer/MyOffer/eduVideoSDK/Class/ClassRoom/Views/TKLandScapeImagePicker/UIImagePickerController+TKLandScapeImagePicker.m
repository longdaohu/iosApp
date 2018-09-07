//
//  UIImagePickerController+TKLandScapeImagePicker.m
//  EduClassPad
//
//  Created by ifeng on 2017/10/24.
//  Copyright © 2017年 beijing. All rights reserved.
//

#import "UIImagePickerController+TKLandScapeImagePicker.h"

@implementation UIImagePickerController (TKLandScapeImagePicker)
#pragma mark 横竖屏
-(BOOL)shouldAutorotate{
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskLandscapeRight ;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationLandscapeRight;
}

@end
