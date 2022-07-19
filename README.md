
# Moneybox iOS Technical Challenge

## The Brief

To create a 'light' version of the Moneybox app that will allow existing users to login and check their account balance, as well as viewing their Moneybox savings. 
- To fork this repository to your private repository and implement the solution.
 
### The app should have
- A login screen to allow existing users to sign in
- A screen to show the accounts the user holds, e.g. ISA, GIA
- A screen to show some details of the account, including a simple button to add money to its moneybox.
- The button will add a fixed amount of £10. It should use the `POST /oneoffpayments` endpoint provided, and the account's Moneybox amount would be updated.

A prototype wireframe of all 3 screens is provided as a guideline. You are free to provide additional information if you wish.
![](wireframe.png)

### What we are looking for
 - Demonstration of coding style, conventions and patterns.
 - Use of autolayout (preferably UIKit).
 - Implementation of unit tests.
 - Any accessibility feature would be a bonus.
 - The application must run on iOS 13 or later.
 - The application must compile and run on Xcode and be debugged in Xcode's iOS simulator.
 - Any 3rd party library should be integrated using Swift Package Manager.
 - No persistence of the user is required.
 - Showcase what you can do.

### API Usage
You will find the Networking methods and Models for requests and responses ready-made in the project.

#### Base URL & Test User
The base URL for the moneybox sandbox environment is `https://api-test02.moneyboxapp.com/`. </br>
You can log into test your app using the following user:

|  Username          | Password         |
| ------------- | ------------- |
| test+ios2@moneyboxapp.com  | P455word12  |

#### API Call Hint
```
API.Login.login(request: request).fetchResponse(completion: completion)
```
request: Initialize your request model </br>
Completion: Handle your API success and failure cases

## Unit Tests
The MoneyBoxTests folder includes stubbed data to easily mock the responses needed for unit testing

#### Usage Hint
```
func fetchProducts(completion: @escaping ((Result<AccountResponse, Error>) -> Void)) {
    StubData.read(file: "Accounts", callback: completion)
}
```


### How to Submit your solution:
 - To share your Github repository with the user valerio-bettini.
 - (Optional) Provide a readme in markdown which outlines your solution.

## Good luck!
