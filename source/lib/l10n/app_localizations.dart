import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
  ];

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @acquisitionOwned.
  ///
  /// In en, this message translates to:
  /// **'Already own'**
  String get acquisitionOwned;

  /// No description provided for @acquisitionPurchase.
  ///
  /// In en, this message translates to:
  /// **'Evaluating a purchase'**
  String get acquisitionPurchase;

  /// No description provided for @acquisitionTypeHint.
  ///
  /// In en, this message translates to:
  /// **'Are you evaluating a purchase, or do you already own this property?'**
  String get acquisitionTypeHint;

  /// No description provided for @acquisitionTypeLabel.
  ///
  /// In en, this message translates to:
  /// **'Property status'**
  String get acquisitionTypeLabel;

  /// No description provided for @acrossProperties.
  ///
  /// In en, this message translates to:
  /// **'across {count, plural, =1{property} other{properties}}'**
  String acrossProperties(num count);

  /// No description provided for @actionDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get actionDelete;

  /// No description provided for @actionEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get actionEdit;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpense;

  /// No description provided for @addExpenseButton.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpenseButton;

  /// No description provided for @addExpenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a recurring operating cost for this scenario.'**
  String get addExpenseSubtitle;

  /// No description provided for @addExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Add expense'**
  String get addExpenseTitle;

  /// No description provided for @addIncome.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get addIncome;

  /// No description provided for @addIncomeButton.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get addIncomeButton;

  /// No description provided for @addIncomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a recurring revenue stream for this scenario.'**
  String get addIncomeSubtitle;

  /// No description provided for @addIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Add income'**
  String get addIncomeTitle;

  /// No description provided for @addNotes.
  ///
  /// In en, this message translates to:
  /// **'Add notes'**
  String get addNotes;

  /// No description provided for @addProperty.
  ///
  /// In en, this message translates to:
  /// **'Add property'**
  String get addProperty;

  /// No description provided for @addPropertyForPortfolio.
  ///
  /// In en, this message translates to:
  /// **'Add a property to see your portfolio.'**
  String get addPropertyForPortfolio;

  /// No description provided for @addPropertySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a property to start tracking its cash flow.'**
  String get addPropertySubtitle;

  /// No description provided for @addPropertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Property'**
  String get addPropertyTitle;

  /// No description provided for @addPropertyToCompare.
  ///
  /// In en, this message translates to:
  /// **'Add a property to start comparing scenarios.'**
  String get addPropertyToCompare;

  /// No description provided for @addScenario.
  ///
  /// In en, this message translates to:
  /// **'Add scenario'**
  String get addScenario;

  /// No description provided for @addScenarioTitle.
  ///
  /// In en, this message translates to:
  /// **'Add Scenario'**
  String get addScenarioTitle;

  /// No description provided for @addStreetAddress.
  ///
  /// In en, this message translates to:
  /// **'Add street or address'**
  String get addStreetAddress;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressLabel;

  /// No description provided for @addressPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Add street or address'**
  String get addressPlaceholder;

  /// No description provided for @allProperties.
  ///
  /// In en, this message translates to:
  /// **'All Properties'**
  String get allProperties;

  /// No description provided for @amortMonths.
  ///
  /// In en, this message translates to:
  /// **'Amortization months'**
  String get amortMonths;

  /// No description provided for @amortMonthsLabel.
  ///
  /// In en, this message translates to:
  /// **'Amortization (months)'**
  String get amortMonthsLabel;

  /// No description provided for @amortShort.
  ///
  /// In en, this message translates to:
  /// **'{years}y {months}m'**
  String amortShort(int months, int years);

  /// No description provided for @amortYears.
  ///
  /// In en, this message translates to:
  /// **'Amortization years'**
  String get amortYears;

  /// No description provided for @amortYearsLabel.
  ///
  /// In en, this message translates to:
  /// **'Amortization (years)'**
  String get amortYearsLabel;

  /// No description provided for @amortYearsShort.
  ///
  /// In en, this message translates to:
  /// **'{years}y'**
  String amortYearsShort(int years);

  /// No description provided for @amortizationLabel.
  ///
  /// In en, this message translates to:
  /// **'Amortization'**
  String get amortizationLabel;

  /// No description provided for @amortizationValue.
  ///
  /// In en, this message translates to:
  /// **'Amortization: {value}'**
  String amortizationValue(String value);

  /// No description provided for @amortizationYearsMonths.
  ///
  /// In en, this message translates to:
  /// **'{years} years {months} months'**
  String amortizationYearsMonths(int months, int years);

  /// No description provided for @amountHint.
  ///
  /// In en, this message translates to:
  /// **'0.00'**
  String get amountHint;

  /// No description provided for @amountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountLabel;

  /// No description provided for @amountModeFixed.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amountModeFixed;

  /// No description provided for @amountModePercent.
  ///
  /// In en, this message translates to:
  /// **'% of income'**
  String get amountModePercent;

  /// No description provided for @analyzeAction.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get analyzeAction;

  /// No description provided for @annual.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annual;

  /// No description provided for @annualAfterFinancing.
  ///
  /// In en, this message translates to:
  /// **'Annual {amount} after financing'**
  String annualAfterFinancing(String amount);

  /// No description provided for @annualCashFlow.
  ///
  /// In en, this message translates to:
  /// **'Annual {amount} after financing'**
  String annualCashFlow(String amount);

  /// No description provided for @annualLabel.
  ///
  /// In en, this message translates to:
  /// **'Annual'**
  String get annualLabel;

  /// No description provided for @annualRunRate.
  ///
  /// In en, this message translates to:
  /// **'Annual run rate'**
  String get annualRunRate;

  /// No description provided for @annualizedPrimaryNote.
  ///
  /// In en, this message translates to:
  /// **'Based on the primary scenario \"{name}\", annualized.'**
  String annualizedPrimaryNote(String name);

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Facture'**
  String get appTitle;

  /// No description provided for @balanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balanceLabel;

  /// No description provided for @balanceEndOfYear.
  ///
  /// In en, this message translates to:
  /// **'Balance at end of year {year}'**
  String balanceEndOfYear(int year);

  /// No description provided for @businessAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Street, city, postal code'**
  String get businessAddressHint;

  /// No description provided for @businessAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get businessAddressLabel;

  /// No description provided for @businessDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'You\'re responsible for the accuracy of your business info and tax status. Facture doesn\'t provide tax advice.'**
  String get businessDisclaimer;

  /// No description provided for @businessEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get businessEmailLabel;

  /// No description provided for @businessNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Atelier Nord'**
  String get businessNameHint;

  /// No description provided for @businessNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Business name'**
  String get businessNameLabel;

  /// No description provided for @businessNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your business name'**
  String get businessNameRequired;

  /// No description provided for @businessPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get businessPhoneLabel;

  /// No description provided for @businessProfileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Name, contact, TPS/TVQ status'**
  String get businessProfileSubtitle;

  /// No description provided for @businessProfileTitle.
  ///
  /// In en, this message translates to:
  /// **'Business profile'**
  String get businessProfileTitle;

  /// No description provided for @businessTaxStatusHelper.
  ///
  /// In en, this message translates to:
  /// **'Small suppliers (\$30,000 or less in taxable sales over the last four quarters) aren\'t required to register and must not charge TPS/TVQ.'**
  String get businessTaxStatusHelper;

  /// No description provided for @businessTaxStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'TPS/TVQ registration'**
  String get businessTaxStatusLabel;

  /// No description provided for @businessTaxStatusRegistered.
  ///
  /// In en, this message translates to:
  /// **'Registered'**
  String get businessTaxStatusRegistered;

  /// No description provided for @businessTaxStatusRegisteredSub.
  ///
  /// In en, this message translates to:
  /// **'Charges TPS/TVQ'**
  String get businessTaxStatusRegisteredSub;

  /// No description provided for @businessTaxStatusSmallSupplier.
  ///
  /// In en, this message translates to:
  /// **'Small supplier'**
  String get businessTaxStatusSmallSupplier;

  /// No description provided for @businessTaxStatusSmallSupplierSub.
  ///
  /// In en, this message translates to:
  /// **'No taxes charged'**
  String get businessTaxStatusSmallSupplierSub;

  /// No description provided for @businessTpsNumberHint.
  ///
  /// In en, this message translates to:
  /// **'123456789RT0001'**
  String get businessTpsNumberHint;

  /// No description provided for @businessTpsNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'TPS registration number'**
  String get businessTpsNumberLabel;

  /// No description provided for @businessTvqNumberHint.
  ///
  /// In en, this message translates to:
  /// **'1234567890TQ0001'**
  String get businessTvqNumberHint;

  /// No description provided for @businessTvqNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'TVQ registration number'**
  String get businessTvqNumberLabel;

  /// No description provided for @firstMonthOfYear.
  ///
  /// In en, this message translates to:
  /// **'First month of year {year}'**
  String firstMonthOfYear(int year);

  /// No description provided for @invoiceBackToDraft.
  ///
  /// In en, this message translates to:
  /// **'Back to draft'**
  String get invoiceBackToDraft;

  /// No description provided for @invoiceChangeStatus.
  ///
  /// In en, this message translates to:
  /// **'Change status'**
  String get invoiceChangeStatus;

  /// No description provided for @invoiceMarkPaid.
  ///
  /// In en, this message translates to:
  /// **'Mark as paid'**
  String get invoiceMarkPaid;

  /// No description provided for @invoiceMarkSent.
  ///
  /// In en, this message translates to:
  /// **'Mark as sent'**
  String get invoiceMarkSent;

  /// No description provided for @invoicePaidOn.
  ///
  /// In en, this message translates to:
  /// **'Paid {date}'**
  String invoicePaidOn(String date);

  /// No description provided for @invoiceProfileNudge.
  ///
  /// In en, this message translates to:
  /// **'Add your business info and tax numbers to appear on your invoices.'**
  String get invoiceProfileNudge;

  /// No description provided for @invoiceProfileNudgeAction.
  ///
  /// In en, this message translates to:
  /// **'Set up'**
  String get invoiceProfileNudgeAction;

  /// No description provided for @invoiceReopenAsSent.
  ///
  /// In en, this message translates to:
  /// **'Reopen as sent'**
  String get invoiceReopenAsSent;

  /// No description provided for @invoiceSharePdf.
  ///
  /// In en, this message translates to:
  /// **'Share PDF'**
  String get invoiceSharePdf;

  /// No description provided for @emailTemplateTitle.
  ///
  /// In en, this message translates to:
  /// **'Email template'**
  String get emailTemplateTitle;

  /// No description provided for @emailTemplateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Subject and message used when emailing an invoice — insert the placeholders below'**
  String get emailTemplateSubtitle;

  /// No description provided for @emailTemplateSubjectLabel.
  ///
  /// In en, this message translates to:
  /// **'Subject'**
  String get emailTemplateSubjectLabel;

  /// No description provided for @emailTemplateBodyLabel.
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get emailTemplateBodyLabel;

  /// No description provided for @emailTemplateSubjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a subject'**
  String get emailTemplateSubjectRequired;

  /// No description provided for @emailTemplateBodyRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter a message'**
  String get emailTemplateBodyRequired;

  /// No description provided for @emailTemplatePlaceholdersTitle.
  ///
  /// In en, this message translates to:
  /// **'Placeholders'**
  String get emailTemplatePlaceholdersTitle;

  /// No description provided for @emailTemplatePlaceholdersHint.
  ///
  /// In en, this message translates to:
  /// **'Replaced automatically when the email opens.'**
  String get emailTemplatePlaceholdersHint;

  /// No description provided for @emailTemplateReset.
  ///
  /// In en, this message translates to:
  /// **'Reset to default'**
  String get emailTemplateReset;

  /// Tooltip for the button that emails the invoice
  ///
  /// In en, this message translates to:
  /// **'Send by email'**
  String get invoiceSendEmail;

  /// Primary button on the invoice preview screen
  ///
  /// In en, this message translates to:
  /// **'Send invoice'**
  String get invoicePreviewSend;

  /// Tooltip for the edit button on the invoice preview screen
  ///
  /// In en, this message translates to:
  /// **'Edit invoice'**
  String get invoicePreviewEdit;

  /// Message when the previewed invoice was deleted
  ///
  /// In en, this message translates to:
  /// **'This invoice no longer exists.'**
  String get invoicePreviewNotFound;

  /// Snackbar when the native email composer cannot be opened
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the email composer.'**
  String get invoiceEmailFailed;

  /// Dialog title when the client has no email address
  ///
  /// In en, this message translates to:
  /// **'No email address'**
  String get invoiceNoClientEmailTitle;

  /// Dialog message when the client has no email address
  ///
  /// In en, this message translates to:
  /// **'Add an email address for {name} to send them the invoice.'**
  String invoiceNoClientEmailMessage(String name);

  /// Dialog button opening the client editor to add an email
  ///
  /// In en, this message translates to:
  /// **'Add email'**
  String get invoiceNoClientEmailAdd;

  /// No description provided for @primaryScenarioSection.
  ///
  /// In en, this message translates to:
  /// **'Primary scenario'**
  String get primaryScenarioSection;

  /// No description provided for @primaryScenarioSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'The primary scenario holds your main assumptions — you can add more later to compare.'**
  String get primaryScenarioSectionSubtitle;

  /// No description provided for @primaryScenarioCopyHelper.
  ///
  /// In en, this message translates to:
  /// **'Only applies when starting from scratch — a copied property keeps its scenarios\' names.'**
  String get primaryScenarioCopyHelper;

  /// No description provided for @propertyDetails.
  ///
  /// In en, this message translates to:
  /// **'Property details'**
  String get propertyDetails;

  /// No description provided for @scenarioName.
  ///
  /// In en, this message translates to:
  /// **'Scenario name'**
  String get scenarioName;

  /// No description provided for @primaryScenarioNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Base case'**
  String get primaryScenarioNameHint;

  /// No description provided for @bar.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get bar;

  /// No description provided for @barChart.
  ///
  /// In en, this message translates to:
  /// **'Bar'**
  String get barChart;

  /// No description provided for @basedOn.
  ///
  /// In en, this message translates to:
  /// **'Based on'**
  String get basedOn;

  /// No description provided for @basedOnLabel.
  ///
  /// In en, this message translates to:
  /// **'Based on'**
  String get basedOnLabel;

  /// No description provided for @byProperty.
  ///
  /// In en, this message translates to:
  /// **'By property'**
  String get byProperty;

  /// No description provided for @buyingDerivedLine.
  ///
  /// In en, this message translates to:
  /// **'Balance: {balance} · {percent}% down'**
  String buyingDerivedLine(String balance, String percent);

  /// No description provided for @calcError.
  ///
  /// In en, this message translates to:
  /// **'Unable to calculate this scenario.'**
  String get calcError;

  /// No description provided for @calculated.
  ///
  /// In en, this message translates to:
  /// **'Calculated'**
  String get calculated;

  /// No description provided for @calculatedPayment.
  ///
  /// In en, this message translates to:
  /// **'Calculated payment'**
  String get calculatedPayment;

  /// No description provided for @canada.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get canada;

  /// No description provided for @canadaCompounding.
  ///
  /// In en, this message translates to:
  /// **'Semi-annual compounding'**
  String get canadaCompounding;

  /// No description provided for @canadaUsExplainer.
  ///
  /// In en, this message translates to:
  /// **'Canadian mortgages compound semi-annually; US mortgages compound monthly.'**
  String get canadaUsExplainer;

  /// No description provided for @cannotDeleteLastScenario.
  ///
  /// In en, this message translates to:
  /// **'A property must keep at least one scenario.'**
  String get cannotDeleteLastScenario;

  /// No description provided for @cannotOpenUrl.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t open the link'**
  String get cannotOpenUrl;

  /// No description provided for @capRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Cap Rate'**
  String get capRateLabel;

  /// No description provided for @cashFlowComparison.
  ///
  /// In en, this message translates to:
  /// **'Cash flow comparison'**
  String get cashFlowComparison;

  /// No description provided for @cashFlowLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash Flow'**
  String get cashFlowLabel;

  /// No description provided for @cashOnCashLabel.
  ///
  /// In en, this message translates to:
  /// **'Cash-on-Cash'**
  String get cashOnCashLabel;

  /// No description provided for @categoryField.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get categoryField;

  /// No description provided for @categoryInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get categoryInsurance;

  /// No description provided for @categoryMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get categoryMaintenance;

  /// No description provided for @categoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get categoryOther;

  /// No description provided for @categoryParking.
  ///
  /// In en, this message translates to:
  /// **'Parking'**
  String get categoryParking;

  /// No description provided for @categoryPropertyManagement.
  ///
  /// In en, this message translates to:
  /// **'Property Management'**
  String get categoryPropertyManagement;

  /// No description provided for @categoryPropertyTax.
  ///
  /// In en, this message translates to:
  /// **'Property Tax'**
  String get categoryPropertyTax;

  /// No description provided for @categoryRent.
  ///
  /// In en, this message translates to:
  /// **'Rent'**
  String get categoryRent;

  /// No description provided for @categoryRepairs.
  ///
  /// In en, this message translates to:
  /// **'Repairs'**
  String get categoryRepairs;

  /// No description provided for @categoryStorage.
  ///
  /// In en, this message translates to:
  /// **'Storage'**
  String get categoryStorage;

  /// No description provided for @categoryUtilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get categoryUtilities;

  /// No description provided for @chartDisplayBy.
  ///
  /// In en, this message translates to:
  /// **'Chart display by'**
  String get chartDisplayBy;

  /// No description provided for @classificationSection.
  ///
  /// In en, this message translates to:
  /// **'Classification'**
  String get classificationSection;

  /// No description provided for @comparisonTitle.
  ///
  /// In en, this message translates to:
  /// **'Comparison'**
  String get comparisonTitle;

  /// No description provided for @compoundingHelper.
  ///
  /// In en, this message translates to:
  /// **'The same nominal rate gives a slightly lower payment with semi-annual compounding.'**
  String get compoundingHelper;

  /// No description provided for @compoundingLabel.
  ///
  /// In en, this message translates to:
  /// **'Compounding'**
  String get compoundingLabel;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @convCashFlow.
  ///
  /// In en, this message translates to:
  /// **'Cash flow = NOI − financing costs.'**
  String get convCashFlow;

  /// No description provided for @convCompounding.
  ///
  /// In en, this message translates to:
  /// **'Canadian mortgages compound semi-annually; US mortgages compound monthly. New mortgages default to Canadian semi-annual.'**
  String get convCompounding;

  /// No description provided for @convFrequencies.
  ///
  /// In en, this message translates to:
  /// **'Frequencies are normalized: yearly ÷ 12, weekly × 52 ÷ 12.'**
  String get convFrequencies;

  /// No description provided for @convNoi.
  ///
  /// In en, this message translates to:
  /// **'NOI (net operating income) = effective income − operating expenses. Mortgage payments are excluded from NOI.'**
  String get convNoi;

  /// No description provided for @convOneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time items are stored but excluded from recurring monthly figures.'**
  String get convOneTime;

  /// No description provided for @convPrimary.
  ///
  /// In en, this message translates to:
  /// **'The primary scenario is the reference for portfolio totals.'**
  String get convPrimary;

  /// No description provided for @convVacancy.
  ///
  /// In en, this message translates to:
  /// **'Vacancy / income loss is a regular expense: enter a fixed amount or a percent of gross income.'**
  String get convVacancy;

  /// No description provided for @conventionCashFlow.
  ///
  /// In en, this message translates to:
  /// **'Cash flow = NOI − financing costs.'**
  String get conventionCashFlow;

  /// No description provided for @conventionCompounding.
  ///
  /// In en, this message translates to:
  /// **'Canadian mortgages compound semi-annually; US mortgages compound monthly. New mortgages default to Canadian semi-annual.'**
  String get conventionCompounding;

  /// No description provided for @conventionFrequencies.
  ///
  /// In en, this message translates to:
  /// **'Frequencies are normalized: yearly ÷ 12, weekly × 52 ÷ 12.'**
  String get conventionFrequencies;

  /// No description provided for @conventionNoi.
  ///
  /// In en, this message translates to:
  /// **'NOI (net operating income) = effective income − operating expenses. Mortgage payments are excluded from NOI.'**
  String get conventionNoi;

  /// No description provided for @conventionOneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time items are stored but excluded from recurring monthly figures.'**
  String get conventionOneTime;

  /// No description provided for @conventionPrimary.
  ///
  /// In en, this message translates to:
  /// **'The primary scenario is the reference for portfolio totals.'**
  String get conventionPrimary;

  /// No description provided for @conventionVacancy.
  ///
  /// In en, this message translates to:
  /// **'Vacancy / income loss is a percentage of gross scheduled income.'**
  String get conventionVacancy;

  /// No description provided for @copyScenarioHint.
  ///
  /// In en, this message translates to:
  /// **'Copy the numbers from an existing scenario or start empty.'**
  String get copyScenarioHint;

  /// No description provided for @createPropertySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a property to start tracking its cash flow.'**
  String get createPropertySubtitle;

  /// No description provided for @createScenarioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Model a what-if variant (refinance, rent increase, new purchase) without touching your primary scenario.'**
  String get createScenarioSubtitle;

  /// No description provided for @csvHeader.
  ///
  /// In en, this message translates to:
  /// **'Category,Amount'**
  String get csvHeader;

  /// No description provided for @currentMonthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Current monthly payment'**
  String get currentMonthlyPayment;

  /// No description provided for @currentMortgageBalance.
  ///
  /// In en, this message translates to:
  /// **'Current mortgage balance'**
  String get currentMortgageBalance;

  /// No description provided for @currentScenario.
  ///
  /// In en, this message translates to:
  /// **'Current scenario'**
  String get currentScenario;

  /// No description provided for @currentTotalInterest.
  ///
  /// In en, this message translates to:
  /// **'Current total interest'**
  String get currentTotalInterest;

  /// No description provided for @dashboardMonthlyPerformance.
  ///
  /// In en, this message translates to:
  /// **'Monthly performance'**
  String get dashboardMonthlyPerformance;

  /// No description provided for @dataInvalidError.
  ///
  /// In en, this message translates to:
  /// **'The local data has an invalid value: {error}'**
  String dataInvalidError(String error);

  /// No description provided for @dataReadError.
  ///
  /// In en, this message translates to:
  /// **'The local data could not be read: {error}'**
  String dataReadError(String error);

  /// No description provided for @dataSaveError.
  ///
  /// In en, this message translates to:
  /// **'The local data could not be saved.'**
  String get dataSaveError;

  /// No description provided for @dataSaveErrorDetail.
  ///
  /// In en, this message translates to:
  /// **'The local data could not be saved: {error}'**
  String dataSaveErrorDetail(String error);

  /// No description provided for @dealCapRate.
  ///
  /// In en, this message translates to:
  /// **'Cap rate: {value}'**
  String dealCapRate(String value);

  /// No description provided for @dealCashFlow.
  ///
  /// In en, this message translates to:
  /// **'Monthly cash flow: {amount}'**
  String dealCashFlow(String amount);

  /// No description provided for @dealCashOnCash.
  ///
  /// In en, this message translates to:
  /// **'Cash-on-cash return: {value}'**
  String dealCashOnCash(String value);

  /// No description provided for @dealDownPayment.
  ///
  /// In en, this message translates to:
  /// **'Down payment: {amount}'**
  String dealDownPayment(String amount);

  /// No description provided for @dealDscr.
  ///
  /// In en, this message translates to:
  /// **'DSCR: {value}'**
  String dealDscr(String value);

  /// No description provided for @dealGrossRent.
  ///
  /// In en, this message translates to:
  /// **'Gross monthly rent: {amount}'**
  String dealGrossRent(String amount);

  /// No description provided for @dealMonthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Monthly mortgage payment: {amount}'**
  String dealMonthlyPayment(String amount);

  /// No description provided for @dealPurchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase price: {amount}'**
  String dealPurchasePrice(String amount);

  /// No description provided for @dealScenario.
  ///
  /// In en, this message translates to:
  /// **'Scenario: {scenarioName}'**
  String dealScenario(String scenarioName);

  /// No description provided for @dealSnapshotTitle.
  ///
  /// In en, this message translates to:
  /// **'Deal snapshot — {propertyName}'**
  String dealSnapshotTitle(String propertyName);

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @deleteItemMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this item?'**
  String get deleteItemMessage;

  /// No description provided for @deleteItemTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete?'**
  String get deleteItemTitle;

  /// No description provided for @deletePropertyConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete \"{name}\" and its scenarios?'**
  String deletePropertyConfirm(String name);

  /// No description provided for @deletePropertyMessage.
  ///
  /// In en, this message translates to:
  /// **'This will also delete all scenarios associated with this property.'**
  String get deletePropertyMessage;

  /// No description provided for @deletePropertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete property?'**
  String get deletePropertyTitle;

  /// No description provided for @deleteScenarioMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this scenario?'**
  String get deleteScenarioMessage;

  /// No description provided for @deleteScenarioTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete scenario?'**
  String get deleteScenarioTitle;

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @dialogConfirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get dialogConfirm;

  /// No description provided for @dialogDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get dialogDelete;

  /// No description provided for @dialogOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get dialogOk;

  /// No description provided for @dialogSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get dialogSave;

  /// No description provided for @dscrLabel.
  ///
  /// In en, this message translates to:
  /// **'DSCR'**
  String get dscrLabel;

  /// No description provided for @downPayment.
  ///
  /// In en, this message translates to:
  /// **'Down payment'**
  String get downPayment;

  /// No description provided for @downPaymentCustomOption.
  ///
  /// In en, this message translates to:
  /// **'Custom amount'**
  String get downPaymentCustomOption;

  /// No description provided for @downPaymentMinimumHint.
  ///
  /// In en, this message translates to:
  /// **'CMHC tiers: 5% / 10% / 20%'**
  String get downPaymentMinimumHint;

  /// No description provided for @downPaymentMinimumHintInvestment.
  ///
  /// In en, this message translates to:
  /// **'20% minimum — rentals can\'t be mortgage-insured'**
  String get downPaymentMinimumHintInvestment;

  /// No description provided for @downPaymentMinimumOption.
  ///
  /// In en, this message translates to:
  /// **'Minimum'**
  String get downPaymentMinimumOption;

  /// No description provided for @downPaymentModeLabel.
  ///
  /// In en, this message translates to:
  /// **'Down payment'**
  String get downPaymentModeLabel;

  /// No description provided for @downPaymentPercentMode.
  ///
  /// In en, this message translates to:
  /// **'Down payment (%)'**
  String get downPaymentPercentMode;

  /// No description provided for @duplicatePropertyName.
  ///
  /// In en, this message translates to:
  /// **'A property with this name already exists.'**
  String get duplicatePropertyName;

  /// No description provided for @duplicateScenarioName.
  ///
  /// In en, this message translates to:
  /// **'A scenario with this name already exists for this property.'**
  String get duplicateScenarioName;

  /// No description provided for @eachPropertyPrimary.
  ///
  /// In en, this message translates to:
  /// **'Each property is represented by its primary scenario.'**
  String get eachPropertyPrimary;

  /// No description provided for @eachSideNeedsScenario.
  ///
  /// In en, this message translates to:
  /// **'Each side needs a scenario to compare.'**
  String get eachSideNeedsScenario;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get editExpense;

  /// No description provided for @editExpenseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update this expense item.'**
  String get editExpenseSubtitle;

  /// No description provided for @editExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit expense'**
  String get editExpenseTitle;

  /// No description provided for @editIncome.
  ///
  /// In en, this message translates to:
  /// **'Edit income'**
  String get editIncome;

  /// No description provided for @editIncomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update this income item.'**
  String get editIncomeSubtitle;

  /// No description provided for @editIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit income'**
  String get editIncomeTitle;

  /// No description provided for @editMortgage.
  ///
  /// In en, this message translates to:
  /// **'Edit mortgage'**
  String get editMortgage;

  /// No description provided for @editProperty.
  ///
  /// In en, this message translates to:
  /// **'Edit property'**
  String get editProperty;

  /// No description provided for @editPropertyName.
  ///
  /// In en, this message translates to:
  /// **'Edit property name'**
  String get editPropertyName;

  /// No description provided for @editPropertySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Update the property details.'**
  String get editPropertySubtitle;

  /// No description provided for @editPropertyTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit property'**
  String get editPropertyTitle;

  /// No description provided for @editStreetAddress.
  ///
  /// In en, this message translates to:
  /// **'Edit street or address'**
  String get editStreetAddress;

  /// No description provided for @emptyExpenseMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your first operating expense to complete the picture.'**
  String get emptyExpenseMessage;

  /// No description provided for @emptyExpenseTitle.
  ///
  /// In en, this message translates to:
  /// **'No expenses yet'**
  String get emptyExpenseTitle;

  /// No description provided for @emptyIncomeMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your first income source to see your cash flow take shape.'**
  String get emptyIncomeMessage;

  /// No description provided for @emptyIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'No income yet'**
  String get emptyIncomeTitle;

  /// No description provided for @errorTitle.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get errorTitle;

  /// No description provided for @enterMortgageDetails.
  ///
  /// In en, this message translates to:
  /// **'Enter the balance, rate, and amortization; the app computes the monthly payment.'**
  String get enterMortgageDetails;

  /// No description provided for @enterValidTerms.
  ///
  /// In en, this message translates to:
  /// **'Enter valid refinance terms to compare.'**
  String get enterValidTerms;

  /// No description provided for @estimatedMonthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Estimated monthly payment'**
  String get estimatedMonthlyPayment;

  /// No description provided for @expenseNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Property tax'**
  String get expenseNameHint;

  /// No description provided for @expenseTitle.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expenseTitle;

  /// No description provided for @expensesTitle.
  ///
  /// In en, this message translates to:
  /// **'Expenses · {name}'**
  String expensesTitle(String name);

  /// Title of the info explainer sheet, e.g. 'What is DSCR?'
  ///
  /// In en, this message translates to:
  /// **'What is {title}?'**
  String explainerTitle(String title);

  /// No description provided for @fieldAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get fieldAmount;

  /// No description provided for @fieldCategory.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get fieldCategory;

  /// No description provided for @fieldFrequency.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get fieldFrequency;

  /// No description provided for @fieldName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get fieldName;

  /// No description provided for @fieldNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get fieldNotes;

  /// No description provided for @financialConventions.
  ///
  /// In en, this message translates to:
  /// **'Financial conventions'**
  String get financialConventions;

  /// No description provided for @financialConventionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How the app computes its numbers'**
  String get financialConventionsSubtitle;

  /// No description provided for @financingAssumptions.
  ///
  /// In en, this message translates to:
  /// **'Financing assumptions for this scenario.'**
  String get financingAssumptions;

  /// No description provided for @financingAssumptionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Financing assumptions'**
  String get financingAssumptionsTitle;

  /// No description provided for @financingExcludedNote.
  ///
  /// In en, this message translates to:
  /// **'Mortgage payment is treated as a financing cost and excluded from NOI.'**
  String get financingExcludedNote;

  /// No description provided for @financingLabel.
  ///
  /// In en, this message translates to:
  /// **'Financing'**
  String get financingLabel;

  /// No description provided for @formAdd.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get formAdd;

  /// No description provided for @formCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get formCancel;

  /// No description provided for @formSave.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get formSave;

  /// No description provided for @feedbackEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'Facture {version} feedback'**
  String feedbackEmailSubject(String version);

  /// No description provided for @feedbackEmailCopied.
  ///
  /// In en, this message translates to:
  /// **'Support address copied — paste it into your mail app.'**
  String get feedbackEmailCopied;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Report a bug or suggest a feature.'**
  String get feedbackSubtitle;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'Send feedback'**
  String get feedbackTitle;

  /// No description provided for @frequenciesNote.
  ///
  /// In en, this message translates to:
  /// **'Frequencies are normalized: yearly ÷ 12, weekly × 52 ÷ 12.'**
  String get frequenciesNote;

  /// No description provided for @frequencyField.
  ///
  /// In en, this message translates to:
  /// **'Frequency'**
  String get frequencyField;

  /// No description provided for @frequencyMonthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get frequencyMonthly;

  /// No description provided for @frequencyOneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time'**
  String get frequencyOneTime;

  /// No description provided for @frequencyWeekly.
  ///
  /// In en, this message translates to:
  /// **'Weekly'**
  String get frequencyWeekly;

  /// No description provided for @frequencyYearly.
  ///
  /// In en, this message translates to:
  /// **'Yearly'**
  String get frequencyYearly;

  /// No description provided for @settingsBusiness.
  ///
  /// In en, this message translates to:
  /// **'Business'**
  String get settingsBusiness;

  /// No description provided for @shareInvoiceSubject.
  ///
  /// In en, this message translates to:
  /// **'Invoice {number}'**
  String shareInvoiceSubject(String number);

  /// No description provided for @shareInvoiceText.
  ///
  /// In en, this message translates to:
  /// **'Here\'s invoice {number} — {total}.'**
  String shareInvoiceText(String number, String total);

  /// No description provided for @yearPickerLabel.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get yearPickerLabel;

  /// No description provided for @blank.
  ///
  /// In en, this message translates to:
  /// **'Blank'**
  String get blank;

  /// No description provided for @generatedBy.
  ///
  /// In en, this message translates to:
  /// **'Generated by Rentable.'**
  String get generatedBy;

  /// No description provided for @grossRents.
  ///
  /// In en, this message translates to:
  /// **'Gross rents'**
  String get grossRents;

  /// No description provided for @guideAnalysisBody.
  ///
  /// In en, this message translates to:
  /// **'Pick two scenarios to compare them side by side: income, expenses, cash flow, financing, and the investor metrics below.'**
  String get guideAnalysisBody;

  /// No description provided for @guideAnalysisTitle.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get guideAnalysisTitle;

  /// No description provided for @guideDashboardBody.
  ///
  /// In en, this message translates to:
  /// **'The dashboard shows one property and scenario at a time, or — pick \"All Properties\" — your whole portfolio at once. The portfolio view sums each property’s primary scenario, so it always reflects your reference numbers.'**
  String get guideDashboardBody;

  /// No description provided for @guideDashboardTitle.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get guideDashboardTitle;

  /// No description provided for @guideIncomeBody.
  ///
  /// In en, this message translates to:
  /// **'Add the recurring income and operating expenses of a scenario: rent, laundry, property tax, insurance, maintenance. Each item has a frequency (monthly, yearly, weekly, one-time) and is normalized to a monthly amount.\n\nVacancy / income loss is set as a percentage of gross revenue on the Expenses tab.'**
  String get guideIncomeBody;

  /// No description provided for @guideIncomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Income and expenses'**
  String get guideIncomeTitle;

  /// No description provided for @guideMortgageBody.
  ///
  /// In en, this message translates to:
  /// **'Enter the balance, rate, and amortization; the app computes the monthly payment. Choose the rate type that matches the loan: Canada (semi-annual compounding) or US (monthly compounding).\n\nMortgage payments are financing costs: they reduce cash flow but are excluded from NOI, the standard convention.'**
  String get guideMortgageBody;

  /// No description provided for @guideMortgageTitle.
  ///
  /// In en, this message translates to:
  /// **'Mortgage'**
  String get guideMortgageTitle;

  /// No description provided for @guidePropertiesBody.
  ///
  /// In en, this message translates to:
  /// **'A property is a building you track — a multiplex, a condo, a house. Add one from the Properties tab. Everything in the app (scenarios, income, expenses, mortgage) lives under a property.'**
  String get guidePropertiesBody;

  /// No description provided for @guidePropertiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get guidePropertiesTitle;

  /// No description provided for @guideScenariosBody.
  ///
  /// In en, this message translates to:
  /// **'Each property holds one or more scenarios: what-if variants of the same building. Model a refinance, a rent increase, or a purchase offer without touching your reference numbers.\n\nOne scenario is always the primary. It is the reference used for the All Properties dashboard and marks the current reality of the building. Copy any scenario to explore alternatives, then switch the primary when the alternative becomes the plan.'**
  String get guideScenariosBody;

  /// No description provided for @guideScenariosTitle.
  ///
  /// In en, this message translates to:
  /// **'Scenarios'**
  String get guideScenariosTitle;

  /// No description provided for @howItWorks.
  ///
  /// In en, this message translates to:
  /// **'How Facture works'**
  String get howItWorks;

  /// No description provided for @howItWorksSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clients, invoices and Québec taxes.'**
  String get howItWorksSubtitle;

  /// No description provided for @hypotheticalTerms.
  ///
  /// In en, this message translates to:
  /// **'Hypothetical refinance terms'**
  String get hypotheticalTerms;

  /// No description provided for @incomeNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Unit 1 rent'**
  String get incomeNameHint;

  /// No description provided for @incomeScreenTitle.
  ///
  /// In en, this message translates to:
  /// **'Income · {name}'**
  String incomeScreenTitle(String name);

  /// No description provided for @incomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get incomeTitle;

  /// No description provided for @interestLabel.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get interestLabel;

  /// No description provided for @interestRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Interest rate'**
  String get interestRateLabel;

  /// No description provided for @interestRatePercent.
  ///
  /// In en, this message translates to:
  /// **'Interest rate (%)'**
  String get interestRatePercent;

  /// No description provided for @investorMetrics.
  ///
  /// In en, this message translates to:
  /// **'Investor Metrics'**
  String get investorMetrics;

  /// No description provided for @investorMetricsExplained.
  ///
  /// In en, this message translates to:
  /// **'Investor metrics explained'**
  String get investorMetricsExplained;

  /// No description provided for @investorMetricsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'DSCR, cap rate, cash-on-cash, LTV'**
  String get investorMetricsSubtitle;

  /// No description provided for @investorMetricsTitle.
  ///
  /// In en, this message translates to:
  /// **'Investor metrics'**
  String get investorMetricsTitle;

  /// No description provided for @loanAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Loan amount'**
  String get loanAmountLabel;

  /// No description provided for @loanDetails.
  ///
  /// In en, this message translates to:
  /// **'Loan details'**
  String get loanDetails;

  /// No description provided for @ltvDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'V1 assumption: potential borrowing is capped at 80% of property value. This is not a refinancing transaction or lender qualification result.'**
  String get ltvDisclaimer;

  /// No description provided for @ltvLabel.
  ///
  /// In en, this message translates to:
  /// **'LTV'**
  String get ltvLabel;

  /// No description provided for @listingUrlHint.
  ///
  /// In en, this message translates to:
  /// **'Paste a listing link or Centris share text'**
  String get listingUrlHint;

  /// No description provided for @listingUrlLabel.
  ///
  /// In en, this message translates to:
  /// **'Listing URL'**
  String get listingUrlLabel;

  /// No description provided for @listingUrlPrefillHelper.
  ///
  /// In en, this message translates to:
  /// **'Paste a listing link: the name, city, and units will be pre-filled.'**
  String get listingUrlPrefillHelper;

  /// No description provided for @listingPlexDetected.
  ///
  /// In en, this message translates to:
  /// **'Plex detected: {count} rent entries will be created.'**
  String listingPlexDetected(int count);

  /// No description provided for @makePrimaryScenario.
  ///
  /// In en, this message translates to:
  /// **'Make primary scenario'**
  String get makePrimaryScenario;

  /// No description provided for @manageScenarios.
  ///
  /// In en, this message translates to:
  /// **'Manage scenarios'**
  String get manageScenarios;

  /// No description provided for @manualMonthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Manual monthly payment'**
  String get manualMonthlyPayment;

  /// No description provided for @manualOverride.
  ///
  /// In en, this message translates to:
  /// **'Manual override'**
  String get manualOverride;

  /// No description provided for @manualPaymentHint.
  ///
  /// In en, this message translates to:
  /// **'Enter a manual payment only if your actual payment differs from the calculated one.'**
  String get manualPaymentHint;

  /// No description provided for @maxMortgageBalance.
  ///
  /// In en, this message translates to:
  /// **'Maximum mortgage balance (80% LTV)'**
  String get maxMortgageBalance;

  /// No description provided for @metricCapRate.
  ///
  /// In en, this message translates to:
  /// **'Cap Rate — Capitalization Rate'**
  String get metricCapRate;

  /// No description provided for @metricCapRateMeaning.
  ///
  /// In en, this message translates to:
  /// **'Annual net operating income divided by the property value. It answers: what yield would this property earn if bought all cash?'**
  String get metricCapRateMeaning;

  /// No description provided for @metricCapRateReading.
  ///
  /// In en, this message translates to:
  /// **'Higher means cheaper relative to its income. Use it to compare properties regardless of how they are financed.'**
  String get metricCapRateReading;

  /// No description provided for @metricCapRateShort.
  ///
  /// In en, this message translates to:
  /// **'Cap rate'**
  String get metricCapRateShort;

  /// No description provided for @metricCashOnCash.
  ///
  /// In en, this message translates to:
  /// **'Cash-on-Cash Return'**
  String get metricCashOnCash;

  /// No description provided for @metricCashOnCashMeaning.
  ///
  /// In en, this message translates to:
  /// **'Annual cash flow divided by the cash you actually invested (property value minus mortgage balance). It answers: what return am I earning on my money?'**
  String get metricCashOnCashMeaning;

  /// No description provided for @metricCashOnCashReading.
  ///
  /// In en, this message translates to:
  /// **'Higher means your down payment works harder. Unlike cap rate, it reflects your financing.'**
  String get metricCashOnCashReading;

  /// No description provided for @metricCashOnCashShort.
  ///
  /// In en, this message translates to:
  /// **'Cash-on-cash'**
  String get metricCashOnCashShort;

  /// No description provided for @metricDscr.
  ///
  /// In en, this message translates to:
  /// **'DSCR — Debt-Service Coverage Ratio'**
  String get metricDscr;

  /// No description provided for @metricDscrMeaning.
  ///
  /// In en, this message translates to:
  /// **'Annual net operating income divided by annual mortgage payments. It answers: does the rent cover the loan?'**
  String get metricDscrMeaning;

  /// No description provided for @metricDscrReading.
  ///
  /// In en, this message translates to:
  /// **'Above 1.20 is comfortable and what most lenders want to see. Below 1.00 means the property does not pay for itself.'**
  String get metricDscrReading;

  /// No description provided for @metricDscrShort.
  ///
  /// In en, this message translates to:
  /// **'DSCR'**
  String get metricDscrShort;

  /// No description provided for @metricLtv.
  ///
  /// In en, this message translates to:
  /// **'LTV — Loan-to-Value'**
  String get metricLtv;

  /// No description provided for @metricLtvMeaning.
  ///
  /// In en, this message translates to:
  /// **'Mortgage balance divided by the property value. It answers: how much of the property does the lender own?'**
  String get metricLtvMeaning;

  /// No description provided for @metricLtvReading.
  ///
  /// In en, this message translates to:
  /// **'Lower means more equity cushion. Most residential lenders cap insured mortgages around 80%.'**
  String get metricLtvReading;

  /// No description provided for @metricLtvShort.
  ///
  /// In en, this message translates to:
  /// **'LTV'**
  String get metricLtvShort;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @monthlyCashFlowChart.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY CASH FLOW'**
  String get monthlyCashFlowChart;

  /// No description provided for @monthlyCashFlowLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly cash flow'**
  String get monthlyCashFlowLabel;

  /// No description provided for @monthlyDifference.
  ///
  /// In en, this message translates to:
  /// **'Monthly difference'**
  String get monthlyDifference;

  /// No description provided for @monthlyLabel.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthlyLabel;

  /// No description provided for @monthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Monthly payment'**
  String get monthlyPayment;

  /// No description provided for @monthlyPaymentCalculated.
  ///
  /// In en, this message translates to:
  /// **'Monthly payment (calculated)'**
  String get monthlyPaymentCalculated;

  /// No description provided for @monthlyPaymentManual.
  ///
  /// In en, this message translates to:
  /// **'Monthly payment (manual override)'**
  String get monthlyPaymentManual;

  /// No description provided for @monthlyPerformance.
  ///
  /// In en, this message translates to:
  /// **'Monthly performance'**
  String get monthlyPerformance;

  /// No description provided for @mortgageBalance.
  ///
  /// In en, this message translates to:
  /// **'Mortgage balance'**
  String get mortgageBalance;

  /// No description provided for @mortgageBalanceLabel.
  ///
  /// In en, this message translates to:
  /// **'Mortgage Balance'**
  String get mortgageBalanceLabel;

  /// No description provided for @mortgageCalculatorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Estimate your monthly payment'**
  String get mortgageCalculatorSubtitle;

  /// No description provided for @mortgageCalculatorTitle.
  ///
  /// In en, this message translates to:
  /// **'Mortgage calculator'**
  String get mortgageCalculatorTitle;

  /// No description provided for @mortgageInterestNote.
  ///
  /// In en, this message translates to:
  /// **'Mortgage interest is an estimate (current monthly interest × 12) and appears here for tax purposes only — it is still excluded from NOI.'**
  String get mortgageInterestNote;

  /// No description provided for @mortgageTitle.
  ///
  /// In en, this message translates to:
  /// **'Mortgage · {scenarioName}'**
  String mortgageTitle(String scenarioName);

  /// No description provided for @nameHintExpense.
  ///
  /// In en, this message translates to:
  /// **'e.g. Property tax'**
  String get nameHintExpense;

  /// No description provided for @nameHintIncome.
  ///
  /// In en, this message translates to:
  /// **'e.g. Unit 1 rent'**
  String get nameHintIncome;

  /// No description provided for @nameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameLabel;

  /// No description provided for @navAnalysis.
  ///
  /// In en, this message translates to:
  /// **'Analysis'**
  String get navAnalysis;

  /// No description provided for @analyzeMode.
  ///
  /// In en, this message translates to:
  /// **'Analyze'**
  String get analyzeMode;

  /// No description provided for @compareMode.
  ///
  /// In en, this message translates to:
  /// **'Compare'**
  String get compareMode;

  /// No description provided for @scenarioFieldLabel.
  ///
  /// In en, this message translates to:
  /// **'Scenario'**
  String get scenarioFieldLabel;

  /// No description provided for @navDashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get navDashboard;

  /// No description provided for @navProperties.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get navProperties;

  /// No description provided for @navSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @needScenarioEachSide.
  ///
  /// In en, this message translates to:
  /// **'Each side needs a scenario to compare.\nAdd a scenario to continue.'**
  String get needScenarioEachSide;

  /// No description provided for @netRentalIncome.
  ///
  /// In en, this message translates to:
  /// **'Net rental income'**
  String get netRentalIncome;

  /// No description provided for @newBalance.
  ///
  /// In en, this message translates to:
  /// **'New balance'**
  String get newBalance;

  /// No description provided for @newInterestRate.
  ///
  /// In en, this message translates to:
  /// **'New interest rate (%)'**
  String get newInterestRate;

  /// No description provided for @newMortgagesDefault.
  ///
  /// In en, this message translates to:
  /// **'New mortgages default to Canadian semi-annual.'**
  String get newMortgagesDefault;

  /// No description provided for @noExpenseCategories.
  ///
  /// In en, this message translates to:
  /// **'No operating expense categories yet.'**
  String get noExpenseCategories;

  /// No description provided for @noExpenses.
  ///
  /// In en, this message translates to:
  /// **'No operating expenses yet.'**
  String get noExpenses;

  /// No description provided for @noIncomeCategories.
  ///
  /// In en, this message translates to:
  /// **'No income categories yet.'**
  String get noIncomeCategories;

  /// No description provided for @noIncomeItems.
  ///
  /// In en, this message translates to:
  /// **'No income items yet.'**
  String get noIncomeItems;

  /// No description provided for @noOperatingExpenses.
  ///
  /// In en, this message translates to:
  /// **'No operating expenses yet.'**
  String get noOperatingExpenses;

  /// No description provided for @noScenario.
  ///
  /// In en, this message translates to:
  /// **'No scenario'**
  String get noScenario;

  /// No description provided for @noiLabel.
  ///
  /// In en, this message translates to:
  /// **'NOI'**
  String get noiLabel;

  /// No description provided for @noiShort.
  ///
  /// In en, this message translates to:
  /// **'NOI'**
  String get noiShort;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'n/a'**
  String get notAvailable;

  /// No description provided for @notesField.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notesField;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get notesOptional;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @oneTimeNote.
  ///
  /// In en, this message translates to:
  /// **'One-time items are stored but excluded from recurring monthly figures.'**
  String get oneTimeNote;

  /// No description provided for @operatingExpensesLabel.
  ///
  /// In en, this message translates to:
  /// **'Operating expenses'**
  String get operatingExpensesLabel;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get optional;

  /// No description provided for @paymentMode.
  ///
  /// In en, this message translates to:
  /// **'Payment mode'**
  String get paymentMode;

  /// No description provided for @perMonthShort.
  ///
  /// In en, this message translates to:
  /// **'{amount} / mo'**
  String perMonthShort(String amount);

  /// No description provided for @perWeekShort.
  ///
  /// In en, this message translates to:
  /// **'{amount} / wk'**
  String perWeekShort(String amount);

  /// No description provided for @perYearShort.
  ///
  /// In en, this message translates to:
  /// **'{amount} / yr'**
  String perYearShort(String amount);

  /// No description provided for @percentOfGrossRevenue.
  ///
  /// In en, this message translates to:
  /// **'{rate}% of gross revenue'**
  String percentOfGrossRevenue(String rate);

  /// No description provided for @percentage.
  ///
  /// In en, this message translates to:
  /// **'Percentage'**
  String get percentage;

  /// No description provided for @persistenceLoadError.
  ///
  /// In en, this message translates to:
  /// **'Unable to load local data.'**
  String get persistenceLoadError;

  /// No description provided for @pickTwoScenarios.
  ///
  /// In en, this message translates to:
  /// **'Pick two scenarios to compare them side by side: income, expenses, cash flow, financing, and the investor metrics below.'**
  String get pickTwoScenarios;

  /// No description provided for @pie.
  ///
  /// In en, this message translates to:
  /// **'Pie'**
  String get pie;

  /// No description provided for @pieChart.
  ///
  /// In en, this message translates to:
  /// **'Pie'**
  String get pieChart;

  /// No description provided for @portfolioAnnualLine.
  ///
  /// In en, this message translates to:
  /// **'Annual {amount} across {count, plural, one {{count} property} other {{count} properties}}'**
  String portfolioAnnualLine(String amount, int count);

  /// No description provided for @portfolioCashFlow.
  ///
  /// In en, this message translates to:
  /// **'PORTFOLIO CASH FLOW'**
  String get portfolioCashFlow;

  /// No description provided for @portfolioCashFlowLabel.
  ///
  /// In en, this message translates to:
  /// **'Portfolio cash flow'**
  String get portfolioCashFlowLabel;

  /// No description provided for @potentialAdditional.
  ///
  /// In en, this message translates to:
  /// **'Potential additional amount'**
  String get potentialAdditional;

  /// No description provided for @potentialRefinanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Potential additional refinance'**
  String get potentialRefinanceTitle;

  /// No description provided for @ppSuffix.
  ///
  /// In en, this message translates to:
  /// **'pp'**
  String get ppSuffix;

  /// No description provided for @primaryBadge.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get primaryBadge;

  /// No description provided for @primaryForAllProperties.
  ///
  /// In en, this message translates to:
  /// **'Primary scenario is used for All Properties calculations'**
  String get primaryForAllProperties;

  /// No description provided for @primaryScenarioCalculations.
  ///
  /// In en, this message translates to:
  /// **'Primary scenario is used for All Properties calculations'**
  String get primaryScenarioCalculations;

  /// No description provided for @primaryScenarioNote.
  ///
  /// In en, this message translates to:
  /// **'Each property is represented by its primary scenario.'**
  String get primaryScenarioNote;

  /// No description provided for @primaryScenarioTooltip.
  ///
  /// In en, this message translates to:
  /// **'Primary scenario'**
  String get primaryScenarioTooltip;

  /// No description provided for @principalLabel.
  ///
  /// In en, this message translates to:
  /// **'Principal'**
  String get principalLabel;

  /// No description provided for @propertiesTitle.
  ///
  /// In en, this message translates to:
  /// **'Properties'**
  String get propertiesTitle;

  /// No description provided for @propertyActions.
  ///
  /// In en, this message translates to:
  /// **'Property actions'**
  String get propertyActions;

  /// No description provided for @propertyAddressHint.
  ///
  /// In en, this message translates to:
  /// **'Optional'**
  String get propertyAddressHint;

  /// No description provided for @propertyAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Street or address'**
  String get propertyAddressLabel;

  /// No description provided for @propertyFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get propertyFallbackName;

  /// No description provided for @propertyLabel.
  ///
  /// In en, this message translates to:
  /// **'Property'**
  String get propertyLabel;

  /// No description provided for @propertyMortgage.
  ///
  /// In en, this message translates to:
  /// **'Property / Mortgage'**
  String get propertyMortgage;

  /// No description provided for @propertyName.
  ///
  /// In en, this message translates to:
  /// **'Property name'**
  String get propertyName;

  /// No description provided for @propertyNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Montreal Triplex'**
  String get propertyNameHint;

  /// No description provided for @propertyNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Property name'**
  String get propertyNameLabel;

  /// No description provided for @propertyValue.
  ///
  /// In en, this message translates to:
  /// **'Property Value'**
  String get propertyValue;

  /// No description provided for @propertyValueLabel.
  ///
  /// In en, this message translates to:
  /// **'Property value'**
  String get propertyValueLabel;

  /// No description provided for @purchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Purchase price'**
  String get purchasePrice;

  /// No description provided for @rateAmortLine.
  ///
  /// In en, this message translates to:
  /// **'Rate: {rate}  ·  Amortization: {amort}'**
  String rateAmortLine(String amort, String rate);

  /// No description provided for @rateAppSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Enjoying the app? Leave a rating.'**
  String get rateAppSubtitle;

  /// No description provided for @rateAppTitle.
  ///
  /// In en, this message translates to:
  /// **'Rate Facture'**
  String get rateAppTitle;

  /// No description provided for @rateCompounding.
  ///
  /// In en, this message translates to:
  /// **'Rate compounding'**
  String get rateCompounding;

  /// No description provided for @rateLabel.
  ///
  /// In en, this message translates to:
  /// **'Rate: {rate}'**
  String rateLabel(String rate);

  /// No description provided for @rateType.
  ///
  /// In en, this message translates to:
  /// **'Rate type'**
  String get rateType;

  /// No description provided for @recurringAnnualizedNote.
  ///
  /// In en, this message translates to:
  /// **'Based on recurring items, annualized. One-time items excluded.'**
  String get recurringAnnualizedNote;

  /// No description provided for @refinanceMonthlyPayment.
  ///
  /// In en, this message translates to:
  /// **'Refinance monthly payment'**
  String get refinanceMonthlyPayment;

  /// No description provided for @refinanceOption.
  ///
  /// In en, this message translates to:
  /// **'Refinance'**
  String get refinanceOption;

  /// No description provided for @refinanceOptionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Duplicate the primary scenario with new mortgage terms'**
  String get refinanceOptionSubtitle;

  /// No description provided for @refinanceScenarioName.
  ///
  /// In en, this message translates to:
  /// **'Refi {rate}% / {term}'**
  String refinanceScenarioName(String rate, String term);

  /// No description provided for @refinanceTotalInterest.
  ///
  /// In en, this message translates to:
  /// **'Refinance total interest'**
  String get refinanceTotalInterest;

  /// No description provided for @rentalIncomeLabel.
  ///
  /// In en, this message translates to:
  /// **'Rental Income'**
  String get rentalIncomeLabel;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @rowPropertyMortgage.
  ///
  /// In en, this message translates to:
  /// **'Property / mortgage'**
  String get rowPropertyMortgage;

  /// No description provided for @rowRentalIncome.
  ///
  /// In en, this message translates to:
  /// **'Rental income'**
  String get rowRentalIncome;

  /// No description provided for @rowVacancyLoss.
  ///
  /// In en, this message translates to:
  /// **'Vacancy / Income Loss'**
  String get rowVacancyLoss;

  /// No description provided for @saveFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t save. Please try again.'**
  String get saveFailed;

  /// No description provided for @saveAsScenario.
  ///
  /// In en, this message translates to:
  /// **'Save as scenario'**
  String get saveAsScenario;

  /// No description provided for @scenarioA.
  ///
  /// In en, this message translates to:
  /// **'Scenario A'**
  String get scenarioA;

  /// No description provided for @scenarioB.
  ///
  /// In en, this message translates to:
  /// **'Scenario B'**
  String get scenarioB;

  /// No description provided for @scenarioNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Refinanced at 4.5%'**
  String get scenarioNameHint;

  /// No description provided for @scenarioNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Scenario name'**
  String get scenarioNameLabel;

  /// No description provided for @scenarioNotFound.
  ///
  /// In en, this message translates to:
  /// **'Scenario not found.'**
  String get scenarioNotFound;

  /// No description provided for @scenariosTitle.
  ///
  /// In en, this message translates to:
  /// **'Scenarios'**
  String get scenariosTitle;

  /// No description provided for @scheduleSection.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get scheduleSection;

  /// No description provided for @selectPropertyScenario.
  ///
  /// In en, this message translates to:
  /// **'Select a property and scenario to begin.'**
  String get selectPropertyScenario;

  /// No description provided for @selectPropertyToBegin.
  ///
  /// In en, this message translates to:
  /// **'Select a property and scenario to begin.'**
  String get selectPropertyToBegin;

  /// No description provided for @selectScenario.
  ///
  /// In en, this message translates to:
  /// **'Select a scenario'**
  String get selectScenario;

  /// No description provided for @selectScenarioFinancing.
  ///
  /// In en, this message translates to:
  /// **'Select a scenario to edit financing.'**
  String get selectScenarioFinancing;

  /// No description provided for @selectTwoScenarios.
  ///
  /// In en, this message translates to:
  /// **'Select two different scenarios to compare.'**
  String get selectTwoScenarios;

  /// No description provided for @settingsAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAbout;

  /// No description provided for @settingsLearn.
  ///
  /// In en, this message translates to:
  /// **'Learn'**
  String get settingsLearn;

  /// No description provided for @shareDealSnapshot.
  ///
  /// In en, this message translates to:
  /// **'Share deal snapshot'**
  String get shareDealSnapshot;

  /// No description provided for @shareTaxSummary.
  ///
  /// In en, this message translates to:
  /// **'Share tax summary'**
  String get shareTaxSummary;

  /// No description provided for @sheetDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get sheetDone;

  /// No description provided for @startFrom.
  ///
  /// In en, this message translates to:
  /// **'Start from'**
  String get startFrom;

  /// No description provided for @startFromPropertySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose whether to start from scratch or copy an existing property.'**
  String get startFromPropertySubtitle;

  /// No description provided for @startFromScenarioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Copy the numbers from an existing scenario or start empty.'**
  String get startFromScenarioSubtitle;

  /// No description provided for @startFromSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose whether to start from scratch or copy an existing property.'**
  String get startFromSubtitle;

  /// No description provided for @startFromTitle.
  ///
  /// In en, this message translates to:
  /// **'Start from'**
  String get startFromTitle;

  /// No description provided for @statExpenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get statExpenses;

  /// No description provided for @statIncome.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get statIncome;

  /// No description provided for @statInterest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get statInterest;

  /// No description provided for @statInterestRate.
  ///
  /// In en, this message translates to:
  /// **'Interest Rate'**
  String get statInterestRate;

  /// No description provided for @statMortgage.
  ///
  /// In en, this message translates to:
  /// **'Mortgage'**
  String get statMortgage;

  /// No description provided for @statPrincipal.
  ///
  /// In en, this message translates to:
  /// **'Principal'**
  String get statPrincipal;

  /// No description provided for @streetAddress.
  ///
  /// In en, this message translates to:
  /// **'Street or address'**
  String get streetAddress;

  /// No description provided for @t776Header.
  ///
  /// In en, this message translates to:
  /// **'Expenses (CRA T776 categories):'**
  String get t776Header;

  /// No description provided for @taxCategoryAdvertising.
  ///
  /// In en, this message translates to:
  /// **'Advertising'**
  String get taxCategoryAdvertising;

  /// No description provided for @taxCategoryInsurance.
  ///
  /// In en, this message translates to:
  /// **'Insurance'**
  String get taxCategoryInsurance;

  /// No description provided for @taxCategoryInterest.
  ///
  /// In en, this message translates to:
  /// **'Interest'**
  String get taxCategoryInterest;

  /// No description provided for @taxCategoryMaintenanceRepairs.
  ///
  /// In en, this message translates to:
  /// **'Maintenance and repairs'**
  String get taxCategoryMaintenanceRepairs;

  /// No description provided for @taxCategoryManagementAdmin.
  ///
  /// In en, this message translates to:
  /// **'Management and administration'**
  String get taxCategoryManagementAdmin;

  /// No description provided for @taxCategoryOffice.
  ///
  /// In en, this message translates to:
  /// **'Office expenses'**
  String get taxCategoryOffice;

  /// No description provided for @taxCategoryOther.
  ///
  /// In en, this message translates to:
  /// **'Other expenses'**
  String get taxCategoryOther;

  /// No description provided for @taxCategoryProfessionalFees.
  ///
  /// In en, this message translates to:
  /// **'Professional fees'**
  String get taxCategoryProfessionalFees;

  /// No description provided for @taxCategoryPropertyTaxes.
  ///
  /// In en, this message translates to:
  /// **'Property taxes'**
  String get taxCategoryPropertyTaxes;

  /// No description provided for @taxCategoryTravel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get taxCategoryTravel;

  /// No description provided for @taxCategoryUtilities.
  ///
  /// In en, this message translates to:
  /// **'Utilities'**
  String get taxCategoryUtilities;

  /// No description provided for @taxExportBasis.
  ///
  /// In en, this message translates to:
  /// **'Based on recurring items, annualized. One-time items excluded.'**
  String get taxExportBasis;

  /// No description provided for @taxExportInterestNote.
  ///
  /// In en, this message translates to:
  /// **'Interest is an estimate (current monthly mortgage interest x 12).'**
  String get taxExportInterestNote;

  /// No description provided for @taxExportScenario.
  ///
  /// In en, this message translates to:
  /// **'Scenario: {scenarioName}'**
  String taxExportScenario(String scenarioName);

  /// No description provided for @taxExportTitle.
  ///
  /// In en, this message translates to:
  /// **'Rental income tax summary — {propertyName} ({year})'**
  String taxExportTitle(String propertyName, int year);

  /// No description provided for @taxSummary.
  ///
  /// In en, this message translates to:
  /// **'Tax summary'**
  String get taxSummary;

  /// No description provided for @taxSummaryBasisNote.
  ///
  /// In en, this message translates to:
  /// **'Based on the primary scenario \"{name}\", annualized. Mortgage interest is an estimate (current monthly interest × 12) and appears here for tax purposes only — it is still excluded from NOI.'**
  String taxSummaryBasisNote(String name);

  /// No description provided for @testRefinance.
  ///
  /// In en, this message translates to:
  /// **'Test a refinance…'**
  String get testRefinance;

  /// No description provided for @taxSummaryButton.
  ///
  /// In en, this message translates to:
  /// **'Tax summary'**
  String get taxSummaryButton;

  /// No description provided for @taxSummaryTitle.
  ///
  /// In en, this message translates to:
  /// **'Tax summary · {propertyName}'**
  String taxSummaryTitle(String propertyName);

  /// No description provided for @taxYear.
  ///
  /// In en, this message translates to:
  /// **'Tax year'**
  String get taxYear;

  /// No description provided for @toolsSection.
  ///
  /// In en, this message translates to:
  /// **'Tools'**
  String get toolsSection;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total expenses'**
  String get totalExpenses;

  /// No description provided for @totalInterestDifference.
  ///
  /// In en, this message translates to:
  /// **'Total interest difference'**
  String get totalInterestDifference;

  /// No description provided for @totalInterestNote.
  ///
  /// In en, this message translates to:
  /// **'Total interest is simulated over each loan\'s full amortization.'**
  String get totalInterestNote;

  /// No description provided for @totalInterestOverAmortization.
  ///
  /// In en, this message translates to:
  /// **'Total interest over amortization'**
  String get totalInterestOverAmortization;

  /// No description provided for @unableToCalculate.
  ///
  /// In en, this message translates to:
  /// **'Unable to calculate this scenario.\n{error}'**
  String unableToCalculate(String error);

  /// No description provided for @unableToLoadData.
  ///
  /// In en, this message translates to:
  /// **'Unable to load your data.\n{error}'**
  String unableToLoadData(String error);

  /// No description provided for @us.
  ///
  /// In en, this message translates to:
  /// **'US'**
  String get us;

  /// No description provided for @usCompounding.
  ///
  /// In en, this message translates to:
  /// **'Monthly compounding'**
  String get usCompounding;

  /// No description provided for @vacancyModeAmount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get vacancyModeAmount;

  /// No description provided for @vacancyModePercent.
  ///
  /// In en, this message translates to:
  /// **'Percent'**
  String get vacancyModePercent;

  /// No description provided for @vacancyOfGrossRent.
  ///
  /// In en, this message translates to:
  /// **'{percent} of gross rent'**
  String vacancyOfGrossRent(String percent);

  /// No description provided for @validationDownPaymentPercentRange.
  ///
  /// In en, this message translates to:
  /// **'Down payment must be less than 100%'**
  String get validationDownPaymentPercentRange;

  /// No description provided for @validationEnterAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid amount'**
  String get validationEnterAmount;

  /// No description provided for @validationEnterAnAmount.
  ///
  /// In en, this message translates to:
  /// **'Enter an amount'**
  String get validationEnterAnAmount;

  /// No description provided for @validationAmortizationRange.
  ///
  /// In en, this message translates to:
  /// **'Enter 1 to 30 years'**
  String get validationAmortizationRange;

  /// No description provided for @validationEnterName.
  ///
  /// In en, this message translates to:
  /// **'Enter a name'**
  String get validationEnterName;

  /// No description provided for @validationEnterNonNegative.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid non-negative number'**
  String get validationEnterNonNegative;

  /// No description provided for @validationEnterPercentage.
  ///
  /// In en, this message translates to:
  /// **'Enter a percentage from 0 to 100'**
  String get validationEnterPercentage;

  /// No description provided for @validationEnterPropertyName.
  ///
  /// In en, this message translates to:
  /// **'Enter a property name'**
  String get validationEnterPropertyName;

  /// No description provided for @validationEnterScenarioName.
  ///
  /// In en, this message translates to:
  /// **'Enter a scenario name'**
  String get validationEnterScenarioName;

  /// No description provided for @validationInvalidUrl.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid URL starting with http:// or https://'**
  String get validationInvalidUrl;

  /// No description provided for @validationMonthsRange.
  ///
  /// In en, this message translates to:
  /// **'Months must be between 0 and 11.'**
  String get validationMonthsRange;

  /// No description provided for @validationPercentRange.
  ///
  /// In en, this message translates to:
  /// **'Enter a percentage from 0 to 100'**
  String get validationPercentRange;

  /// No description provided for @validationDownPaymentRange.
  ///
  /// In en, this message translates to:
  /// **'Down payment must be less than the purchase price'**
  String get validationDownPaymentRange;

  /// No description provided for @amortizationCappedNote.
  ///
  /// In en, this message translates to:
  /// **'Amortization limited to 25 years with less than 20% down.'**
  String get amortizationCappedNote;

  /// No description provided for @amortizationYearsLabel.
  ///
  /// In en, this message translates to:
  /// **'Amortization (years)'**
  String get amortizationYearsLabel;

  /// No description provided for @bindingConstraintGds.
  ///
  /// In en, this message translates to:
  /// **'Housing costs are the limit (GDS ratio).'**
  String get bindingConstraintGds;

  /// No description provided for @bindingConstraintTds.
  ///
  /// In en, this message translates to:
  /// **'Total debts are the limit (TDS ratio).'**
  String get bindingConstraintTds;

  /// No description provided for @borrowingCapacityDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Estimate only, based on standard GDS/TDS guidelines and the federal mortgage stress test. Not financial advice or a pre-approval — actual lenders weigh more factors.'**
  String get borrowingCapacityDisclaimer;

  /// No description provided for @borrowingCapacityEnterTerms.
  ///
  /// In en, this message translates to:
  /// **'Enter your income and debts to see your estimate.'**
  String get borrowingCapacityEnterTerms;

  /// No description provided for @borrowingCapacitySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Estimate how much you could borrow under standard Canadian lending rules.'**
  String get borrowingCapacitySubtitle;

  /// No description provided for @borrowingCapacityTitle.
  ///
  /// In en, this message translates to:
  /// **'Borrowing capacity'**
  String get borrowingCapacityTitle;

  /// No description provided for @creditScoreNote.
  ///
  /// In en, this message translates to:
  /// **'Your credit score doesn\'t change this math — it changes the rate you qualify for. That\'s where a good score pays off.'**
  String get creditScoreNote;

  /// No description provided for @estimateBorrowingCapacity.
  ///
  /// In en, this message translates to:
  /// **'Estimate your borrowing capacity'**
  String get estimateBorrowingCapacity;

  /// No description provided for @estimatesSection.
  ///
  /// In en, this message translates to:
  /// **'Estimates'**
  String get estimatesSection;

  /// No description provided for @estimatesSectionSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Prefilled estimates for the future property — adjust anything to your situation.'**
  String get estimatesSectionSubtitle;

  /// No description provided for @expectedMortgageRate.
  ///
  /// In en, this message translates to:
  /// **'Expected mortgage rate'**
  String get expectedMortgageRate;

  /// No description provided for @expectedMortgageRateHint.
  ///
  /// In en, this message translates to:
  /// **'Typical 5-year fixed — adjust to your situation.'**
  String get expectedMortgageRateHint;

  /// No description provided for @grossAnnualIncome.
  ///
  /// In en, this message translates to:
  /// **'Gross annual household income'**
  String get grossAnnualIncome;

  /// No description provided for @incomeAndDebts.
  ///
  /// In en, this message translates to:
  /// **'Income and debts'**
  String get incomeAndDebts;

  /// No description provided for @investmentDownPaymentError.
  ///
  /// In en, this message translates to:
  /// **'For an investment property, the down payment must be at least 20% of the purchase price — about {required} on a {price} purchase.'**
  String investmentDownPaymentError(String price, String required);

  /// No description provided for @investmentPropertyNote.
  ///
  /// In en, this message translates to:
  /// **'Rough estimate — lenders assess rental properties differently and may include part of the rental income, which this tool doesn\'t model.'**
  String get investmentPropertyNote;

  /// No description provided for @maxMortgageAmount.
  ///
  /// In en, this message translates to:
  /// **'Maximum mortgage'**
  String get maxMortgageAmount;

  /// No description provided for @maxPurchasePrice.
  ///
  /// In en, this message translates to:
  /// **'Maximum purchase price'**
  String get maxPurchasePrice;

  /// No description provided for @minimumDownPayment.
  ///
  /// In en, this message translates to:
  /// **'Minimum down payment'**
  String get minimumDownPayment;

  /// No description provided for @monthlyDebtPayments.
  ///
  /// In en, this message translates to:
  /// **'Existing monthly debt payments'**
  String get monthlyDebtPayments;

  /// No description provided for @monthlyHeating.
  ///
  /// In en, this message translates to:
  /// **'Monthly heating estimate'**
  String get monthlyHeating;

  /// No description provided for @monthlyPaymentAtContractRate.
  ///
  /// In en, this message translates to:
  /// **'Monthly payment (at your rate)'**
  String get monthlyPaymentAtContractRate;

  /// No description provided for @mortgageAmortization.
  ///
  /// In en, this message translates to:
  /// **'Mortgage amortization'**
  String get mortgageAmortization;

  /// No description provided for @mortgageAmortizationHint.
  ///
  /// In en, this message translates to:
  /// **'How many years to pay off the loan — longer means smaller payments but more interest.'**
  String get mortgageAmortizationHint;

  /// No description provided for @percentValue.
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String percentValue(Object value);

  /// No description provided for @propertyTaxPercent.
  ///
  /// In en, this message translates to:
  /// **'Property tax (% of price)'**
  String get propertyTaxPercent;

  /// No description provided for @propertyUseInvestment.
  ///
  /// In en, this message translates to:
  /// **'Investment property'**
  String get propertyUseInvestment;

  /// No description provided for @propertyUseLabel.
  ///
  /// In en, this message translates to:
  /// **'Property use'**
  String get propertyUseLabel;

  /// No description provided for @propertyUsePrincipal.
  ///
  /// In en, this message translates to:
  /// **'Principal residence'**
  String get propertyUsePrincipal;

  /// No description provided for @qualifyingRate.
  ///
  /// In en, this message translates to:
  /// **'Qualifying rate (stress test)'**
  String get qualifyingRate;

  /// No description provided for @rateSensitivity.
  ///
  /// In en, this message translates to:
  /// **'Rate sensitivity'**
  String get rateSensitivity;

  /// No description provided for @validationEnterPositive.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid positive number'**
  String get validationEnterPositive;

  /// No description provided for @versionLabel.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String versionLabel(String version);

  /// No description provided for @viewListing.
  ///
  /// In en, this message translates to:
  /// **'View listing'**
  String get viewListing;

  /// No description provided for @whatIfDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'This is a what-if comparison, not a lender offer.'**
  String get whatIfDisclaimer;

  /// No description provided for @whatIs.
  ///
  /// In en, this message translates to:
  /// **'What is {title}?'**
  String whatIs(String title);

  /// No description provided for @invoicesTitle.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get invoicesTitle;

  /// No description provided for @invoicesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No invoices yet'**
  String get invoicesEmptyTitle;

  /// No description provided for @invoicesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create your first invoice to get started.'**
  String get invoicesEmptySubtitle;

  /// No description provided for @done.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// No description provided for @invoiceNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New invoice'**
  String get invoiceNewTitle;

  /// No description provided for @invoiceEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit invoice'**
  String get invoiceEditTitle;

  /// No description provided for @invoiceNumberLabel.
  ///
  /// In en, this message translates to:
  /// **'Invoice number'**
  String get invoiceNumberLabel;

  /// No description provided for @invoiceClientLabel.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get invoiceClientLabel;

  /// No description provided for @invoiceSelectClient.
  ///
  /// In en, this message translates to:
  /// **'Select a client'**
  String get invoiceSelectClient;

  /// No description provided for @invoiceClientRequired.
  ///
  /// In en, this message translates to:
  /// **'Please select a client.'**
  String get invoiceClientRequired;

  /// No description provided for @invoiceNewClient.
  ///
  /// In en, this message translates to:
  /// **'New client'**
  String get invoiceNewClient;

  /// No description provided for @invoiceIssueDate.
  ///
  /// In en, this message translates to:
  /// **'Issue date'**
  String get invoiceIssueDate;

  /// No description provided for @invoiceDueDate.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get invoiceDueDate;

  /// No description provided for @invoiceStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get invoiceStatusLabel;

  /// No description provided for @statusDraft.
  ///
  /// In en, this message translates to:
  /// **'Draft'**
  String get statusDraft;

  /// No description provided for @statusSent.
  ///
  /// In en, this message translates to:
  /// **'Sent'**
  String get statusSent;

  /// No description provided for @statusPaid.
  ///
  /// In en, this message translates to:
  /// **'Paid'**
  String get statusPaid;

  /// No description provided for @statusOverdue.
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get statusOverdue;

  /// No description provided for @invoiceChargeTaxes.
  ///
  /// In en, this message translates to:
  /// **'Charge TPS/TVQ'**
  String get invoiceChargeTaxes;

  /// No description provided for @invoiceChargeTaxesHelper.
  ///
  /// In en, this message translates to:
  /// **'Turn off if you\'re a small supplier (not registered for TPS/TVQ).'**
  String get invoiceChargeTaxesHelper;

  /// No description provided for @invoiceLinesLabel.
  ///
  /// In en, this message translates to:
  /// **'Line items'**
  String get invoiceLinesLabel;

  /// No description provided for @invoiceAddLine.
  ///
  /// In en, this message translates to:
  /// **'Add line'**
  String get invoiceAddLine;

  /// No description provided for @invoiceLineDescription.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get invoiceLineDescription;

  /// No description provided for @invoiceLineQty.
  ///
  /// In en, this message translates to:
  /// **'Qty'**
  String get invoiceLineQty;

  /// No description provided for @invoiceLineUnitPrice.
  ///
  /// In en, this message translates to:
  /// **'Unit price'**
  String get invoiceLineUnitPrice;

  /// No description provided for @invoiceLinesRequired.
  ///
  /// In en, this message translates to:
  /// **'Add at least one line item.'**
  String get invoiceLinesRequired;

  /// No description provided for @invoiceNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get invoiceNotesLabel;

  /// No description provided for @invoiceNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your business…'**
  String get invoiceNotesHint;

  /// No description provided for @invoiceSubtotal.
  ///
  /// In en, this message translates to:
  /// **'Subtotal'**
  String get invoiceSubtotal;

  /// No description provided for @invoiceTotal.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get invoiceTotal;

  /// No description provided for @invoiceDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete invoice?'**
  String get invoiceDeleteTitle;

  /// No description provided for @invoiceDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Invoice \"{number}\" will be permanently deleted.'**
  String invoiceDeleteMessage(Object number);

  /// No description provided for @invoiceDueOn.
  ///
  /// In en, this message translates to:
  /// **'Due {date}'**
  String invoiceDueOn(Object date);

  /// No description provided for @newInvoice.
  ///
  /// In en, this message translates to:
  /// **'New invoice'**
  String get newInvoice;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @navInvoices.
  ///
  /// In en, this message translates to:
  /// **'Invoices'**
  String get navInvoices;

  /// No description provided for @navClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get navClients;

  /// No description provided for @clientsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No clients yet'**
  String get clientsEmptyTitle;

  /// No description provided for @clientsEmptyMessage.
  ///
  /// In en, this message translates to:
  /// **'Add your first client to start billing them.'**
  String get clientsEmptyMessage;

  /// No description provided for @clientsAddClient.
  ///
  /// In en, this message translates to:
  /// **'Add client'**
  String get clientsAddClient;

  /// Hint text in the client directory search field
  ///
  /// In en, this message translates to:
  /// **'Search clients'**
  String get clientsSearchHint;

  /// Tooltip for clearing the client search field
  ///
  /// In en, this message translates to:
  /// **'Clear search'**
  String get clientsSearchClear;

  /// Tooltip for the client sort button
  ///
  /// In en, this message translates to:
  /// **'Sort clients'**
  String get clientsSortBy;

  /// Title of the client sort action sheet
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get clientsSortTitle;

  /// Client sort option: name ascending
  ///
  /// In en, this message translates to:
  /// **'Name (A–Z)'**
  String get clientsSortNameAsc;

  /// Client sort option: name descending
  ///
  /// In en, this message translates to:
  /// **'Name (Z–A)'**
  String get clientsSortNameDesc;

  /// Client sort option: newest first
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get clientsSortNewest;

  /// Client sort option: oldest first
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get clientsSortOldest;

  /// Empty state title when client search has no results
  ///
  /// In en, this message translates to:
  /// **'No matching clients'**
  String get clientsNoResultsTitle;

  /// Empty state message when client search has no results
  ///
  /// In en, this message translates to:
  /// **'Try a different search.'**
  String get clientsNoResultsMessage;

  /// No description provided for @clientNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New client'**
  String get clientNewTitle;

  /// No description provided for @clientEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Edit client'**
  String get clientEditTitle;

  /// No description provided for @clientNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get clientNameLabel;

  /// No description provided for @clientNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the client\'s name.'**
  String get clientNameRequired;

  /// No description provided for @clientEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get clientEmailLabel;

  /// No description provided for @clientPhoneLabel.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get clientPhoneLabel;

  /// No description provided for @clientAddressLabel.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get clientAddressLabel;

  /// No description provided for @clientNotesLabel.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get clientNotesLabel;

  /// No description provided for @clientNotesHint.
  ///
  /// In en, this message translates to:
  /// **'Payment terms, contact person…'**
  String get clientNotesHint;

  /// No description provided for @clientDeleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete client?'**
  String get clientDeleteTitle;

  /// No description provided for @clientDeleteMessage.
  ///
  /// In en, this message translates to:
  /// **'\"{name}\" will be permanently deleted.'**
  String clientDeleteMessage(Object name);

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @guideStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Add your client'**
  String get guideStep1Title;

  /// No description provided for @guideStep1Text.
  ///
  /// In en, this message translates to:
  /// **'Save the businesses you bill, with their contact details.'**
  String get guideStep1Text;

  /// No description provided for @guideStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Create an invoice'**
  String get guideStep2Title;

  /// No description provided for @guideStep2Text.
  ///
  /// In en, this message translates to:
  /// **'Add line items — TPS and TVQ are computed automatically.'**
  String get guideStep2Text;

  /// No description provided for @guideStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Send the PDF'**
  String get guideStep3Title;

  /// No description provided for @guideStep3Text.
  ///
  /// In en, this message translates to:
  /// **'Export a clean PDF and share it with your client.'**
  String get guideStep3Text;

  /// No description provided for @tpsTvqTitle.
  ///
  /// In en, this message translates to:
  /// **'Understanding TPS/TVQ'**
  String get tpsTvqTitle;

  /// No description provided for @tpsTvqSubtitle.
  ///
  /// In en, this message translates to:
  /// **'How Québec sales taxes work.'**
  String get tpsTvqSubtitle;

  /// No description provided for @tpsTvqBody1.
  ///
  /// In en, this message translates to:
  /// **'TPS (5%) applies to the pre-tax amount of each line.'**
  String get tpsTvqBody1;

  /// No description provided for @tpsTvqBody2.
  ///
  /// In en, this message translates to:
  /// **'TVQ (9.975%) applies to the amount including TPS — a tax on a tax. This is the Québec rule most generic tools get wrong.'**
  String get tpsTvqBody2;

  /// No description provided for @tpsTvqBody3.
  ///
  /// In en, this message translates to:
  /// **'Each tax is rounded to the nearest cent per line, then summed. If your taxable sales are \$30,000 or less, you may not need to register or charge taxes at all.'**
  String get tpsTvqBody3;

  /// No description provided for @toolsTaxCalculator.
  ///
  /// In en, this message translates to:
  /// **'TPS/TVQ calculator'**
  String get toolsTaxCalculator;

  /// No description provided for @toolsTaxCalculatorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add taxes or extract them from a total.'**
  String get toolsTaxCalculatorSubtitle;

  /// No description provided for @calcAmountLabel.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get calcAmountLabel;

  /// No description provided for @calcAddTaxes.
  ///
  /// In en, this message translates to:
  /// **'Add taxes'**
  String get calcAddTaxes;

  /// No description provided for @calcExtractTaxes.
  ///
  /// In en, this message translates to:
  /// **'Taxes included'**
  String get calcExtractTaxes;

  /// No description provided for @calcPreTaxAmount.
  ///
  /// In en, this message translates to:
  /// **'Pre-tax amount'**
  String get calcPreTaxAmount;

  /// No description provided for @calcTotalWithTaxes.
  ///
  /// In en, this message translates to:
  /// **'Total with taxes'**
  String get calcTotalWithTaxes;

  /// No description provided for @dashboardUnpaid.
  ///
  /// In en, this message translates to:
  /// **'Unpaid'**
  String get dashboardUnpaid;

  /// No description provided for @dashboardPaidMonth.
  ///
  /// In en, this message translates to:
  /// **'Paid this month'**
  String get dashboardPaidMonth;

  /// No description provided for @dashboardClients.
  ///
  /// In en, this message translates to:
  /// **'Clients'**
  String get dashboardClients;

  /// No description provided for @dashboardSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search invoices'**
  String get dashboardSearchHint;

  /// No description provided for @dashboardFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get dashboardFilterAll;

  /// No description provided for @dashboardNoResultsTitle.
  ///
  /// In en, this message translates to:
  /// **'No invoices found'**
  String get dashboardNoResultsTitle;

  /// No description provided for @dashboardNoResultsMessage.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your search or filter.'**
  String get dashboardNoResultsMessage;

  /// No description provided for @proTitle.
  ///
  /// In en, this message translates to:
  /// **'Facture Pro'**
  String get proTitle;

  /// No description provided for @proSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock unlimited invoicing'**
  String get proSubtitle;

  /// No description provided for @proFeatureUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Unlimited invoices'**
  String get proFeatureUnlimited;

  /// No description provided for @proFeatureOneTime.
  ///
  /// In en, this message translates to:
  /// **'One-time purchase — yours forever'**
  String get proFeatureOneTime;

  /// No description provided for @proFeatureNoSubscription.
  ///
  /// In en, this message translates to:
  /// **'No subscription, no ads'**
  String get proFeatureNoSubscription;

  /// No description provided for @proBuy.
  ///
  /// In en, this message translates to:
  /// **'Buy for {price}'**
  String proBuy(String price);

  /// No description provided for @proActive.
  ///
  /// In en, this message translates to:
  /// **'Pro active'**
  String get proActive;

  /// No description provided for @proRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get proRestore;

  /// No description provided for @proRestoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring…'**
  String get proRestoring;

  /// No description provided for @proNoticeUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Purchases are unavailable right now. Please try again later.'**
  String get proNoticeUnavailable;

  /// No description provided for @proNoticeFailed.
  ///
  /// In en, this message translates to:
  /// **'The purchase didn\'t go through. Please try again.'**
  String get proNoticeFailed;

  /// No description provided for @proNoticeRestored.
  ///
  /// In en, this message translates to:
  /// **'Your Pro purchase was restored.'**
  String get proNoticeRestored;

  /// No description provided for @proNoticeNothingToRestore.
  ///
  /// In en, this message translates to:
  /// **'No previous purchase found for this Apple ID.'**
  String get proNoticeNothingToRestore;

  /// No description provided for @proFinePrint.
  ///
  /// In en, this message translates to:
  /// **'Payment is charged to your Apple ID. One-time purchase, no subscription.'**
  String get proFinePrint;

  /// No description provided for @proFreeLimit.
  ///
  /// In en, this message translates to:
  /// **'Free plan: {used} of {total} invoices used'**
  String proFreeLimit(int used, int total);

  /// No description provided for @settingsPro.
  ///
  /// In en, this message translates to:
  /// **'Facture Pro'**
  String get settingsPro;

  /// No description provided for @settingsProSubtitleActive.
  ///
  /// In en, this message translates to:
  /// **'Unlimited invoices'**
  String get settingsProSubtitleActive;

  /// No description provided for @settingsProSection.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get settingsProSection;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
