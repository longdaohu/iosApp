//
//  RoomAppointmentCell.m
//  MyOffer
//
//  Created by xuewuguojie on 2018/8/9.
//  Copyright © 2018年 UVIC. All rights reserved.
//

#import "RoomAppointmentCell.h"

@interface RoomAppointmentCell ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@property(nonatomic,strong) UIDatePicker *datePicker;
@property(nonatomic,weak) UITableView *tableView;

@end

@implementation RoomAppointmentCell

static NSString *identify = @"RoomAppointmentCell";

+ (instancetype)cellWithTableview:(UITableView *)tableView{

    RoomAppointmentCell *cell =[tableView dequeueReusableCellWithIdentifier:identify];
    if (!cell) {
        cell = Bundle(identify);
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.tableView = tableView;
    
    return cell;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.titleTF.layer.cornerRadius = CORNER_RADIUS;
    self.titleTF.layer.masksToBounds = true;
    self.titleTF.delegate = self;
    [self.titleTF addTarget:self action:@selector(titleChageValue:) forControlEvents:UIControlEventEditingChanged];
    self.titleTF.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 1)];
    self.titleTF.leftViewMode = UITextFieldViewModeAlways;
}

- (UIDatePicker *)datePicker{
    
    if (!_datePicker) {

        _datePicker = [[UIDatePicker alloc] init];
        _datePicker.datePickerMode = UIDatePickerModeDate;
        _datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
        _datePicker.calendar = [NSCalendar currentCalendar];
        _datePicker.minimumDate = [NSDate date];
        [_datePicker addTarget:self action:@selector(pickerChangeValue:) forControlEvents:UIControlEventValueChanged];

    }
    
    return _datePicker;
}

#pragma mark : UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
 
    if (self.item.groupType == EditTypeRoomUserTime && textField.text.length == 0) {
         textField.text = [self dateToString:[NSDate date]];
         self.item.content = textField.text;
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
 
    NSInteger index  =  [self.items indexOfObject:self.item];
 
    if (self.item == self.items.lastObject) {
        
    }else{
        RoomAppointmentCell *next_cell  = (RoomAppointmentCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:index+1 inSection:0]];
        [next_cell.titleTF becomeFirstResponder];
    }

    return YES;
}

- (void)titleChageValue:(UITextField *)textField{
 
    self.item.content = textField.text;
}

- (void)setItem:(WYLXGroup *)item{
    _item = item;
    
    self.titleLab.text = item.title;
 
    self.titleTF.text= item.content;

    UIKeyboardType type = UIKeyboardTypeDefault;
    switch (item.groupType) {
        case EditTypeRoomUserEmail:
            type = UIKeyboardTypeEmailAddress;
            break;
        case EditTypeRoomUserTime:
        {
            self.titleTF.inputView = self.datePicker;
            return;
        }
            break;
        case EditTypeRoomUserQQ:
            type = UIKeyboardTypeNumberPad;
            break;
        default:
            break;
    }
    self.titleTF.keyboardType = type;
    if (item == self.items.lastObject) {
        self.titleTF.returnKeyType = UIReturnKeyDone;
    }else{
        self.titleTF.returnKeyType = UIReturnKeyNext;
    }
    
}


- (void)pickerChangeValue:(UIDatePicker *)picker{

    NSDate *date = [picker date];
    self.titleTF.text = [self dateToString:date];
    [self titleChageValue:self.titleTF];

}

- (NSString *)dateToString:(NSDate *)date{
 
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //NSDate转NSString
    return  [dateFormatter stringFromDate:date];
}

@end
