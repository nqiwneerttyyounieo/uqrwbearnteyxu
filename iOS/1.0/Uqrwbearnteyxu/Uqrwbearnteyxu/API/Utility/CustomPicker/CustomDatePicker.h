//
//  CustomDatePicker.h
//  CustomDatePicker
//
//  Created by Rahul Mane on 12/01/16.
//  Copyright © 2016 Vignet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomDatePicker : UIView<UIPickerViewDataSource,UIPickerViewDelegate>
@property (nonatomic,weak)IBOutlet UIPickerView *pickerViewDate;


@end
