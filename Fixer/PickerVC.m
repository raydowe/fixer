//
//  PickerVC.m
//  Fixer
//
//  Created by Raymond Dowe on 28/09/2016.
//  Copyright © 2016 Raymond Dowe. All rights reserved.
//

#import "PickerVC.h"

@interface PickerVC

@property (weak, nonatomic) IBOutlet UIPickerView *picker;

@end

@implementation PickerVC

@synthesize currencies;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.picker.dataSource = self;
    self.picker.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)doneTouchUpInside:(id)sender
{
}

@end