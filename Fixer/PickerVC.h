//
//  PickerVC.h
//  Fixer
//
//  Created by Raymond Dowe on 28/09/2016.
//  Copyright © 2016 Raymond Dowe. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PickerVC;

@protocol PickerViewDelegate <NSObject>
- (void)currencySelected:(NSString *)currency forIndex:(NSInteger)index;
@end

@interface PickerVC : UIViewController
@property (weak, nonatomic) id<PickerViewDelegate> delegate;
- (void)setCurrencies:(NSArray *)newCurrencies;
- (void)setIndex:(NSInteger)newIndex;
- (void)setCurrentSelection:(NSString *)currencyName;
@end