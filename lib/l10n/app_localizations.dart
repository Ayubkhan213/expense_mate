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
  /// **'Records'**
  String get records;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
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
  /// **'Borrowed From'**
  String get borrowedFrom;

  /// No description provided for @lentTo.
  ///
  /// In en, this message translates to:
  /// **'Lent To'**
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
  /// **'Don\'t have an account?'**
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
