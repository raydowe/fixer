# Fixer


This project is a simple implementation of a currency converter. Users can select an input and output currency from a pickview, enter an amount of input currency, and have their conversion displayed in an output currency.

The application involves two simple screens. The first is the main screen of the applicaiton. It displays when the rates were last updated from the fixer.io api, provides a button for refreshing the rates, and allows for an amount to be input.

The second screen is a pickerview for selecting a currency. A user can select both the input and output currencies on the main screen, and the pickerview screen allows them to make a selection.

As far as challanges, the implementation is fairly straight forward. Fixer.io allows for an option input and output to be provided, but I found this to be unnecessary. In the interest of speed and user experience, it's preferable to minimize the required connections as much as possible. The application requests current rates once on launch when they aren't available, and then only on request from the user. The base currency in Euros is added to the rate values and all the calculations are done in the application.

Frameworks utilized in this example include:


1.MBProgressHUD
  *[https://github.com/jdg/MBProgressHUD](https://github.com/jdg/MBProgressHUD)
  *For showing error messages and loading spinners
2.Unirest
  *[https://unirest.io](https://unirest.io)
  *For cosuming the REST api

