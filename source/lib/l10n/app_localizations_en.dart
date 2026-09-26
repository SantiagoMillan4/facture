// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get aboutSection => 'About';

  @override
  String get acquisitionOwned => 'Already own';

  @override
  String get acquisitionPurchase => 'Evaluating a purchase';

  @override
  String get acquisitionTypeHint =>
      'Are you evaluating a purchase, or do you already own this property?';

  @override
  String get acquisitionTypeLabel => 'Property status';

  @override
  String acrossProperties(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'properties',
      one: 'property',
    );
    return 'across $_temp0';
  }

  @override
  String get actionDelete => 'Delete';

  @override
  String get actionEdit => 'Edit';

  @override
  String get add => 'Add';

  @override
  String get addExpense => 'Add expense';

  @override
  String get addExpenseButton => 'Add expense';

  @override
  String get addExpenseSubtitle =>
      'Add a recurring operating cost for this scenario.';

  @override
  String get addExpenseTitle => 'Add expense';

  @override
  String get addIncome => 'Add income';

  @override
  String get addIncomeButton => 'Add income';

  @override
  String get addIncomeSubtitle =>
      'Add a recurring revenue stream for this scenario.';

  @override
  String get addIncomeTitle => 'Add income';

  @override
  String get addNotes => 'Add notes';

  @override
  String get addProperty => 'Add property';

  @override
  String get addPropertyForPortfolio => 'Add a property to see your portfolio.';

  @override
  String get addPropertySubtitle =>
      'Create a property to start tracking its cash flow.';

  @override
  String get addPropertyTitle => 'Add Property';

  @override
  String get addPropertyToCompare =>
      'Add a property to start comparing scenarios.';

  @override
  String get addScenario => 'Add scenario';

  @override
  String get addScenarioTitle => 'Add Scenario';

  @override
  String get addStreetAddress => 'Add street or address';

  @override
  String get addressLabel => 'Address';

  @override
  String get addressPlaceholder => 'Add street or address';

  @override
  String get allProperties => 'All Properties';

  @override
  String get amortMonths => 'Amortization months';

  @override
  String get amortMonthsLabel => 'Amortization (months)';

  @override
  String amortShort(int months, int years) {
    return '${years}y ${months}m';
  }

  @override
  String get amortYears => 'Amortization years';

  @override
  String get amortYearsLabel => 'Amortization (years)';

  @override
  String amortYearsShort(int years) {
    return '${years}y';
  }

  @override
  String get amortizationLabel => 'Amortization';

  @override
  String amortizationValue(String value) {
    return 'Amortization: $value';
  }

  @override
  String amortizationYearsMonths(int months, int years) {
    return '$years years $months months';
  }

  @override
  String get amountHint => '0.00';

  @override
  String get amountLabel => 'Amount';

  @override
  String get amountModeFixed => 'Amount';

  @override
  String get amountModePercent => '% of income';

  @override
  String get analyzeAction => 'Analyze';

  @override
  String get annual => 'Annual';

  @override
  String annualAfterFinancing(String amount) {
    return 'Annual $amount after financing';
  }

  @override
  String annualCashFlow(String amount) {
    return 'Annual $amount after financing';
  }

  @override
  String get annualLabel => 'Annual';

  @override
  String get annualRunRate => 'Annual run rate';

  @override
  String annualizedPrimaryNote(String name) {
    return 'Based on the primary scenario \"$name\", annualized.';
  }

  @override
  String get appTitle => 'Facture';

  @override
  String get balanceLabel => 'Balance';

  @override
  String balanceEndOfYear(int year) {
    return 'Balance at end of year $year';
  }

  @override
  String get businessAddressHint => 'Street, city, postal code';

  @override
  String get businessAddressLabel => 'Address';

  @override
  String get businessDisclaimer =>
      'You\'re responsible for the accuracy of your business info and tax status. Facture doesn\'t provide tax advice.';

  @override
  String get businessEmailLabel => 'Email';

  @override
  String get businessNameHint => 'e.g. Atelier Nord';

  @override
  String get businessNameLabel => 'Business name';

  @override
  String get businessNameRequired => 'Enter your business name';

  @override
  String get businessPhoneLabel => 'Phone';

  @override
  String get businessProfileSubtitle => 'Name, contact, TPS/TVQ status';

  @override
  String get businessProfileTitle => 'Business profile';

  @override
  String get businessTaxStatusHelper =>
      'Small suppliers (\$30,000 or less in taxable sales over the last four quarters) aren\'t required to register and must not charge TPS/TVQ.';

  @override
  String get businessTaxStatusLabel => 'TPS/TVQ registration';

  @override
  String get businessTaxStatusRegistered => 'Registered';

  @override
  String get businessTaxStatusRegisteredSub => 'Charges TPS/TVQ';

  @override
  String get businessTaxStatusSmallSupplier => 'Small supplier';

  @override
  String get businessTaxStatusSmallSupplierSub => 'No taxes charged';

  @override
  String get businessTpsNumberHint => '123456789RT0001';

  @override
  String get businessTpsNumberLabel => 'TPS registration number';

  @override
  String get businessTvqNumberHint => '1234567890TQ0001';

  @override
  String get businessTvqNumberLabel => 'TVQ registration number';

  @override
  String firstMonthOfYear(int year) {
    return 'First month of year $year';
  }

  @override
  String get invoiceBackToDraft => 'Back to draft';

  @override
  String get invoiceChangeStatus => 'Change status';

  @override
  String get invoiceMarkPaid => 'Mark as paid';

  @override
  String get invoiceMarkSent => 'Mark as sent';

  @override
  String invoicePaidOn(String date) {
    return 'Paid $date';
  }

  @override
  String get invoiceProfileNudge =>
      'Add your business info and tax numbers to appear on your invoices.';

  @override
  String get invoiceProfileNudgeAction => 'Set up';

  @override
  String get invoiceReopenAsSent => 'Reopen as sent';

  @override
  String get invoiceSharePdf => 'Share PDF';

  @override
  String get emailTemplateTitle => 'Email template';

  @override
  String get emailTemplateSubtitle =>
      'Subject and message used when emailing an invoice — insert the placeholders below';

  @override
  String get emailTemplateSubjectLabel => 'Subject';

  @override
  String get emailTemplateBodyLabel => 'Message';

  @override
  String get emailTemplateSubjectRequired => 'Enter a subject';

  @override
  String get emailTemplateBodyRequired => 'Enter a message';

  @override
  String get emailTemplatePlaceholdersTitle => 'Placeholders';

  @override
  String get emailTemplatePlaceholdersHint =>
      'Replaced automatically when the email opens.';

  @override
  String get emailTemplateReset => 'Reset to default';

  @override
  String get invoiceSendEmail => 'Send by email';

  @override
  String get invoicePreviewSend => 'Send invoice';

  @override
  String get invoicePreviewEdit => 'Edit invoice';

  @override
  String get invoicePreviewNotFound => 'This invoice no longer exists.';

  @override
  String get invoiceEmailFailed => 'Couldn\'t open the email composer.';

  @override
  String get invoiceNoClientEmailTitle => 'No email address';

  @override
  String invoiceNoClientEmailMessage(String name) {
    return 'Add an email address for $name to send them the invoice.';
  }

  @override
  String get invoiceNoClientEmailAdd => 'Add email';

  @override
  String get primaryScenarioSection => 'Primary scenario';

  @override
  String get primaryScenarioSectionSubtitle =>
      'The primary scenario holds your main assumptions — you can add more later to compare.';

  @override
  String get primaryScenarioCopyHelper =>
      'Only applies when starting from scratch — a copied property keeps its scenarios\' names.';

  @override
  String get propertyDetails => 'Property details';

  @override
  String get scenarioName => 'Scenario name';

  @override
  String get primaryScenarioNameHint => 'e.g. Base case';

  @override
  String get bar => 'Bar';

  @override
  String get barChart => 'Bar';

  @override
  String get basedOn => 'Based on';

  @override
  String get basedOnLabel => 'Based on';

  @override
  String get byProperty => 'By property';

  @override
  String buyingDerivedLine(String balance, String percent) {
    return 'Balance: $balance · $percent% down';
  }

  @override
  String get calcError => 'Unable to calculate this scenario.';

  @override
  String get calculated => 'Calculated';

  @override
  String get calculatedPayment => 'Calculated payment';

  @override
  String get canada => 'Canada';

  @override
  String get canadaCompounding => 'Semi-annual compounding';

  @override
  String get canadaUsExplainer =>
      'Canadian mortgages compound semi-annually; US mortgages compound monthly.';

  @override
  String get cannotDeleteLastScenario =>
      'A property must keep at least one scenario.';

  @override
  String get cannotOpenUrl => 'Couldn\'t open the link';

  @override
  String get capRateLabel => 'Cap Rate';

  @override
  String get cashFlowComparison => 'Cash flow comparison';

  @override
  String get cashFlowLabel => 'Cash Flow';

  @override
  String get cashOnCashLabel => 'Cash-on-Cash';

  @override
  String get categoryField => 'Category';

  @override
  String get categoryInsurance => 'Insurance';

  @override
  String get categoryMaintenance => 'Maintenance';

  @override
  String get categoryOther => 'Other';

  @override
  String get categoryParking => 'Parking';

  @override
  String get categoryPropertyManagement => 'Property Management';

  @override
  String get categoryPropertyTax => 'Property Tax';

  @override
  String get categoryRent => 'Rent';

  @override
  String get categoryRepairs => 'Repairs';

  @override
  String get categoryStorage => 'Storage';

  @override
  String get categoryUtilities => 'Utilities';

  @override
  String get chartDisplayBy => 'Chart display by';

  @override
  String get classificationSection => 'Classification';

  @override
  String get comparisonTitle => 'Comparison';

  @override
  String get compoundingHelper =>
      'The same nominal rate gives a slightly lower payment with semi-annual compounding.';

  @override
  String get compoundingLabel => 'Compounding';

  @override
  String get confirm => 'Confirm';

  @override
  String get convCashFlow => 'Cash flow = NOI − financing costs.';

  @override
  String get convCompounding =>
      'Canadian mortgages compound semi-annually; US mortgages compound monthly. New mortgages default to Canadian semi-annual.';

  @override
  String get convFrequencies =>
      'Frequencies are normalized: yearly ÷ 12, weekly × 52 ÷ 12.';

  @override
  String get convNoi =>
      'NOI (net operating income) = effective income − operating expenses. Mortgage payments are excluded from NOI.';

  @override
  String get convOneTime =>
      'One-time items are stored but excluded from recurring monthly figures.';

  @override
  String get convPrimary =>
      'The primary scenario is the reference for portfolio totals.';

  @override
  String get convVacancy =>
      'Vacancy / income loss is a regular expense: enter a fixed amount or a percent of gross income.';

  @override
  String get conventionCashFlow => 'Cash flow = NOI − financing costs.';

  @override
  String get conventionCompounding =>
      'Canadian mortgages compound semi-annually; US mortgages compound monthly. New mortgages default to Canadian semi-annual.';

  @override
  String get conventionFrequencies =>
      'Frequencies are normalized: yearly ÷ 12, weekly × 52 ÷ 12.';

  @override
  String get conventionNoi =>
      'NOI (net operating income) = effective income − operating expenses. Mortgage payments are excluded from NOI.';

  @override
  String get conventionOneTime =>
      'One-time items are stored but excluded from recurring monthly figures.';

  @override
  String get conventionPrimary =>
      'The primary scenario is the reference for portfolio totals.';

  @override
  String get conventionVacancy =>
      'Vacancy / income loss is a percentage of gross scheduled income.';

  @override
  String get copyScenarioHint =>
      'Copy the numbers from an existing scenario or start empty.';

  @override
  String get createPropertySubtitle =>
      'Create a property to start tracking its cash flow.';

  @override
  String get createScenarioSubtitle =>
      'Model a what-if variant (refinance, rent increase, new purchase) without touching your primary scenario.';

  @override
  String get csvHeader => 'Category,Amount';

  @override
  String get currentMonthlyPayment => 'Current monthly payment';

  @override
  String get currentMortgageBalance => 'Current mortgage balance';

  @override
  String get currentScenario => 'Current scenario';

  @override
  String get currentTotalInterest => 'Current total interest';

  @override
  String get dashboardMonthlyPerformance => 'Monthly performance';

  @override
  String dataInvalidError(String error) {
    return 'The local data has an invalid value: $error';
  }

  @override
  String dataReadError(String error) {
    return 'The local data could not be read: $error';
  }

  @override
  String get dataSaveError => 'The local data could not be saved.';

  @override
  String dataSaveErrorDetail(String error) {
    return 'The local data could not be saved: $error';
  }

  @override
  String dealCapRate(String value) {
    return 'Cap rate: $value';
  }

  @override
  String dealCashFlow(String amount) {
    return 'Monthly cash flow: $amount';
  }

  @override
  String dealCashOnCash(String value) {
    return 'Cash-on-cash return: $value';
  }

  @override
  String dealDownPayment(String amount) {
    return 'Down payment: $amount';
  }

  @override
  String dealDscr(String value) {
    return 'DSCR: $value';
  }

  @override
  String dealGrossRent(String amount) {
    return 'Gross monthly rent: $amount';
  }

  @override
  String dealMonthlyPayment(String amount) {
    return 'Monthly mortgage payment: $amount';
  }

  @override
  String dealPurchasePrice(String amount) {
    return 'Purchase price: $amount';
  }

  @override
  String dealScenario(String scenarioName) {
    return 'Scenario: $scenarioName';
  }

  @override
  String dealSnapshotTitle(String propertyName) {
    return 'Deal snapshot — $propertyName';
  }

  @override
  String get delete => 'Delete';

  @override
  String get deleteItemMessage => 'Are you sure you want to delete this item?';

  @override
  String get deleteItemTitle => 'Delete?';

  @override
  String deletePropertyConfirm(String name) {
    return 'Delete \"$name\" and its scenarios?';
  }

  @override
  String get deletePropertyMessage =>
      'This will also delete all scenarios associated with this property.';

  @override
  String get deletePropertyTitle => 'Delete property?';

  @override
  String get deleteScenarioMessage =>
      'Are you sure you want to delete this scenario?';

  @override
  String get deleteScenarioTitle => 'Delete scenario?';

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get dialogConfirm => 'Confirm';

  @override
  String get dialogDelete => 'Delete';

  @override
  String get dialogOk => 'OK';

  @override
  String get dialogSave => 'Save';

  @override
  String get dscrLabel => 'DSCR';

  @override
  String get downPayment => 'Down payment';

  @override
  String get downPaymentCustomOption => 'Custom amount';

  @override
  String get downPaymentMinimumHint => 'CMHC tiers: 5% / 10% / 20%';

  @override
  String get downPaymentMinimumHintInvestment =>
      '20% minimum — rentals can\'t be mortgage-insured';

  @override
  String get downPaymentMinimumOption => 'Minimum';

  @override
  String get downPaymentModeLabel => 'Down payment';

  @override
  String get downPaymentPercentMode => 'Down payment (%)';

  @override
  String get duplicatePropertyName =>
      'A property with this name already exists.';

  @override
  String get duplicateScenarioName =>
      'A scenario with this name already exists for this property.';

  @override
  String get eachPropertyPrimary =>
      'Each property is represented by its primary scenario.';

  @override
  String get eachSideNeedsScenario => 'Each side needs a scenario to compare.';

  @override
  String get edit => 'Edit';

  @override
  String get editExpense => 'Edit expense';

  @override
  String get editExpenseSubtitle => 'Update this expense item.';

  @override
  String get editExpenseTitle => 'Edit expense';

  @override
  String get editIncome => 'Edit income';

  @override
  String get editIncomeSubtitle => 'Update this income item.';

  @override
  String get editIncomeTitle => 'Edit income';

  @override
  String get editMortgage => 'Edit mortgage';

  @override
  String get editProperty => 'Edit property';

  @override
  String get editPropertyName => 'Edit property name';

  @override
  String get editPropertySubtitle => 'Update the property details.';

  @override
  String get editPropertyTitle => 'Edit property';

  @override
  String get editStreetAddress => 'Edit street or address';

  @override
  String get emptyExpenseMessage =>
      'Add your first operating expense to complete the picture.';

  @override
  String get emptyExpenseTitle => 'No expenses yet';

  @override
  String get emptyIncomeMessage =>
      'Add your first income source to see your cash flow take shape.';

  @override
  String get emptyIncomeTitle => 'No income yet';

  @override
  String get errorTitle => 'Something went wrong';

  @override
  String get enterMortgageDetails =>
      'Enter the balance, rate, and amortization; the app computes the monthly payment.';

  @override
  String get enterValidTerms => 'Enter valid refinance terms to compare.';

  @override
  String get estimatedMonthlyPayment => 'Estimated monthly payment';

  @override
  String get expenseNameHint => 'e.g. Property tax';

  @override
  String get expenseTitle => 'Expense';

  @override
  String expensesTitle(String name) {
    return 'Expenses · $name';
  }

  @override
  String explainerTitle(String title) {
    return 'What is $title?';
  }

  @override
  String get fieldAmount => 'Amount';

  @override
  String get fieldCategory => 'Category';

  @override
  String get fieldFrequency => 'Frequency';

  @override
  String get fieldName => 'Name';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get financialConventions => 'Financial conventions';

  @override
  String get financialConventionsSubtitle => 'How the app computes its numbers';

  @override
  String get financingAssumptions => 'Financing assumptions for this scenario.';

  @override
  String get financingAssumptionsTitle => 'Financing assumptions';

  @override
  String get financingExcludedNote =>
      'Mortgage payment is treated as a financing cost and excluded from NOI.';

  @override
  String get financingLabel => 'Financing';

  @override
  String get formAdd => 'Add';

  @override
  String get formCancel => 'Cancel';

  @override
  String get formSave => 'Save';

  @override
  String feedbackEmailSubject(String version) {
    return 'Facture $version feedback';
  }

  @override
  String get feedbackEmailCopied =>
      'Support address copied — paste it into your mail app.';

  @override
  String get feedbackSubtitle => 'Report a bug or suggest a feature.';

  @override
  String get feedbackTitle => 'Send feedback';

  @override
  String get frequenciesNote =>
      'Frequencies are normalized: yearly ÷ 12, weekly × 52 ÷ 12.';

  @override
  String get frequencyField => 'Frequency';

  @override
  String get frequencyMonthly => 'Monthly';

  @override
  String get frequencyOneTime => 'One-time';

  @override
  String get frequencyWeekly => 'Weekly';

  @override
  String get frequencyYearly => 'Yearly';

  @override
  String get settingsBusiness => 'Business';

  @override
  String shareInvoiceSubject(String number) {
    return 'Invoice $number';
  }

  @override
  String shareInvoiceText(String number, String total) {
    return 'Here\'s invoice $number — $total.';
  }

  @override
  String get yearPickerLabel => 'Year';

  @override
  String get blank => 'Blank';

  @override
  String get generatedBy => 'Generated by Rentable.';

  @override
  String get grossRents => 'Gross rents';

  @override
  String get guideAnalysisBody =>
      'Pick two scenarios to compare them side by side: income, expenses, cash flow, financing, and the investor metrics below.';

  @override
  String get guideAnalysisTitle => 'Analysis';

  @override
  String get guideDashboardBody =>
      'The dashboard shows one property and scenario at a time, or — pick \"All Properties\" — your whole portfolio at once. The portfolio view sums each property’s primary scenario, so it always reflects your reference numbers.';

  @override
  String get guideDashboardTitle => 'Dashboard';

  @override
  String get guideIncomeBody =>
      'Add the recurring income and operating expenses of a scenario: rent, laundry, property tax, insurance, maintenance. Each item has a frequency (monthly, yearly, weekly, one-time) and is normalized to a monthly amount.\n\nVacancy / income loss is set as a percentage of gross revenue on the Expenses tab.';

  @override
  String get guideIncomeTitle => 'Income and expenses';

  @override
  String get guideMortgageBody =>
      'Enter the balance, rate, and amortization; the app computes the monthly payment. Choose the rate type that matches the loan: Canada (semi-annual compounding) or US (monthly compounding).\n\nMortgage payments are financing costs: they reduce cash flow but are excluded from NOI, the standard convention.';

  @override
  String get guideMortgageTitle => 'Mortgage';

  @override
  String get guidePropertiesBody =>
      'A property is a building you track — a multiplex, a condo, a house. Add one from the Properties tab. Everything in the app (scenarios, income, expenses, mortgage) lives under a property.';

  @override
  String get guidePropertiesTitle => 'Properties';

  @override
  String get guideScenariosBody =>
      'Each property holds one or more scenarios: what-if variants of the same building. Model a refinance, a rent increase, or a purchase offer without touching your reference numbers.\n\nOne scenario is always the primary. It is the reference used for the All Properties dashboard and marks the current reality of the building. Copy any scenario to explore alternatives, then switch the primary when the alternative becomes the plan.';

  @override
  String get guideScenariosTitle => 'Scenarios';

  @override
  String get howItWorks => 'How Facture works';

  @override
  String get howItWorksSubtitle => 'Clients, invoices and Québec taxes.';

  @override
  String get hypotheticalTerms => 'Hypothetical refinance terms';

  @override
  String get incomeNameHint => 'e.g. Unit 1 rent';

  @override
  String incomeScreenTitle(String name) {
    return 'Income · $name';
  }

  @override
  String get incomeTitle => 'Income';

  @override
  String get interestLabel => 'Interest';

  @override
  String get interestRateLabel => 'Interest rate';

  @override
  String get interestRatePercent => 'Interest rate (%)';

  @override
  String get investorMetrics => 'Investor Metrics';

  @override
  String get investorMetricsExplained => 'Investor metrics explained';

  @override
  String get investorMetricsSubtitle => 'DSCR, cap rate, cash-on-cash, LTV';

  @override
  String get investorMetricsTitle => 'Investor metrics';

  @override
  String get loanAmountLabel => 'Loan amount';

  @override
  String get loanDetails => 'Loan details';

  @override
  String get ltvDisclaimer =>
      'V1 assumption: potential borrowing is capped at 80% of property value. This is not a refinancing transaction or lender qualification result.';

  @override
  String get ltvLabel => 'LTV';

  @override
  String get listingUrlHint => 'Paste a listing link or Centris share text';

  @override
  String get listingUrlLabel => 'Listing URL';

  @override
  String get listingUrlPrefillHelper =>
      'Paste a listing link: the name, city, and units will be pre-filled.';

  @override
  String listingPlexDetected(int count) {
    return 'Plex detected: $count rent entries will be created.';
  }

  @override
  String get makePrimaryScenario => 'Make primary scenario';

  @override
  String get manageScenarios => 'Manage scenarios';

  @override
  String get manualMonthlyPayment => 'Manual monthly payment';

  @override
  String get manualOverride => 'Manual override';

  @override
  String get manualPaymentHint =>
      'Enter a manual payment only if your actual payment differs from the calculated one.';

  @override
  String get maxMortgageBalance => 'Maximum mortgage balance (80% LTV)';

  @override
  String get metricCapRate => 'Cap Rate — Capitalization Rate';

  @override
  String get metricCapRateMeaning =>
      'Annual net operating income divided by the property value. It answers: what yield would this property earn if bought all cash?';

  @override
  String get metricCapRateReading =>
      'Higher means cheaper relative to its income. Use it to compare properties regardless of how they are financed.';

  @override
  String get metricCapRateShort => 'Cap rate';

  @override
  String get metricCashOnCash => 'Cash-on-Cash Return';

  @override
  String get metricCashOnCashMeaning =>
      'Annual cash flow divided by the cash you actually invested (property value minus mortgage balance). It answers: what return am I earning on my money?';

  @override
  String get metricCashOnCashReading =>
      'Higher means your down payment works harder. Unlike cap rate, it reflects your financing.';

  @override
  String get metricCashOnCashShort => 'Cash-on-cash';

  @override
  String get metricDscr => 'DSCR — Debt-Service Coverage Ratio';

  @override
  String get metricDscrMeaning =>
      'Annual net operating income divided by annual mortgage payments. It answers: does the rent cover the loan?';

  @override
  String get metricDscrReading =>
      'Above 1.20 is comfortable and what most lenders want to see. Below 1.00 means the property does not pay for itself.';

  @override
  String get metricDscrShort => 'DSCR';

  @override
  String get metricLtv => 'LTV — Loan-to-Value';

  @override
  String get metricLtvMeaning =>
      'Mortgage balance divided by the property value. It answers: how much of the property does the lender own?';

  @override
  String get metricLtvReading =>
      'Lower means more equity cushion. Most residential lenders cap insured mortgages around 80%.';

  @override
  String get metricLtvShort => 'LTV';

  @override
  String get monthly => 'Monthly';

  @override
  String get monthlyCashFlowChart => 'MONTHLY CASH FLOW';

  @override
  String get monthlyCashFlowLabel => 'Monthly cash flow';

  @override
  String get monthlyDifference => 'Monthly difference';

  @override
  String get monthlyLabel => 'Monthly';

  @override
  String get monthlyPayment => 'Monthly payment';

  @override
  String get monthlyPaymentCalculated => 'Monthly payment (calculated)';

  @override
  String get monthlyPaymentManual => 'Monthly payment (manual override)';

  @override
  String get monthlyPerformance => 'Monthly performance';

  @override
  String get mortgageBalance => 'Mortgage balance';

  @override
  String get mortgageBalanceLabel => 'Mortgage Balance';

  @override
  String get mortgageCalculatorSubtitle => 'Estimate your monthly payment';

  @override
  String get mortgageCalculatorTitle => 'Mortgage calculator';

  @override
  String get mortgageInterestNote =>
      'Mortgage interest is an estimate (current monthly interest × 12) and appears here for tax purposes only — it is still excluded from NOI.';

  @override
  String mortgageTitle(String scenarioName) {
    return 'Mortgage · $scenarioName';
  }

  @override
  String get nameHintExpense => 'e.g. Property tax';

  @override
  String get nameHintIncome => 'e.g. Unit 1 rent';

  @override
  String get nameLabel => 'Name';

  @override
  String get navAnalysis => 'Analysis';

  @override
  String get analyzeMode => 'Analyze';

  @override
  String get compareMode => 'Compare';

  @override
  String get scenarioFieldLabel => 'Scenario';

  @override
  String get navProperties => 'Properties';

  @override
  String get navSettings => 'Settings';

  @override
  String get needScenarioEachSide =>
      'Each side needs a scenario to compare.\nAdd a scenario to continue.';

  @override
  String get netRentalIncome => 'Net rental income';

  @override
  String get newBalance => 'New balance';

  @override
  String get newInterestRate => 'New interest rate (%)';

  @override
  String get newMortgagesDefault =>
      'New mortgages default to Canadian semi-annual.';

  @override
  String get noExpenseCategories => 'No operating expense categories yet.';

  @override
  String get noExpenses => 'No operating expenses yet.';

  @override
  String get noIncomeCategories => 'No income categories yet.';

  @override
  String get noIncomeItems => 'No income items yet.';

  @override
  String get noOperatingExpenses => 'No operating expenses yet.';

  @override
  String get noScenario => 'No scenario';

  @override
  String get noiLabel => 'NOI';

  @override
  String get noiShort => 'NOI';

  @override
  String get notAvailable => 'n/a';

  @override
  String get notesField => 'Notes';

  @override
  String get notesOptional => 'Optional';

  @override
  String get ok => 'OK';

  @override
  String get oneTimeNote =>
      'One-time items are stored but excluded from recurring monthly figures.';

  @override
  String get operatingExpensesLabel => 'Operating expenses';

  @override
  String get optional => 'Optional';

  @override
  String get paymentMode => 'Payment mode';

  @override
  String perMonthShort(String amount) {
    return '$amount / mo';
  }

  @override
  String perWeekShort(String amount) {
    return '$amount / wk';
  }

  @override
  String perYearShort(String amount) {
    return '$amount / yr';
  }

  @override
  String percentOfGrossRevenue(String rate) {
    return '$rate% of gross revenue';
  }

  @override
  String get percentage => 'Percentage';

  @override
  String get persistenceLoadError => 'Unable to load local data.';

  @override
  String get pickTwoScenarios =>
      'Pick two scenarios to compare them side by side: income, expenses, cash flow, financing, and the investor metrics below.';

  @override
  String get pie => 'Pie';

  @override
  String get pieChart => 'Pie';

  @override
  String portfolioAnnualLine(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count properties',
      one: '$count property',
    );
    return 'Annual $amount across $_temp0';
  }

  @override
  String get portfolioCashFlow => 'PORTFOLIO CASH FLOW';

  @override
  String get portfolioCashFlowLabel => 'Portfolio cash flow';

  @override
  String get potentialAdditional => 'Potential additional amount';

  @override
  String get potentialRefinanceTitle => 'Potential additional refinance';

  @override
  String get ppSuffix => 'pp';

  @override
  String get primaryBadge => 'Primary';

  @override
  String get primaryForAllProperties =>
      'Primary scenario is used for All Properties calculations';

  @override
  String get primaryScenarioCalculations =>
      'Primary scenario is used for All Properties calculations';

  @override
  String get primaryScenarioNote =>
      'Each property is represented by its primary scenario.';

  @override
  String get primaryScenarioTooltip => 'Primary scenario';

  @override
  String get principalLabel => 'Principal';

  @override
  String get propertiesTitle => 'Properties';

  @override
  String get propertyActions => 'Property actions';

  @override
  String get propertyAddressHint => 'Optional';

  @override
  String get propertyAddressLabel => 'Street or address';

  @override
  String get propertyFallbackName => 'Property';

  @override
  String get propertyLabel => 'Property';

  @override
  String get propertyMortgage => 'Property / Mortgage';

  @override
  String get propertyName => 'Property name';

  @override
  String get propertyNameHint => 'e.g. Montreal Triplex';

  @override
  String get propertyNameLabel => 'Property name';

  @override
  String get propertyValue => 'Property Value';

  @override
  String get propertyValueLabel => 'Property value';

  @override
  String get purchasePrice => 'Purchase price';

  @override
  String rateAmortLine(String amort, String rate) {
    return 'Rate: $rate  ·  Amortization: $amort';
  }

  @override
  String get rateAppSubtitle => 'Enjoying the app? Leave a rating.';

  @override
  String get rateAppTitle => 'Rate Facture';

  @override
  String get rateCompounding => 'Rate compounding';

  @override
  String rateLabel(String rate) {
    return 'Rate: $rate';
  }

  @override
  String get rateType => 'Rate type';

  @override
  String get recurringAnnualizedNote =>
      'Based on recurring items, annualized. One-time items excluded.';

  @override
  String get refinanceMonthlyPayment => 'Refinance monthly payment';

  @override
  String get refinanceOption => 'Refinance';

  @override
  String get refinanceOptionSubtitle =>
      'Duplicate the primary scenario with new mortgage terms';

  @override
  String refinanceScenarioName(String rate, String term) {
    return 'Refi $rate% / $term';
  }

  @override
  String get refinanceTotalInterest => 'Refinance total interest';

  @override
  String get rentalIncomeLabel => 'Rental Income';

  @override
  String get retry => 'Retry';

  @override
  String get rowPropertyMortgage => 'Property / mortgage';

  @override
  String get rowRentalIncome => 'Rental income';

  @override
  String get rowVacancyLoss => 'Vacancy / Income Loss';

  @override
  String get saveFailed => 'Couldn\'t save. Please try again.';

  @override
  String get saveAsScenario => 'Save as scenario';

  @override
  String get scenarioA => 'Scenario A';

  @override
  String get scenarioB => 'Scenario B';

  @override
  String get scenarioNameHint => 'e.g. Refinanced at 4.5%';

  @override
  String get scenarioNameLabel => 'Scenario name';

  @override
  String get scenarioNotFound => 'Scenario not found.';

  @override
  String get scenariosTitle => 'Scenarios';

  @override
  String get scheduleSection => 'Schedule';

  @override
  String get selectPropertyScenario =>
      'Select a property and scenario to begin.';

  @override
  String get selectPropertyToBegin =>
      'Select a property and scenario to begin.';

  @override
  String get selectScenario => 'Select a scenario';

  @override
  String get selectScenarioFinancing => 'Select a scenario to edit financing.';

  @override
  String get selectTwoScenarios => 'Select two different scenarios to compare.';

  @override
  String get settingsAbout => 'About';

  @override
  String get settingsLearn => 'Learn';

  @override
  String get shareDealSnapshot => 'Share deal snapshot';

  @override
  String get shareTaxSummary => 'Share tax summary';

  @override
  String get sheetDone => 'Done';

  @override
  String get startFrom => 'Start from';

  @override
  String get startFromPropertySubtitle =>
      'Choose whether to start from scratch or copy an existing property.';

  @override
  String get startFromScenarioSubtitle =>
      'Copy the numbers from an existing scenario or start empty.';

  @override
  String get startFromSubtitle =>
      'Choose whether to start from scratch or copy an existing property.';

  @override
  String get startFromTitle => 'Start from';

  @override
  String get statExpenses => 'Expenses';

  @override
  String get statIncome => 'Income';

  @override
  String get statInterest => 'Interest';

  @override
  String get statInterestRate => 'Interest Rate';

  @override
  String get statMortgage => 'Mortgage';

  @override
  String get statPrincipal => 'Principal';

  @override
  String get streetAddress => 'Street or address';

  @override
  String get t776Header => 'Expenses (CRA T776 categories):';

  @override
  String get taxCategoryAdvertising => 'Advertising';

  @override
  String get taxCategoryInsurance => 'Insurance';

  @override
  String get taxCategoryInterest => 'Interest';

  @override
  String get taxCategoryMaintenanceRepairs => 'Maintenance and repairs';

  @override
  String get taxCategoryManagementAdmin => 'Management and administration';

  @override
  String get taxCategoryOffice => 'Office expenses';

  @override
  String get taxCategoryOther => 'Other expenses';

  @override
  String get taxCategoryProfessionalFees => 'Professional fees';

  @override
  String get taxCategoryPropertyTaxes => 'Property taxes';

  @override
  String get taxCategoryTravel => 'Travel';

  @override
  String get taxCategoryUtilities => 'Utilities';

  @override
  String get taxExportBasis =>
      'Based on recurring items, annualized. One-time items excluded.';

  @override
  String get taxExportInterestNote =>
      'Interest is an estimate (current monthly mortgage interest x 12).';

  @override
  String taxExportScenario(String scenarioName) {
    return 'Scenario: $scenarioName';
  }

  @override
  String taxExportTitle(String propertyName, int year) {
    return 'Rental income tax summary — $propertyName ($year)';
  }

  @override
  String get taxSummary => 'Tax summary';

  @override
  String taxSummaryBasisNote(String name) {
    return 'Based on the primary scenario \"$name\", annualized. Mortgage interest is an estimate (current monthly interest × 12) and appears here for tax purposes only — it is still excluded from NOI.';
  }

  @override
  String get testRefinance => 'Test a refinance…';

  @override
  String get taxSummaryButton => 'Tax summary';

  @override
  String taxSummaryTitle(String propertyName) {
    return 'Tax summary · $propertyName';
  }

  @override
  String get taxYear => 'Tax year';

  @override
  String get totalExpenses => 'Total expenses';

  @override
  String get totalInterestDifference => 'Total interest difference';

  @override
  String get totalInterestNote =>
      'Total interest is simulated over each loan\'s full amortization.';

  @override
  String get totalInterestOverAmortization =>
      'Total interest over amortization';

  @override
  String unableToCalculate(String error) {
    return 'Unable to calculate this scenario.\n$error';
  }

  @override
  String unableToLoadData(String error) {
    return 'Unable to load your data.\n$error';
  }

  @override
  String get us => 'US';

  @override
  String get usCompounding => 'Monthly compounding';

  @override
  String get vacancyModeAmount => 'Amount';

  @override
  String get vacancyModePercent => 'Percent';

  @override
  String vacancyOfGrossRent(String percent) {
    return '$percent of gross rent';
  }

  @override
  String get validationDownPaymentPercentRange =>
      'Down payment must be less than 100%';

  @override
  String get validationEnterAmount => 'Enter a valid amount';

  @override
  String get validationEnterAnAmount => 'Enter an amount';

  @override
  String get validationAmortizationRange => 'Enter 1 to 30 years';

  @override
  String get validationEnterName => 'Enter a name';

  @override
  String get validationEnterNonNegative => 'Enter a valid non-negative number';

  @override
  String get validationEnterPercentage => 'Enter a percentage from 0 to 100';

  @override
  String get validationEnterPropertyName => 'Enter a property name';

  @override
  String get validationEnterScenarioName => 'Enter a scenario name';

  @override
  String get validationInvalidUrl =>
      'Enter a valid URL starting with http:// or https://';

  @override
  String get validationMonthsRange => 'Months must be between 0 and 11.';

  @override
  String get validationPercentRange => 'Enter a percentage from 0 to 100';

  @override
  String get validationDownPaymentRange =>
      'Down payment must be less than the purchase price';

  @override
  String get amortizationCappedNote =>
      'Amortization limited to 25 years with less than 20% down.';

  @override
  String get amortizationYearsLabel => 'Amortization (years)';

  @override
  String get bindingConstraintGds => 'Housing costs are the limit (GDS ratio).';

  @override
  String get bindingConstraintTds => 'Total debts are the limit (TDS ratio).';

  @override
  String get borrowingCapacityDisclaimer =>
      'Estimate only, based on standard GDS/TDS guidelines and the federal mortgage stress test. Not financial advice or a pre-approval — actual lenders weigh more factors.';

  @override
  String get borrowingCapacityEnterTerms =>
      'Enter your income and debts to see your estimate.';

  @override
  String get borrowingCapacitySubtitle =>
      'Estimate how much you could borrow under standard Canadian lending rules.';

  @override
  String get borrowingCapacityTitle => 'Borrowing capacity';

  @override
  String get creditScoreNote =>
      'Your credit score doesn\'t change this math — it changes the rate you qualify for. That\'s where a good score pays off.';

  @override
  String get estimateBorrowingCapacity => 'Estimate your borrowing capacity';

  @override
  String get estimatesSection => 'Estimates';

  @override
  String get estimatesSectionSubtitle =>
      'Prefilled estimates for the future property — adjust anything to your situation.';

  @override
  String get expectedMortgageRate => 'Expected mortgage rate';

  @override
  String get expectedMortgageRateHint =>
      'Typical 5-year fixed — adjust to your situation.';

  @override
  String get grossAnnualIncome => 'Gross annual household income';

  @override
  String get incomeAndDebts => 'Income and debts';

  @override
  String investmentDownPaymentError(String price, String required) {
    return 'For an investment property, the down payment must be at least 20% of the purchase price — about $required on a $price purchase.';
  }

  @override
  String get investmentPropertyNote =>
      'Rough estimate — lenders assess rental properties differently and may include part of the rental income, which this tool doesn\'t model.';

  @override
  String get maxMortgageAmount => 'Maximum mortgage';

  @override
  String get maxPurchasePrice => 'Maximum purchase price';

  @override
  String get minimumDownPayment => 'Minimum down payment';

  @override
  String get monthlyDebtPayments => 'Existing monthly debt payments';

  @override
  String get monthlyHeating => 'Monthly heating estimate';

  @override
  String get monthlyPaymentAtContractRate => 'Monthly payment (at your rate)';

  @override
  String get mortgageAmortization => 'Mortgage amortization';

  @override
  String get mortgageAmortizationHint =>
      'How many years to pay off the loan — longer means smaller payments but more interest.';

  @override
  String percentValue(Object value) {
    return '$value%';
  }

  @override
  String get propertyTaxPercent => 'Property tax (% of price)';

  @override
  String get propertyUseInvestment => 'Investment property';

  @override
  String get propertyUseLabel => 'Property use';

  @override
  String get propertyUsePrincipal => 'Principal residence';

  @override
  String get qualifyingRate => 'Qualifying rate (stress test)';

  @override
  String get rateSensitivity => 'Rate sensitivity';

  @override
  String get validationEnterPositive => 'Enter a valid positive number';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get viewListing => 'View listing';

  @override
  String get whatIfDisclaimer =>
      'This is a what-if comparison, not a lender offer.';

  @override
  String whatIs(String title) {
    return 'What is $title?';
  }

  @override
  String get invoicesTitle => 'Invoices';

  @override
  String get invoicesEmptyTitle => 'No invoices yet';

  @override
  String get invoicesEmptySubtitle =>
      'Create your first invoice to get started.';

  @override
  String get done => 'Done';

  @override
  String get invoiceNewTitle => 'New invoice';

  @override
  String get invoiceEditTitle => 'Edit invoice';

  @override
  String get invoiceNumberLabel => 'Invoice number';

  @override
  String get invoiceClientLabel => 'Client';

  @override
  String get invoiceSelectClient => 'Select a client';

  @override
  String get invoiceClientRequired => 'Please select a client.';

  @override
  String get invoiceNewClient => 'New client';

  @override
  String get invoiceIssueDate => 'Issue date';

  @override
  String get invoiceDueDate => 'Due date';

  @override
  String get invoiceStatusLabel => 'Status';

  @override
  String get statusDraft => 'Draft';

  @override
  String get statusSent => 'Sent';

  @override
  String get statusPaid => 'Paid';

  @override
  String get statusOverdue => 'Overdue';

  @override
  String get invoiceChargeTaxes => 'Charge TPS/TVQ';

  @override
  String get invoiceChargeTaxesHelper =>
      'Turn off if you\'re a small supplier (not registered for TPS/TVQ).';

  @override
  String get invoiceLinesLabel => 'Line items';

  @override
  String get invoiceAddLine => 'Add line';

  @override
  String get invoiceLineDescription => 'Description';

  @override
  String get invoiceLineQty => 'Qty';

  @override
  String get invoiceLineUnitPrice => 'Unit price';

  @override
  String get invoiceLinesRequired => 'Add at least one line item.';

  @override
  String get invoiceNotesLabel => 'Notes';

  @override
  String get invoiceNotesHint => 'Thank you for your business…';

  @override
  String get invoiceSubtotal => 'Subtotal';

  @override
  String get invoiceTotal => 'Total';

  @override
  String get invoiceDeleteTitle => 'Delete invoice?';

  @override
  String invoiceDeleteMessage(Object number) {
    return 'Invoice \"$number\" will be permanently deleted.';
  }

  @override
  String invoiceDueOn(Object date) {
    return 'Due $date';
  }

  @override
  String get newInvoice => 'New invoice';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get navInvoices => 'Invoices';

  @override
  String get navTools => 'Tools';

  @override
  String get navClients => 'Clients';

  @override
  String get clientsEmptyTitle => 'No clients yet';

  @override
  String get clientsEmptyMessage =>
      'Add your first client to start billing them.';

  @override
  String get clientsAddClient => 'Add client';

  @override
  String get clientsSearchHint => 'Search clients';

  @override
  String get clientsSearchClear => 'Clear search';

  @override
  String get clientsSortBy => 'Sort clients';

  @override
  String get clientsSortTitle => 'Sort by';

  @override
  String get clientsSortNameAsc => 'Name (A–Z)';

  @override
  String get clientsSortNameDesc => 'Name (Z–A)';

  @override
  String get clientsSortNewest => 'Newest first';

  @override
  String get clientsSortOldest => 'Oldest first';

  @override
  String get clientsNoResultsTitle => 'No matching clients';

  @override
  String get clientsNoResultsMessage => 'Try a different search.';

  @override
  String get clientNewTitle => 'New client';

  @override
  String get clientEditTitle => 'Edit client';

  @override
  String get clientNameLabel => 'Name';

  @override
  String get clientNameRequired => 'Please enter the client\'s name.';

  @override
  String get clientEmailLabel => 'Email';

  @override
  String get clientPhoneLabel => 'Phone';

  @override
  String get clientAddressLabel => 'Address';

  @override
  String get clientNotesLabel => 'Notes';

  @override
  String get clientNotesHint => 'Payment terms, contact person…';

  @override
  String get clientDeleteTitle => 'Delete client?';

  @override
  String clientDeleteMessage(Object name) {
    return '\"$name\" will be permanently deleted.';
  }

  @override
  String get save => 'Save';

  @override
  String get guideStep1Title => 'Add your client';

  @override
  String get guideStep1Text =>
      'Save the businesses you bill, with their contact details.';

  @override
  String get guideStep2Title => 'Create an invoice';

  @override
  String get guideStep2Text =>
      'Add line items — TPS and TVQ are computed automatically.';

  @override
  String get guideStep3Title => 'Send the PDF';

  @override
  String get guideStep3Text =>
      'Export a clean PDF and share it with your client.';

  @override
  String get tpsTvqTitle => 'Understanding TPS/TVQ';

  @override
  String get tpsTvqSubtitle => 'How Québec sales taxes work.';

  @override
  String get tpsTvqBody1 =>
      'TPS (5%) applies to the pre-tax amount of each line.';

  @override
  String get tpsTvqBody2 =>
      'TVQ (9.975%) applies to the amount including TPS — a tax on a tax. This is the Québec rule most generic tools get wrong.';

  @override
  String get tpsTvqBody3 =>
      'Each tax is rounded to the nearest cent per line, then summed. If your taxable sales are \$30,000 or less, you may not need to register or charge taxes at all.';

  @override
  String get toolsTaxCalculator => 'TPS/TVQ calculator';

  @override
  String get toolsTaxCalculatorSubtitle =>
      'Add taxes or extract them from a total.';

  @override
  String get calcAmountLabel => 'Amount';

  @override
  String get calcAddTaxes => 'Add taxes';

  @override
  String get calcExtractTaxes => 'Taxes included';

  @override
  String get calcPreTaxAmount => 'Pre-tax amount';

  @override
  String get calcTotalWithTaxes => 'Total with taxes';

  @override
  String get dashboardUnpaid => 'Unpaid';

  @override
  String get dashboardPaidMonth => 'Paid this month';

  @override
  String get dashboardClients => 'Clients';

  @override
  String get dashboardSearchHint => 'Search invoices';

  @override
  String get dashboardFilterAll => 'All';

  @override
  String get dashboardNoResultsTitle => 'No invoices found';

  @override
  String get dashboardNoResultsMessage =>
      'Try adjusting your search or filter.';

  @override
  String get dashboardAttentionTitle => 'Needs attention';

  @override
  String dashboardOverdueBy(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days overdue',
      one: '$days day overdue',
    );
    return '$_temp0';
  }

  @override
  String get dashboardDueToday => 'Due today';

  @override
  String dashboardDueIn(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Due in $days days',
      one: 'Due tomorrow',
    );
    return '$_temp0';
  }

  @override
  String get proTitle => 'Facture Pro';

  @override
  String get proSubtitle => 'Unlock unlimited invoicing';

  @override
  String get proFeatureUnlimited => 'Unlimited invoices';

  @override
  String get proFeatureOneTime => 'One-time purchase — yours forever';

  @override
  String get proFeatureNoSubscription => 'No subscription, no ads';

  @override
  String proBuy(String price) {
    return 'Buy for $price';
  }

  @override
  String get proActive => 'Pro active';

  @override
  String get proRestore => 'Restore purchases';

  @override
  String get proRestoring => 'Restoring…';

  @override
  String get proNoticeUnavailable =>
      'Purchases are unavailable right now. Please try again later.';

  @override
  String get proNoticeFailed =>
      'The purchase didn\'t go through. Please try again.';

  @override
  String get proNoticeRestored => 'Your Pro purchase was restored.';

  @override
  String get proNoticeNothingToRestore =>
      'No previous purchase found for this Apple ID.';

  @override
  String get proFinePrint =>
      'Payment is charged to your Apple ID. One-time purchase, no subscription.';

  @override
  String proFreeLimit(int used, int total) {
    return 'Free plan: $used of $total invoices used';
  }

  @override
  String get settingsPro => 'Facture Pro';

  @override
  String get settingsProSubtitleActive => 'Unlimited invoices';

  @override
  String get settingsProSection => 'Subscription';

  @override
  String get backupTitle => 'Backup & export';

  @override
  String get backupSubtitle => 'Save or restore all your data';

  @override
  String get backupExplainer =>
      'Your backup contains everything: invoices, clients, business profile and email template. Keep the file somewhere safe — Facture never sends your data anywhere.';

  @override
  String get backupSection => 'Backup';

  @override
  String get backupExport => 'Export backup';

  @override
  String get backupExportSubtitle => 'All your data in one JSON file';

  @override
  String get backupImport => 'Import backup';

  @override
  String get backupImportSubtitle =>
      'Restore everything from a JSON backup file';

  @override
  String get backupImportConfirmTitle => 'Replace all data?';

  @override
  String get backupImportConfirmMessage =>
      'Your current invoices, clients and settings will be replaced with the backup\'s contents. This cannot be undone.';

  @override
  String get backupImportConfirmAction => 'Import';

  @override
  String get backupRestored => 'Backup restored';

  @override
  String get backupInvalid => 'This file is not a valid Facture backup.';

  @override
  String get backupExportSection => 'Export';

  @override
  String get backupCsv => 'Invoices (CSV)';

  @override
  String get backupCsvSubtitle => 'For your accountant — opens in Excel';

  @override
  String get csvNumber => 'Number';

  @override
  String get csvClient => 'Client';

  @override
  String get csvIssueDate => 'Issue date';

  @override
  String get csvDueDate => 'Due date';

  @override
  String get csvStatus => 'Status';

  @override
  String get csvSubtotal => 'Subtotal';

  @override
  String get csvTps => 'TPS';

  @override
  String get csvTvq => 'TVQ';

  @override
  String get csvTotal => 'Total';

  @override
  String get catalogTitle => 'Services & items';

  @override
  String get catalogSubtitle => 'Reusable line items for your invoices';

  @override
  String get catalogAddItem => 'Add item';

  @override
  String get catalogNewTitle => 'New item';

  @override
  String get catalogEditTitle => 'Edit item';

  @override
  String get catalogDescriptionLabel => 'Description';

  @override
  String get catalogDescriptionHint => 'e.g. Logo design, per hour';

  @override
  String get catalogDescriptionRequired => 'Enter a description';

  @override
  String get catalogPriceLabel => 'Unit price';

  @override
  String get catalogPriceRequired => 'Enter a price above \$0';

  @override
  String get catalogEmptyTitle => 'No saved items yet';

  @override
  String get catalogEmptyMessage =>
      'Save the services and items you bill often, then add them to an invoice in one tap.';

  @override
  String get catalogPickTitle => 'Choose from catalog';

  @override
  String get invoiceAddBlankLine => 'Blank line';

  @override
  String get invoiceAddFromCatalog => 'From catalog…';

  @override
  String get businessLogoLabel => 'Logo';

  @override
  String get businessLogoHint => 'Shown on your invoice PDFs';

  @override
  String get businessLogoRemove => 'Remove logo';

  @override
  String get businessLogoCreate => 'Create a logo';

  @override
  String get toolsLogoCreator => 'Create logo';

  @override
  String get toolsLogoCreatorSubtitle =>
      'Generate a logo from your business name.';

  @override
  String get logoCreatorTitle => 'Create logo';

  @override
  String get logoCreatorSubtitle =>
      'Pick a style and a color — your business name does the rest.';

  @override
  String get logoCreatorNameLabel => 'Business name';

  @override
  String get logoCreatorStyleLabel => 'Style';

  @override
  String get logoCreatorStyleCircle => 'Circle';

  @override
  String get logoCreatorStyleSquare => 'Rounded square';

  @override
  String get logoCreatorStyleWordmark => 'Wordmark';

  @override
  String get logoCreatorColorLabel => 'Color';

  @override
  String get logoCreatorSave => 'Use this logo';

  @override
  String get logoCreatorEmptyName =>
      'Enter your business name to preview your logo.';

  @override
  String get onboardingGetStarted => 'Get started';

  @override
  String get onboardingTagline =>
      'Invoicing for Québec freelancers — without the subscription.';

  @override
  String get onboardingBusinessTitle => 'Your business';

  @override
  String get onboardingBusinessSubtitle =>
      'This appears on your invoices. You can edit everything later in Settings.';

  @override
  String get onboardingBusinessContinue => 'Continue';

  @override
  String get onboardingTaxRequired => 'Choose your tax status to continue';

  @override
  String get onboardingHowTitle => 'How it works';

  @override
  String get onboardingHow1Title => 'Create invoices in seconds';

  @override
  String get onboardingHow1Body =>
      'Add a client, add line items, send the PDF. That\'s the whole workflow.';

  @override
  String get onboardingHow2Title => 'Québec-correct taxes';

  @override
  String get onboardingHow2Body =>
      'TPS 5% and TVQ 9.975% computed the Québec way — TVQ on the TPS-inclusive amount — automatically.';

  @override
  String get onboardingHow3Title => 'Your data stays on your phone';

  @override
  String get onboardingHow3Body =>
      'No account, no cloud, no tracking. Your invoices never leave your device.';

  @override
  String get onboardingHowNext => 'Next';

  @override
  String get onboardingPricingTitle => 'Simple pricing';

  @override
  String get onboardingPricingSubtitle =>
      'Start free. Upgrade once, keep it forever.';

  @override
  String get onboardingFreeTitle => 'Free';

  @override
  String get onboardingFreeBody => '3 invoices — try the whole app.';

  @override
  String get onboardingStartFree => 'Start free';

  @override
  String get onboardingProBody =>
      'Unlimited invoices. One-time purchase, no subscription.';

  @override
  String get onboardingGetPro => 'Get Facture Pro';
}
