import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ur.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr'),
    Locale('ur')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Expense Manager'**
  String get appName;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @analytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analytics;

  /// No description provided for @records.
  ///
  /// In en, this message translates to:
  /// **'records'**
  String get records;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'transactions'**
  String get transactions;

  /// No description provided for @budgets.
  ///
  /// In en, this message translates to:
  /// **'Budgets'**
  String get budgets;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @changeTheme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get changeTheme;

  /// No description provided for @borrowed.
  ///
  /// In en, this message translates to:
  /// **'Borrowed'**
  String get borrowed;

  /// No description provided for @lent.
  ///
  /// In en, this message translates to:
  /// **'Lent'**
  String get lent;

  /// No description provided for @borrowedFrom.
  ///
  /// In en, this message translates to:
  /// **'Borrowed from'**
  String get borrowedFrom;

  /// No description provided for @lentTo.
  ///
  /// In en, this message translates to:
  /// **'Lent to'**
  String get lentTo;

  /// No description provided for @personName.
  ///
  /// In en, this message translates to:
  /// **'Person Name'**
  String get personName;

  /// No description provided for @returnDate.
  ///
  /// In en, this message translates to:
  /// **'Return Date'**
  String get returnDate;

  /// No description provided for @setReturnDate.
  ///
  /// In en, this message translates to:
  /// **'Set Return Date'**
  String get setReturnDate;

  /// No description provided for @debt.
  ///
  /// In en, this message translates to:
  /// **'Debt'**
  String get debt;

  /// No description provided for @payment.
  ///
  /// In en, this message translates to:
  /// **'Payment'**
  String get payment;

  /// No description provided for @partialPayment.
  ///
  /// In en, this message translates to:
  /// **'Partial Payment'**
  String get partialPayment;

  /// No description provided for @fullPayment.
  ///
  /// In en, this message translates to:
  /// **'Full Payment'**
  String get fullPayment;

  /// No description provided for @paid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get paid;

  /// No description provided for @remaining.
  ///
  /// In en, this message translates to:
  /// **'Remaining'**
  String get remaining;

  /// No description provided for @overdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// No description provided for @cash.
  ///
  /// In en, this message translates to:
  /// **'Cash'**
  String get cash;

  /// No description provided for @card.
  ///
  /// In en, this message translates to:
  /// **'Card'**
  String get card;

  /// No description provided for @bank.
  ///
  /// In en, this message translates to:
  /// **'Bank'**
  String get bank;

  /// No description provided for @wallet.
  ///
  /// In en, this message translates to:
  /// **'Wallet'**
  String get wallet;

  /// No description provided for @paymentMethod.
  ///
  /// In en, this message translates to:
  /// **'Payment Method'**
  String get paymentMethod;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @enterNote.
  ///
  /// In en, this message translates to:
  /// **'Enter a note'**
  String get enterNote;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @salary.
  ///
  /// In en, this message translates to:
  /// **'Salary'**
  String get salary;

  /// No description provided for @bonus.
  ///
  /// In en, this message translates to:
  /// **'Bonus'**
  String get bonus;

  /// No description provided for @commission.
  ///
  /// In en, this message translates to:
  /// **'Commission'**
  String get commission;

  /// No description provided for @tips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tips;

  /// No description provided for @business.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get business;

  /// No description provided for @freelance.
  ///
  /// In en, this message translates to:
  /// **'Freelance'**
  String get freelance;

  /// No description provided for @consulting.
  ///
  /// In en, this message translates to:
  /// **'Consulting'**
  String get consulting;

  /// No description provided for @selfEmployed.
  ///
  /// In en, this message translates to:
  /// **'Self Employed'**
  String get selfEmployed;

  /// No description provided for @investment.
  ///
  /// In en, this message translates to:
  /// **'Investment'**
  String get investment;

  /// No description provided for @dividends.
  ///
  /// In en, this message translates to:
  /// **'Dividends'**
  String get dividends;

  /// No description provided for @interest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get interest;

  /// No description provided for @capitalGains.
  ///
  /// In en, this message translates to:
  /// **'Capital Gains'**
  String get capitalGains;

  /// No description provided for @cryptocurrency.
  ///
  /// In en, this message translates to:
  /// **'Cryptocurrency'**
  String get cryptocurrency;

  /// No description provided for @rental.
  ///
  /// In en, this message translates to:
  /// **'Rental'**
  String get rental;

  /// No description provided for @realEstate.
  ///
  /// In en, this message translates to:
  /// **'Real Estate'**
  String get realEstate;

  /// No description provided for @royalties.
  ///
  /// In en, this message translates to:
  /// **'Royalties'**
  String get royalties;

  /// No description provided for @pension.
  ///
  /// In en, this message translates to:
  /// **'Pension'**
  String get pension;

  /// No description provided for @socialSecurity.
  ///
  /// In en, this message translates to:
  /// **'Social Security'**
  String get socialSecurity;

  /// No description provided for @annuity.
  ///
  /// In en, this message translates to:
  /// **'Annuity'**
  String get annuity;

  /// No description provided for @trustFund.
  ///
  /// In en, this message translates to:
  /// **'Trust Fund'**
  String get trustFund;

  /// No description provided for @gift.
  ///
  /// In en, this message translates to:
  /// **'Gift'**
  String get gift;

  /// No description provided for @inheritance.
  ///
  /// In en, this message translates to:
  /// **'Inheritance'**
  String get inheritance;

  /// No description provided for @lottery.
  ///
  /// In en, this message translates to:
  /// **'Lottery'**
  String get lottery;

  /// No description provided for @refund.
  ///
  /// In en, this message translates to:
  /// **'Refund'**
  String get refund;

  /// No description provided for @cashback.
  ///
  /// In en, this message translates to:
  /// **'Cashback'**
  String get cashback;

  /// No description provided for @award.
  ///
  /// In en, this message translates to:
  /// **'Award'**
  String get award;

  /// No description provided for @grant.
  ///
  /// In en, this message translates to:
  /// **'Grant'**
  String get grant;

  /// No description provided for @scholarship.
  ///
  /// In en, this message translates to:
  /// **'Scholarship'**
  String get scholarship;

  /// No description provided for @sideHustle.
  ///
  /// In en, this message translates to:
  /// **'Side Hustle'**
  String get sideHustle;

  /// No description provided for @otherIncome.
  ///
  /// In en, this message translates to:
  /// **'Other Income'**
  String get otherIncome;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @groceries.
  ///
  /// In en, this message translates to:
  /// **'Groceries'**
  String get groceries;

  /// No description provided for @diningout.
  ///
  /// In en, this message translates to:
  /// **'Dining Out'**
  String get diningout;

  /// No description provided for @fastFood.
  ///
  /// In en, this message translates to:
  /// **'Fast Food'**
  String get fastFood;

  /// No description provided for @cafe.
  ///
  /// In en, this message translates to:
  /// **'Cafe'**
  String get cafe;

  /// No description provided for @delivery.
  ///
  /// In en, this message translates to:
  /// **'Delivery'**
  String get delivery;

  /// No description provided for @transport.
  ///
  /// In en, this message translates to:
  /// **'Transport'**
  String get transport;

  /// No description provided for @fuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuel;

  /// No description provided for @parking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get parking;

  /// No description provided for @publicTransit.
  ///
  /// In en, this message translates to:
  /// **'Public Transit'**
  String get publicTransit;

  /// No description provided for @taxi.
  ///
  /// In en, this message translates to:
  /// **'Taxi'**
  String get taxi;

  /// No description provided for @carMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Car Maintenance'**
  String get carMaintenance;

  /// No description provided for @vehicleInsurance.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Insurance'**
  String get vehicleInsurance;

  /// No description provided for @shopping.
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// No description provided for @clothing.
  ///
  /// In en, this message translates to:
  /// **'Clothing'**
  String get clothing;

  /// No description provided for @electronics.
  ///
  /// In en, this message translates to:
  /// **'Electronics'**
  String get electronics;

  /// No description provided for @furniture.
  ///
  /// In en, this message translates to:
  /// **'Furniture'**
  String get furniture;

  /// No description provided for @cosmetics.
  ///
  /// In en, this message translates to:
  /// **'Cosmetics'**
  String get cosmetics;

  /// No description provided for @accessories.
  ///
  /// In en, this message translates to:
  /// **'Accessories'**
  String get accessories;

  /// No description provided for @bills.
  ///
  /// In en, this message translates to:
  /// **'Bills'**
  String get bills;

  /// No description provided for @electricity.
  ///
  /// In en, this message translates to:
  /// **'Electricity'**
  String get electricity;

  /// No description provided for @water.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get water;

  /// No description provided for @gas.
  ///
  /// In en, this message translates to:
  /// **'Gas'**
  String get gas;

  /// No description provided for @internet.
  ///
  /// In en, this message translates to:
  /// **'Internet'**
  String get internet;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @streaming.
  ///
  /// In en, this message translates to:
  /// **'Streaming'**
  String get streaming;

  /// No description provided for @rent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get rent;

  /// No description provided for @mortgage.
  ///
  /// In en, this message translates to:
  /// **'Mortgage'**
  String get mortgage;

  /// No description provided for @propertyTax.
  ///
  /// In en, this message translates to:
  /// **'Property Tax'**
  String get propertyTax;

  /// No description provided for @homeRepair.
  ///
  /// In en, this message translates to:
  /// **'Home Repair'**
  String get homeRepair;

  /// No description provided for @hoaFees.
  ///
  /// In en, this message translates to:
  /// **'HOA Fees'**
  String get hoaFees;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @pharmacy.
  ///
  /// In en, this message translates to:
  /// **'Pharmacy'**
  String get pharmacy;

  /// No description provided for @dental.
  ///
  /// In en, this message translates to:
  /// **'Dental'**
  String get dental;

  /// No description provided for @vision.
  ///
  /// In en, this message translates to:
  /// **'Vision'**
  String get vision;

  /// No description provided for @gym.
  ///
  /// In en, this message translates to:
  /// **'Gym'**
  String get gym;

  /// No description provided for @yoga.
  ///
  /// In en, this message translates to:
  /// **'Yoga'**
  String get yoga;

  /// No description provided for @sports.
  ///
  /// In en, this message translates to:
  /// **'Sports'**
  String get sports;

  /// No description provided for @entertainment.
  ///
  /// In en, this message translates to:
  /// **'Entertainment'**
  String get entertainment;

  /// No description provided for @movies.
  ///
  /// In en, this message translates to:
  /// **'Movies'**
  String get movies;

  /// No description provided for @concerts.
  ///
  /// In en, this message translates to:
  /// **'Concerts'**
  String get concerts;

  /// No description provided for @games.
  ///
  /// In en, this message translates to:
  /// **'Games'**
  String get games;

  /// No description provided for @hobbies.
  ///
  /// In en, this message translates to:
  /// **'Hobbies'**
  String get hobbies;

  /// No description provided for @books.
  ///
  /// In en, this message translates to:
  /// **'Books'**
  String get books;

  /// No description provided for @music.
  ///
  /// In en, this message translates to:
  /// **'Music'**
  String get music;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @hotel.
  ///
  /// In en, this message translates to:
  /// **'Hotel'**
  String get hotel;

  /// No description provided for @flights.
  ///
  /// In en, this message translates to:
  /// **'Flights'**
  String get flights;

  /// No description provided for @vacation.
  ///
  /// In en, this message translates to:
  /// **'Vacation'**
  String get vacation;

  /// No description provided for @tours.
  ///
  /// In en, this message translates to:
  /// **'Tours'**
  String get tours;

  /// No description provided for @education.
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// No description provided for @tuition.
  ///
  /// In en, this message translates to:
  /// **'Tuition'**
  String get tuition;

  /// No description provided for @courses.
  ///
  /// In en, this message translates to:
  /// **'Courses'**
  String get courses;

  /// No description provided for @supplies.
  ///
  /// In en, this message translates to:
  /// **'Supplies'**
  String get supplies;

  /// No description provided for @insurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get insurance;

  /// No description provided for @healthInsurance.
  ///
  /// In en, this message translates to:
  /// **'Health Insurance'**
  String get healthInsurance;

  /// No description provided for @lifeInsurance.
  ///
  /// In en, this message translates to:
  /// **'Life Insurance'**
  String get lifeInsurance;

  /// No description provided for @homeInsurance.
  ///
  /// In en, this message translates to:
  /// **'Home Insurance'**
  String get homeInsurance;

  /// No description provided for @personalCare.
  ///
  /// In en, this message translates to:
  /// **'Personal Care'**
  String get personalCare;

  /// No description provided for @haircut.
  ///
  /// In en, this message translates to:
  /// **'Haircut'**
  String get haircut;

  /// No description provided for @spa.
  ///
  /// In en, this message translates to:
  /// **'Spa'**
  String get spa;

  /// No description provided for @skincare.
  ///
  /// In en, this message translates to:
  /// **'Skincare'**
  String get skincare;

  /// No description provided for @pets.
  ///
  /// In en, this message translates to:
  /// **'Pets'**
  String get pets;

  /// No description provided for @petFood.
  ///
  /// In en, this message translates to:
  /// **'Pet Food'**
  String get petFood;

  /// No description provided for @vet.
  ///
  /// In en, this message translates to:
  /// **'Vet'**
  String get vet;

  /// No description provided for @petSupplies.
  ///
  /// In en, this message translates to:
  /// **'Pet Supplies'**
  String get petSupplies;

  /// No description provided for @savings.
  ///
  /// In en, this message translates to:
  /// **'Savings'**
  String get savings;

  /// No description provided for @loanPayment.
  ///
  /// In en, this message translates to:
  /// **'Loan Payment'**
  String get loanPayment;

  /// No description provided for @creditCard.
  ///
  /// In en, this message translates to:
  /// **'Credit Card'**
  String get creditCard;

  /// No description provided for @bankFees.
  ///
  /// In en, this message translates to:
  /// **'Bank Fees'**
  String get bankFees;

  /// No description provided for @charity.
  ///
  /// In en, this message translates to:
  /// **'Charity'**
  String get charity;

  /// No description provided for @donation.
  ///
  /// In en, this message translates to:
  /// **'Donation'**
  String get donation;

  /// No description provided for @gifts.
  ///
  /// In en, this message translates to:
  /// **'Gifts'**
  String get gifts;

  /// No description provided for @kids.
  ///
  /// In en, this message translates to:
  /// **'Kids'**
  String get kids;

  /// No description provided for @childcare.
  ///
  /// In en, this message translates to:
  /// **'Childcare'**
  String get childcare;

  /// No description provided for @toys.
  ///
  /// In en, this message translates to:
  /// **'Toys'**
  String get toys;

  /// No description provided for @activities.
  ///
  /// In en, this message translates to:
  /// **'Activities'**
  String get activities;

  /// No description provided for @subscriptions.
  ///
  /// In en, this message translates to:
  /// **'Subscriptions'**
  String get subscriptions;

  /// No description provided for @software.
  ///
  /// In en, this message translates to:
  /// **'Software'**
  String get software;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @tax.
  ///
  /// In en, this message translates to:
  /// **'Tax'**
  String get tax;

  /// No description provided for @otherExpense.
  ///
  /// In en, this message translates to:
  /// **'Other Expense'**
  String get otherExpense;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @single.
  ///
  /// In en, this message translates to:
  /// **'Single'**
  String get single;

  /// No description provided for @multiple.
  ///
  /// In en, this message translates to:
  /// **'Multiple'**
  String get multiple;

  /// No description provided for @categoriesSelected.
  ///
  /// In en, this message translates to:
  /// **'Categories Selected'**
  String get categoriesSelected;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisYear.
  ///
  /// In en, this message translates to:
  /// **'This Year'**
  String get thisYear;

  /// No description provided for @recurring.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurring;

  /// No description provided for @enterPin.
  ///
  /// In en, this message translates to:
  /// **'Enter Your PIN'**
  String get enterPin;

  /// No description provided for @enterPinSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enter your 4-digit PIN to continue'**
  String get enterPinSubtitle;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @enterPasswordError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get enterPasswordError;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmail;

  /// No description provided for @enterEmailError.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterEmailError;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterEmail;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @quickLogin.
  ///
  /// In en, this message translates to:
  /// **'Quick Login'**
  String get quickLogin;

  /// No description provided for @enterYourPassword.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterYourPassword;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\"t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Track Your Expenses'**
  String get onboardingTitle1;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Record and categorize all your daily expenses effortlessly in one place'**
  String get onboardingDesc1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Smart Budgeting'**
  String get onboardingTitle2;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Set personalized budgets and get insights with beautiful analytics'**
  String get onboardingDesc2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Detailed Reports'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive analytics to understand your financial health better'**
  String get onboardingDesc3;

  /// No description provided for @onboardingTitle4.
  ///
  /// In en, this message translates to:
  /// **'Secure & Private'**
  String get onboardingTitle4;

  /// No description provided for @onboardingDesc4.
  ///
  /// In en, this message translates to:
  /// **'Your data protected with enterprise-grade security. Privacy is our top priority'**
  String get onboardingDesc4;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @selectExpenseCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Expense Category'**
  String get selectExpenseCategory;

  /// No description provided for @errorPrefix.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorPrefix;

  /// No description provided for @balancePrefix.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balancePrefix;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All →'**
  String get viewAll;

  /// No description provided for @activeDebts.
  ///
  /// In en, this message translates to:
  /// **'Active Debts'**
  String get activeDebts;

  /// No description provided for @addDebt.
  ///
  /// In en, this message translates to:
  /// **'Add Debt'**
  String get addDebt;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @youOwe.
  ///
  /// In en, this message translates to:
  /// **'You Owe'**
  String get youOwe;

  /// No description provided for @youreOwed.
  ///
  /// In en, this message translates to:
  /// **'You\"re Owed'**
  String get youreOwed;

  /// No description provided for @debtTransactions.
  ///
  /// In en, this message translates to:
  /// **'Debt Transactions'**
  String get debtTransactions;

  /// No description provided for @allTransactions.
  ///
  /// In en, this message translates to:
  /// **'All Transactions'**
  String get allTransactions;

  /// No description provided for @searchByPerson.
  ///
  /// In en, this message translates to:
  /// **'Search by person or category…'**
  String get searchByPerson;

  /// No description provided for @searchByCategory.
  ///
  /// In en, this message translates to:
  /// **'Search by category…'**
  String get searchByCategory;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @clearAll.
  ///
  /// In en, this message translates to:
  /// **'Clear all'**
  String get clearAll;

  /// No description provided for @noDebtTransactions.
  ///
  /// In en, this message translates to:
  /// **'No debt transactions found'**
  String get noDebtTransactions;

  /// No description provided for @noTransactions.
  ///
  /// In en, this message translates to:
  /// **'No transactions found'**
  String get noTransactions;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustingFilters;

  /// No description provided for @debtTransaction.
  ///
  /// In en, this message translates to:
  /// **'Debt Transaction'**
  String get debtTransaction;

  /// No description provided for @settled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settled;

  /// No description provided for @daysOverdue.
  ///
  /// In en, this message translates to:
  /// **'days overdue'**
  String get daysOverdue;

  /// No description provided for @transaction.
  ///
  /// In en, this message translates to:
  /// **'Transaction'**
  String get transaction;

  /// No description provided for @noActiveDebts.
  ///
  /// In en, this message translates to:
  /// **'No active debts'**
  String get noActiveDebts;

  /// No description provided for @debtManagementStarts.
  ///
  /// In en, this message translates to:
  /// **'Your debt management starts here'**
  String get debtManagementStarts;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @startTracking.
  ///
  /// In en, this message translates to:
  /// **'Start tracking your expenses'**
  String get startTracking;

  /// No description provided for @paymentHistory.
  ///
  /// In en, this message translates to:
  /// **'Payment History'**
  String get paymentHistory;

  /// No description provided for @payments.
  ///
  /// In en, this message translates to:
  /// **'payments'**
  String get payments;

  /// No description provided for @addPayment.
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get addPayment;

  /// No description provided for @fullyPaidOff.
  ///
  /// In en, this message translates to:
  /// **'Fully paid off 🎉'**
  String get fullyPaidOff;

  /// No description provided for @repaid.
  ///
  /// In en, this message translates to:
  /// **'% repaid'**
  String get repaid;

  /// No description provided for @cleared.
  ///
  /// In en, this message translates to:
  /// **'Cleared'**
  String get cleared;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @totalDebt.
  ///
  /// In en, this message translates to:
  /// **'Total Debt'**
  String get totalDebt;

  /// No description provided for @paidOff.
  ///
  /// In en, this message translates to:
  /// **'Paid off!'**
  String get paidOff;

  /// No description provided for @remainingAmount.
  ///
  /// In en, this message translates to:
  /// **'remaining'**
  String get remainingAmount;

  /// No description provided for @percentPaid.
  ///
  /// In en, this message translates to:
  /// **'% Paid'**
  String get percentPaid;

  /// No description provided for @due.
  ///
  /// In en, this message translates to:
  /// **'Due:'**
  String get due;

  /// No description provided for @addPaymentTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get addPaymentTitle;

  /// No description provided for @enterPaymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter payment amount'**
  String get enterPaymentAmount;

  /// No description provided for @pleaseEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter amount'**
  String get pleaseEnterAmount;

  /// No description provided for @pleaseEnterValidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get pleaseEnterValidAmount;

  /// No description provided for @amountExceedsDebt.
  ///
  /// In en, this message translates to:
  /// **'Amount exceeds remaining debt'**
  String get amountExceedsDebt;

  /// No description provided for @paymentDate.
  ///
  /// In en, this message translates to:
  /// **'Payment Date'**
  String get paymentDate;

  /// No description provided for @noteOptional.
  ///
  /// In en, this message translates to:
  /// **'Note (Optional)'**
  String get noteOptional;

  /// No description provided for @addANote.
  ///
  /// In en, this message translates to:
  /// **'Add a note'**
  String get addANote;

  /// No description provided for @savePayment.
  ///
  /// In en, this message translates to:
  /// **'Save Payment'**
  String get savePayment;

  /// No description provided for @deletePayment.
  ///
  /// In en, this message translates to:
  /// **'Delete Payment'**
  String get deletePayment;

  /// No description provided for @deletePaymentConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this payment? This action cannot be undone.'**
  String get deletePaymentConfirm;

  /// No description provided for @deleteTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete payment'**
  String get deleteTooltip;

  /// No description provided for @noPaymentsYet.
  ///
  /// In en, this message translates to:
  /// **'No Payments Yet'**
  String get noPaymentsYet;

  /// No description provided for @addFirstPayment.
  ///
  /// In en, this message translates to:
  /// **'Tap the + button below to add your first payment'**
  String get addFirstPayment;

  /// No description provided for @trackRepayments.
  ///
  /// In en, this message translates to:
  /// **'Track your debt repayments easily'**
  String get trackRepayments;

  /// No description provided for @myBudgets.
  ///
  /// In en, this message translates to:
  /// **'My Budgets'**
  String get myBudgets;

  /// No description provided for @searchBudgets.
  ///
  /// In en, this message translates to:
  /// **'Search budgets…'**
  String get searchBudgets;

  /// No description provided for @clear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// No description provided for @expired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get expired;

  /// No description provided for @archived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archived;

  /// No description provided for @totalRemaining.
  ///
  /// In en, this message translates to:
  /// **'Total Remaining'**
  String get totalRemaining;

  /// No description provided for @overBudget.
  ///
  /// In en, this message translates to:
  /// **'Over Budget'**
  String get overBudget;

  /// No description provided for @used.
  ///
  /// In en, this message translates to:
  /// **'% used'**
  String get used;

  /// No description provided for @spent.
  ///
  /// In en, this message translates to:
  /// **'spent'**
  String get spent;

  /// No description provided for @noBudgetsYet.
  ///
  /// In en, this message translates to:
  /// **'No budgets yet'**
  String get noBudgetsYet;

  /// No description provided for @createFirstBudget.
  ///
  /// In en, this message translates to:
  /// **'Create your first budget below'**
  String get createFirstBudget;

  /// No description provided for @noActiveBudgets.
  ///
  /// In en, this message translates to:
  /// **'No active budgets'**
  String get noActiveBudgets;

  /// No description provided for @tapNewBudget.
  ///
  /// In en, this message translates to:
  /// **'Tap \"New Budget\" to get started'**
  String get tapNewBudget;

  /// No description provided for @noExpiredBudgets.
  ///
  /// In en, this message translates to:
  /// **'No expired budgets'**
  String get noExpiredBudgets;

  /// No description provided for @allBudgetsOnTrack.
  ///
  /// In en, this message translates to:
  /// **'All your budgets are on track!'**
  String get allBudgetsOnTrack;

  /// No description provided for @nothingArchived.
  ///
  /// In en, this message translates to:
  /// **'Nothing archived'**
  String get nothingArchived;

  /// No description provided for @archivedWillShowHere.
  ///
  /// In en, this message translates to:
  /// **'Archived budgets will show here'**
  String get archivedWillShowHere;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @overBy.
  ///
  /// In en, this message translates to:
  /// **'Over by'**
  String get overBy;

  /// No description provided for @daysLeft.
  ///
  /// In en, this message translates to:
  /// **'days left'**
  String get daysLeft;

  /// No description provided for @expiredDaysAgo.
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get expiredDaysAgo;

  /// No description provided for @viewDetails.
  ///
  /// In en, this message translates to:
  /// **'View Details'**
  String get viewDetails;

  /// No description provided for @newBudget.
  ///
  /// In en, this message translates to:
  /// **'New Budget'**
  String get newBudget;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get monthlyBudget;

  /// No description provided for @projectBudget.
  ///
  /// In en, this message translates to:
  /// **'Project Budget'**
  String get projectBudget;

  /// No description provided for @customBudget.
  ///
  /// In en, this message translates to:
  /// **'Custom Budget'**
  String get customBudget;

  /// No description provided for @budgetName.
  ///
  /// In en, this message translates to:
  /// **'Budget Name'**
  String get budgetName;

  /// No description provided for @budgetNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g., Monthly Groceries'**
  String get budgetNameHint;

  /// No description provided for @start.
  ///
  /// In en, this message translates to:
  /// **'Start'**
  String get start;

  /// No description provided for @end.
  ///
  /// In en, this message translates to:
  /// **'End'**
  String get end;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @dates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// No description provided for @style.
  ///
  /// In en, this message translates to:
  /// **'Style'**
  String get style;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @quickSelect.
  ///
  /// In en, this message translates to:
  /// **'Quick Select'**
  String get quickSelect;

  /// No description provided for @budgetType.
  ///
  /// In en, this message translates to:
  /// **'Budget Type'**
  String get budgetType;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @project.
  ///
  /// In en, this message translates to:
  /// **'Project'**
  String get project;

  /// No description provided for @custom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get custom;

  /// No description provided for @duration.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get duration;

  /// No description provided for @pleaseEnterBudgetName.
  ///
  /// In en, this message translates to:
  /// **'Please enter a budget name'**
  String get pleaseEnterBudgetName;

  /// No description provided for @totalBudget.
  ///
  /// In en, this message translates to:
  /// **'Total Budget'**
  String get totalBudget;

  /// No description provided for @overBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Over Budget!'**
  String get overBudgetLabel;

  /// No description provided for @nearLimit.
  ///
  /// In en, this message translates to:
  /// **'Near Limit'**
  String get nearLimit;

  /// No description provided for @percentUsed.
  ///
  /// In en, this message translates to:
  /// **'% Used'**
  String get percentUsed;

  /// No description provided for @remainingCollapsed.
  ///
  /// In en, this message translates to:
  /// **'Remaining:'**
  String get remainingCollapsed;

  /// No description provided for @tapToAddTransaction.
  ///
  /// In en, this message translates to:
  /// **'Tap + to add your first transaction'**
  String get tapToAddTransaction;

  /// No description provided for @addTransaction.
  ///
  /// In en, this message translates to:
  /// **'Add Transaction'**
  String get addTransaction;

  /// No description provided for @anErrorOccurred.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get anErrorOccurred;

  /// No description provided for @more.
  ///
  /// In en, this message translates to:
  /// **'more'**
  String get more;

  /// No description provided for @ofa.
  ///
  /// In en, this message translates to:
  /// **'of'**
  String get ofa;

  /// No description provided for @wedding.
  ///
  /// In en, this message translates to:
  /// **'Wedding'**
  String get wedding;

  /// No description provided for @homeRenovation.
  ///
  /// In en, this message translates to:
  /// **'Home Renovation'**
  String get homeRenovation;

  /// No description provided for @carPurchase.
  ///
  /// In en, this message translates to:
  /// **'Car Purchase'**
  String get carPurchase;

  /// No description provided for @customBudgetLabel.
  ///
  /// In en, this message translates to:
  /// **'Custom Budget'**
  String get customBudgetLabel;

  /// No description provided for @noRecurringTransactions.
  ///
  /// In en, this message translates to:
  /// **'No recurring transactions'**
  String get noRecurringTransactions;

  /// No description provided for @setUpAutomatic.
  ///
  /// In en, this message translates to:
  /// **'Set up automatic transactions for\nregular income and expenses'**
  String get setUpAutomatic;

  /// No description provided for @addFirstRecurring.
  ///
  /// In en, this message translates to:
  /// **'Add Your First Recurring'**
  String get addFirstRecurring;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @tryDifferentFilter.
  ///
  /// In en, this message translates to:
  /// **'Try a different search or filter'**
  String get tryDifferentFilter;

  /// No description provided for @monthlyNet.
  ///
  /// In en, this message translates to:
  /// **'Monthly Net'**
  String get monthlyNet;

  /// No description provided for @dueSoon.
  ///
  /// In en, this message translates to:
  /// **'Due Soon'**
  String get dueSoon;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @pause.
  ///
  /// In en, this message translates to:
  /// **'Pause'**
  String get pause;

  /// No description provided for @resume.
  ///
  /// In en, this message translates to:
  /// **'Resume'**
  String get resume;

  /// No description provided for @deleteRecurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Recurring Transaction'**
  String get deleteRecurringTitle;

  /// No description provided for @dueNow.
  ///
  /// In en, this message translates to:
  /// **'Due Now'**
  String get dueNow;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @weekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get weekly;

  /// No description provided for @biweekly.
  ///
  /// In en, this message translates to:
  /// **'Bi-weekly'**
  String get biweekly;

  /// No description provided for @quarterly.
  ///
  /// In en, this message translates to:
  /// **'Quarterly'**
  String get quarterly;

  /// No description provided for @yearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get yearly;

  /// No description provided for @recurringIncome.
  ///
  /// In en, this message translates to:
  /// **'Recurring Income'**
  String get recurringIncome;

  /// No description provided for @recurringExpense.
  ///
  /// In en, this message translates to:
  /// **'Recurring Expense'**
  String get recurringExpense;

  /// No description provided for @noEnd.
  ///
  /// In en, this message translates to:
  /// **'No End'**
  String get noEnd;

  /// No description provided for @addNoteOptional.
  ///
  /// In en, this message translates to:
  /// **'Add note (optional)'**
  String get addNoteOptional;

  /// No description provided for @recurringCreated.
  ///
  /// In en, this message translates to:
  /// **'Recurring transaction created!'**
  String get recurringCreated;

  /// No description provided for @recurringUpdated.
  ///
  /// In en, this message translates to:
  /// **'Recurring transaction updated!'**
  String get recurringUpdated;

  /// No description provided for @ledger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get ledger;

  /// No description provided for @insights.
  ///
  /// In en, this message translates to:
  /// **'Insights'**
  String get insights;

  /// No description provided for @paused.
  ///
  /// In en, this message translates to:
  /// **'Paused'**
  String get paused;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @frequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequency;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @never.
  ///
  /// In en, this message translates to:
  /// **'Never'**
  String get never;

  /// No description provided for @nextOccurrence.
  ///
  /// In en, this message translates to:
  /// **'Next Occurrence'**
  String get nextOccurrence;

  /// No description provided for @dayOfMonth.
  ///
  /// In en, this message translates to:
  /// **'Day of Month'**
  String get dayOfMonth;

  /// No description provided for @goBack.
  ///
  /// In en, this message translates to:
  /// **'Go Back'**
  String get goBack;

  /// No description provided for @monthlyEstimate.
  ///
  /// In en, this message translates to:
  /// **'Monthly Estimate'**
  String get monthlyEstimate;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'per month'**
  String get perMonth;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Statistics'**
  String get statistics;

  /// No description provided for @totalAmount.
  ///
  /// In en, this message translates to:
  /// **'Total Amount'**
  String get totalAmount;

  /// No description provided for @noTransactionsGenerated.
  ///
  /// In en, this message translates to:
  /// **'No transactions generated yet'**
  String get noTransactionsGenerated;

  /// No description provided for @generatedTransactions.
  ///
  /// In en, this message translates to:
  /// **'Generated Transactions'**
  String get generatedTransactions;

  /// No description provided for @transactionsThisPeriod.
  ///
  /// In en, this message translates to:
  /// **'transactions this period'**
  String get transactionsThisPeriod;

  /// No description provided for @netBalance.
  ///
  /// In en, this message translates to:
  /// **'Net Balance'**
  String get netBalance;

  /// No description provided for @surplus.
  ///
  /// In en, this message translates to:
  /// **'Surplus'**
  String get surplus;

  /// No description provided for @deficit.
  ///
  /// In en, this message translates to:
  /// **'Deficit'**
  String get deficit;

  /// No description provided for @week.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get week;

  /// No description provided for @month.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get month;

  /// No description provided for @threeMonths.
  ///
  /// In en, this message translates to:
  /// **'3 Months'**
  String get threeMonths;

  /// No description provided for @sixMonths.
  ///
  /// In en, this message translates to:
  /// **'6 Months'**
  String get sixMonths;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @allTime.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get allTime;

  /// No description provided for @financialOverview.
  ///
  /// In en, this message translates to:
  /// **'Financial Overview'**
  String get financialOverview;

  /// No description provided for @budgetOverview.
  ///
  /// In en, this message translates to:
  /// **'Budget Overview'**
  String get budgetOverview;

  /// No description provided for @overallUtilization.
  ///
  /// In en, this message translates to:
  /// **'Overall Utilization'**
  String get overallUtilization;

  /// No description provided for @totalBudgets.
  ///
  /// In en, this message translates to:
  /// **'Total Budgets'**
  String get totalBudgets;

  /// No description provided for @expenseByCategory.
  ///
  /// In en, this message translates to:
  /// **'Expense by Category'**
  String get expenseByCategory;

  /// No description provided for @noExpenseData.
  ///
  /// In en, this message translates to:
  /// **'No expense data available'**
  String get noExpenseData;

  /// No description provided for @monthlyTrends.
  ///
  /// In en, this message translates to:
  /// **'Monthly Trends'**
  String get monthlyTrends;

  /// No description provided for @incomeVsExpense.
  ///
  /// In en, this message translates to:
  /// **'Income vs Expense over time'**
  String get incomeVsExpense;

  /// No description provided for @debtOverview.
  ///
  /// In en, this message translates to:
  /// **'Debt Overview'**
  String get debtOverview;

  /// No description provided for @activeDebt.
  ///
  /// In en, this message translates to:
  /// **'active'**
  String get activeDebt;

  /// No description provided for @paymentMethods.
  ///
  /// In en, this message translates to:
  /// **'Payment Methods'**
  String get paymentMethods;

  /// No description provided for @paymentDistribution.
  ///
  /// In en, this message translates to:
  /// **'Distribution of payment methods'**
  String get paymentDistribution;

  /// No description provided for @topExpenses.
  ///
  /// In en, this message translates to:
  /// **'Top Expenses'**
  String get topExpenses;

  /// No description provided for @top.
  ///
  /// In en, this message translates to:
  /// **'Top'**
  String get top;

  /// No description provided for @avgDaily.
  ///
  /// In en, this message translates to:
  /// **'Avg Daily'**
  String get avgDaily;

  /// No description provided for @avgTransaction.
  ///
  /// In en, this message translates to:
  /// **'Avg Transaction'**
  String get avgTransaction;

  /// No description provided for @savingsRate.
  ///
  /// In en, this message translates to:
  /// **'Savings Rate'**
  String get savingsRate;

  /// No description provided for @profileTitle.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profileTitle;

  /// No description provided for @sectionAppearance.
  ///
  /// In en, this message translates to:
  /// **'APPEARANCE'**
  String get sectionAppearance;

  /// No description provided for @sectionAccount.
  ///
  /// In en, this message translates to:
  /// **'ACCOUNT'**
  String get sectionAccount;

  /// No description provided for @sectionData.
  ///
  /// In en, this message translates to:
  /// **'DATA'**
  String get sectionData;

  /// No description provided for @sectionSupport.
  ///
  /// In en, this message translates to:
  /// **'SUPPORT'**
  String get sectionSupport;

  /// No description provided for @menuTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get menuTheme;

  /// No description provided for @menuThemeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Customize app appearance'**
  String get menuThemeSubtitle;

  /// No description provided for @menuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguage;

  /// No description provided for @menuLanguageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Change app language'**
  String get menuLanguageSubtitle;

  /// No description provided for @menuDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get menuDarkMode;

  /// No description provided for @menuDarkModeEnabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get menuDarkModeEnabled;

  /// No description provided for @menuDarkModeDisabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get menuDarkModeDisabled;

  /// No description provided for @menuEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get menuEditProfile;

  /// No description provided for @menuEditProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update your information'**
  String get menuEditProfileSubtitle;

  /// No description provided for @menuPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get menuPrivacy;

  /// No description provided for @menuPrivacySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your privacy settings'**
  String get menuPrivacySubtitle;

  /// No description provided for @menuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get menuNotifications;

  /// No description provided for @menuNotificationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Configure notification preferences'**
  String get menuNotificationsSubtitle;

  /// No description provided for @menuDailyNotification.
  ///
  /// In en, this message translates to:
  /// **'Daily Notification'**
  String get menuDailyNotification;

  /// No description provided for @menuDailyNotificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Set daily reminder'**
  String get menuDailyNotificationSubtitle;

  /// No description provided for @menuBackup.
  ///
  /// In en, this message translates to:
  /// **'Backup & Restore'**
  String get menuBackup;

  /// No description provided for @menuBackupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Backup your data'**
  String get menuBackupSubtitle;

  /// No description provided for @menuExport.
  ///
  /// In en, this message translates to:
  /// **'Export Data'**
  String get menuExport;

  /// No description provided for @menuExportSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Download your data'**
  String get menuExportSubtitle;

  /// No description provided for @menuHelp.
  ///
  /// In en, this message translates to:
  /// **'Help & Support'**
  String get menuHelp;

  /// No description provided for @menuHelpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Get help with the app'**
  String get menuHelpSubtitle;

  /// No description provided for @menuAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get menuAbout;

  /// No description provided for @menuAboutVersion.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get menuAboutVersion;

  /// No description provided for @btnLogout.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get btnLogout;

  /// No description provided for @dialogLogoutTitle.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get dialogLogoutTitle;

  /// No description provided for @dialogLogoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get dialogLogoutMessage;

  /// No description provided for @dialogEditNameTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit Name'**
  String get dialogEditNameTitle;

  /// No description provided for @dialogEditNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get dialogEditNameLabel;

  /// No description provided for @btnCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get btnCancel;

  /// No description provided for @btnSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get btnSave;

  /// No description provided for @btnLogoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get btnLogoutConfirm;

  /// No description provided for @imagePickerTakePhoto.
  ///
  /// In en, this message translates to:
  /// **'Take Photo'**
  String get imagePickerTakePhoto;

  /// No description provided for @imagePickerGallery.
  ///
  /// In en, this message translates to:
  /// **'Choose from Gallery'**
  String get imagePickerGallery;

  /// No description provided for @imagePickerRemove.
  ///
  /// In en, this message translates to:
  /// **'Remove Photo'**
  String get imagePickerRemove;

  /// No description provided for @aboutAppName.
  ///
  /// In en, this message translates to:
  /// **'Expense Mate'**
  String get aboutAppName;

  /// No description provided for @aboutAppDescription.
  ///
  /// In en, this message translates to:
  /// **'A professional expense tracking application'**
  String get aboutAppDescription;

  /// No description provided for @dailyNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Daily Notification'**
  String get dailyNotificationTitle;

  /// No description provided for @notificationActive.
  ///
  /// In en, this message translates to:
  /// **'Notification Active'**
  String get notificationActive;

  /// No description provided for @noNotificationSet.
  ///
  /// In en, this message translates to:
  /// **'No Notification Set'**
  String get noNotificationSet;

  /// No description provided for @notificationDailyAt.
  ///
  /// In en, this message translates to:
  /// **'Daily at'**
  String get notificationDailyAt;

  /// No description provided for @notificationTime.
  ///
  /// In en, this message translates to:
  /// **'Notification Time'**
  String get notificationTime;

  /// No description provided for @notificationTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification Title'**
  String get notificationTitleLabel;

  /// No description provided for @notificationTitleHint.
  ///
  /// In en, this message translates to:
  /// **'Enter notification title'**
  String get notificationTitleHint;

  /// No description provided for @notificationMessageLabel.
  ///
  /// In en, this message translates to:
  /// **'Notification Message'**
  String get notificationMessageLabel;

  /// No description provided for @notificationMessageHint.
  ///
  /// In en, this message translates to:
  /// **'Enter notification message'**
  String get notificationMessageHint;

  /// No description provided for @notificationImageOptional.
  ///
  /// In en, this message translates to:
  /// **'Notification Image (Optional)'**
  String get notificationImageOptional;

  /// No description provided for @notificationAddImage.
  ///
  /// In en, this message translates to:
  /// **'Add Image'**
  String get notificationAddImage;

  /// No description provided for @notificationChangeImage.
  ///
  /// In en, this message translates to:
  /// **'Change Image'**
  String get notificationChangeImage;

  /// No description provided for @notificationRemoveImage.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get notificationRemoveImage;

  /// No description provided for @btnSendTest.
  ///
  /// In en, this message translates to:
  /// **'Send Test Notification'**
  String get btnSendTest;

  /// No description provided for @btnAddToSchedule.
  ///
  /// In en, this message translates to:
  /// **'Add to Schedule List'**
  String get btnAddToSchedule;

  /// No description provided for @btnSaveAllSchedules.
  ///
  /// In en, this message translates to:
  /// **'Save All Schedules'**
  String get btnSaveAllSchedules;

  /// No description provided for @scheduledNotifications.
  ///
  /// In en, this message translates to:
  /// **'Scheduled Notifications'**
  String get scheduledNotifications;

  /// No description provided for @cancelNotificationTooltip.
  ///
  /// In en, this message translates to:
  /// **'Cancel Notification'**
  String get cancelNotificationTooltip;

  /// No description provided for @infoHowItWorks.
  ///
  /// In en, this message translates to:
  /// **'How it works'**
  String get infoHowItWorks;

  /// No description provided for @infoLine1.
  ///
  /// In en, this message translates to:
  /// **'Notification will repeat daily at the selected time'**
  String get infoLine1;

  /// No description provided for @infoLine2.
  ///
  /// In en, this message translates to:
  /// **'Works even when the app is closed'**
  String get infoLine2;

  /// No description provided for @infoLine3.
  ///
  /// In en, this message translates to:
  /// **'Images are displayed in expanded notification'**
  String get infoLine3;

  /// No description provided for @infoLine4.
  ///
  /// In en, this message translates to:
  /// **'Large images are automatically resized'**
  String get infoLine4;

  /// No description provided for @templateTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Theme Template'**
  String get templateTitle;

  /// No description provided for @themeLabel.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get themeLabel;

  /// No description provided for @themeApplied.
  ///
  /// In en, this message translates to:
  /// **'applied'**
  String get themeApplied;

  /// No description provided for @darkLightSwitch.
  ///
  /// In en, this message translates to:
  /// **'Dark / Light'**
  String get darkLightSwitch;

  /// No description provided for @languageTitle.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get languageTitle;

  /// No description provided for @langEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get langEnglish;

  /// No description provided for @langArabic.
  ///
  /// In en, this message translates to:
  /// **'Arabic'**
  String get langArabic;

  /// No description provided for @langUrdu.
  ///
  /// In en, this message translates to:
  /// **'Urdu'**
  String get langUrdu;

  /// No description provided for @langFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get langFrench;

  /// No description provided for @langSelected.
  ///
  /// In en, this message translates to:
  /// **'selected'**
  String get langSelected;

  /// No description provided for @analyticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get analyticsTitle;

  /// No description provided for @totalTransactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get totalTransactions;

  /// No description provided for @paymentMethodDistribution.
  ///
  /// In en, this message translates to:
  /// **'Distribution of payment methods'**
  String get paymentMethodDistribution;

  /// No description provided for @periodWeek.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get periodWeek;

  /// No description provided for @periodMonth.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get periodMonth;

  /// No description provided for @period3Months.
  ///
  /// In en, this message translates to:
  /// **'3 Months'**
  String get period3Months;

  /// No description provided for @period6Months.
  ///
  /// In en, this message translates to:
  /// **'6 Months'**
  String get period6Months;

  /// No description provided for @periodYear.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get periodYear;

  /// No description provided for @periodAll.
  ///
  /// In en, this message translates to:
  /// **'All Time'**
  String get periodAll;

  /// No description provided for @recurringTitle.
  ///
  /// In en, this message translates to:
  /// **'Recurring'**
  String get recurringTitle;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterActive.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get filterActive;

  /// No description provided for @filterExpired.
  ///
  /// In en, this message translates to:
  /// **'Expired'**
  String get filterExpired;

  /// No description provided for @filterArchived.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get filterArchived;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search…'**
  String get searchHint;

  /// No description provided for @results.
  ///
  /// In en, this message translates to:
  /// **'results'**
  String get results;

  /// No description provided for @result.
  ///
  /// In en, this message translates to:
  /// **'result'**
  String get result;

  /// No description provided for @deleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete'**
  String get deleteConfirm;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ar', 'en', 'fr', 'ur'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar': return AppLocalizationsAr();
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'ur': return AppLocalizationsUr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
