# Vending Machine

## Info
Build a Vending Machine that behaves as follows

- Once an item is selected and the appropriate amount of money is inserted,  the vending machine should return the correct product 
- It should also return change if too much money is provided, or ask for more  money if insufficient funds have been inserted 
- The machine should take an initial load of products and change. The change  will be of denominations 1p, 2p, 5p, 10p, 20p, 50p, £1, £2 
- There should be a way of reloading either products or change at a later point
- The machine should keep track of the products and change that it contains

## Running the script
Run `ruby vend.rb` in the repository root

## Running the test suite
Run `bundle exec rspec` in the repository root

## Environment info
Coded and tested against Ruby 2.7.1 on OSX

## Approach
Overall, planning and coding of the vending machine implementation took about 5 hours in total.

Initial planning involved identifying main objects in the approach. It quickly became apparent that the main VendingMachine class will be required that will be initialized with many products and a change holder/coin stack which are expressed in their separate classes. I was in two minds about adding another layer of separation, that is creating full Inventory class to hold a list of products, but for sake of simplicity I left it out as I didn't feel it added much value and clarity.

Also, the first instinct was to try and express the vending machine using a finite state machine. Using some gem like [AASM](https://github.com/aasm/aasm) could accommodate that. While this seemed like quite an elegant and nice way to express moves between various states (selecting the input, entering money, dispensing product etc), ultimately I did not go down that route, aiming for simplicity and trying to avoid overengineering

All the development has been done in a test-driven manner using RSpec. I've started from building up the Product and ChangeHolder classes and then moved on VendingMachine implementation, implementing each step of the customer journey separately before combining flow into looped CLI journey in the end.

## Challenges

The main challenge in the task I've faced was around calculating the correct change to be returned to the user. I've initially started with a while loop approach but couldn't quite figure out a good way to break out of it in the edge case where correct change cannot be returned.

In the end, I found I fairly sensible solution but one that might not be the most performant as it will never exit the loop early and will try and find a required change going through all possible values, even when it's impossible to find one.

Another challenge and something that took a bit of research were figuring out how to test loops properly with rspec. I've managed to find `.to receive(:loop).and_yield` recipe that has proven to be a godsend. However, in reloading change and inventory implementations I have two loops and I couldn't quite figure out how to mock both of them, necessitating some superfluous conditionals in the code to make the tests pass.

## Next steps

There are quite a few things to improve in the code handling but I wanted to timebox the approach at around 5 hours and felt better to leave it in the simple, working state than spending even more time on it or possibly big refactors.

There's an error raised when required change cannot be dispensed. There's no handling for this in the VendingMachine flow so additional handling to catch the error (and returns coins to the user) would be needed at `return_change` method

VendingMachine overall does quite a few things now and could benefit from some refactoring and reworking like:
- extracting all the printed user messages to some separate class (Output? Console?) to keep the user-facing functionality more self-contained
- Reloading items and dispensing products could be extracted into its small service objects to handle reloading and transactions in a more sane manner, keeping the code out of VendingMachine
- Pretty much everything in VendingMachine class apart from `.vend` should be made into private methods as they really shouldn't be available to be called outside the established flow. I have avoided doing so at this point to avoid the overhead of testing those in RSpec and littering the tests with `.send(:method)` calls

Elsewhere ChangeHolder, includes a constant for valid coin values. This is also referenced in VendingMachine currently so could probably benefit from being extracted into separate constants module available to any class that might need it.
