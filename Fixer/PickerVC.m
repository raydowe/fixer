//
//  PickerVC.m
//  Fixer
//
//  Created by Raymond Dowe on 28/09/2016.
//  Copyright © 2016 Raymond Dowe. All rights reserved.
//

#import "PickerVC.h"

@interface PickerVC () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation PickerVC

@synthesize delegate;

NSString *currency;
NSArray *pickerCurrencies;
NSInteger currencyIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.picker.dataSource = self;
    self.picker.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [self reloadSelection];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)setCurrencies:(NSArray *)newCurrencies
{
    NSArray *sortedArray = [newCurrencies sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    pickerCurrencies = sortedArray;
    [self.picker reloadAllComponents];
}

- (void)setIndex:(NSInteger)newIndex
{
    currencyIndex = newIndex;
}

- (void)setCurrentSelection:(NSString *)currencyName
{
    currency = currencyName;
}

- (void)reloadSelection
{
    int rowIndex = (int)[pickerCurrencies indexOfObject:currency];
    [self.picker selectRow:rowIndex inComponent:0 animated:NO];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return pickerCurrencies.count;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    currency = pickerCurrencies[row];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return pickerCurrencies[row];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (delegate != nil)
    {
        [delegate currencySelected:currency forIndex:currencyIndex];
    }
}

@end