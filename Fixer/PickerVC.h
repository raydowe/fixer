//
//  PickerVC.h
//  Fixer
//
//  Created by Raymond Dowe on 28/09/2016.
//  Copyright © 2016 Raymond Dowe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewDelegate <NSObject>
- (void)currencySelected:(NSString *)currency;
@end

@interface PickerVC : UIViewController

@property (weak, nonatomic) NSArray *currencies;
//@property (weak, nonatomic) int position;

@end
