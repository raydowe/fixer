//
//  MainVC.m
//  Fixer
//
//  Created by Raymond Dowe on 28/09/2016.
//  Copyright © 2016 Raymond Dowe. All rights reserved.
//

#import <MBProgressHUD.h>
#import <UNIRest.h>
#import "Constants.h"
#import "MainVC.h"
#import "PickerVC.h"

@interface MainVC () <PickerViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *amountInput;
@property (weak, nonatomic) IBOutlet UILabel *amountOutput;
@property (weak, nonatomic) IBOutlet UIButton *currencyInput;
@property (weak, nonatomic) IBOutlet UIButton *currencyOutput;
@property (weak, nonatomic) IBOutlet UILabel *updatedTime;

@end

@implementation MainVC

// variables
NSMutableDictionary *rates;
NSMutableArray *currencies;
NSString *currencyFrom;
NSString *currencyTo;

- (void)viewDidLoad
{
    currencyFrom = @"EUR";
    currencyTo = @"GBP";

    [super viewDidLoad];

    // add "done" to keyboard
    UIToolbar *keyboardToolbar = [[UIToolbar alloc] init];
    [keyboardToolbar sizeToFit];
    UIBarButtonItem *flexBarButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                             target:nil
                             action:nil];
    UIBarButtonItem *doneBarButton = [[UIBarButtonItem alloc]
        initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                             target:self
                             action:@selector(keyboardDonePressed)];
    keyboardToolbar.items = @[ flexBarButton, doneBarButton ];
    self.amountInput.inputAccessoryView = keyboardToolbar;
}

- (void)viewDidAppear:(BOOL)animated
{
    [self refreshRates];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)refreshTouchUpInside:(id)sender
{
    [self refreshRates];
}

- (void)refreshRates
{
    // show loading spinner
    [self showSpinner];

    // load new rates from api
    [[UNIRest get:^(UNISimpleRequest *request) {
      NSString *url = [NSString stringWithFormat:@"%@%@", URL_HOST, URL_LATEST];
      [request setUrl:url];
    }] asJsonAsync:^(UNIHTTPJsonResponse *response, NSError *error) {

      // hide spinner
      [self hideSpinner];

      // errors or not a 200 response
      NSInteger code = response.code;
      if (error != nil || code != 200)
      {
          [self showMessage:@"There was a problem loading current rates. Please check your internet connection and try again." withTitle:@"Error"];
      }
      else
      {
          // get rates from response
          UNIJsonNode *body = response.body;
          rates = [[body.object valueForKey:@"rates"] mutableCopy];

          // add base currency
          [rates setValue:@"1" forKey:@"EUR"];

          // get all currency keys
          currencies = [[rates allKeys] mutableCopy];

          [self ratesRefreshed];
      }
    }];
}

- (void)ratesRefreshed
{
    // set updated time
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH:mm"];
    NSString *currentTimestamp = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:[NSDate date]]];
    dispatch_async(dispatch_get_main_queue(), ^{
      [_updatedTime setText:currentTimestamp];
    });

    // update calculation
    [self updateCalculation];
}

- (void)currencySelected:(NSString *)currency forIndex:(NSInteger)index
{
    if (index == 0)
    {
        currencyFrom = currency;
        [self.currencyInput setTitle:currency forState:UIControlStateNormal];
    }
    else if (index == 1)
    {
        currencyTo = currency;
        [self.currencyOutput setTitle:currency forState:UIControlStateNormal];
    }

    [self updateCalculation];
}

- (IBAction)inputAmountChanged:(id)sender
{
    [self updateCalculation];
}

- (void)updateCalculation
{
    // convert currency
    NSDecimalNumber *amountInput = [NSDecimalNumber decimalNumberWithString:_amountInput.text];
    NSDecimalNumber *rateInput = [[NSDecimalNumber alloc] initWithDouble:[[rates valueForKey:currencyFrom] doubleValue]];
    NSDecimalNumber *rateOutput = [[NSDecimalNumber alloc] initWithDouble:[[rates valueForKey:currencyTo] doubleValue]];
    NSDecimalNumber *ratio = [rateOutput decimalNumberByDividingBy:rateInput];
    NSDecimalNumber *amountOutput = [ratio decimalNumberByMultiplyingBy:amountInput];

    // update label on main thread
    dispatch_async(dispatch_get_main_queue(), ^{
      _amountOutput.text = [amountOutput stringValue];
    });
}

- (void)showSpinner
{
    // show loading spinner
    dispatch_async(dispatch_get_main_queue(), ^{
      [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    });
}

- (void)showMessage:(NSString *)message withTitle:(NSString *)title
{
    // popup a message for a few seconds
    dispatch_async(dispatch_get_main_queue(), ^{
      MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
      hud.mode = MBProgressHUDModeText;
      hud.label.text = title;
      hud.detailsLabel.text = message;

      dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 4 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [hud hideAnimated:YES];
      });
    });
}

- (void)hideSpinner
{
    // hide spinner
    dispatch_async(dispatch_get_main_queue(), ^{
      [MBProgressHUD hideHUDForView:self.view animated:YES];
    });
}

- (void)keyboardDonePressed
{
    // hide keyboard
    [_amountInput resignFirstResponder];

    // update calculation
    [self updateCalculation];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // set properties on picker view for changing a specific currency
    PickerVC *pickerVC = [segue destinationViewController];
    [pickerVC setCurrentSelection:((UIButton *)sender).titleLabel.text];
    [pickerVC setCurrencies:currencies];
    [pickerVC setIndex:(([segue.identifier isEqualToString:@"currencyInput"]) ? 0 : 1)];
    pickerVC.delegate = self;
}

@end
