// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get aboutSection => 'À propos';

  @override
  String get acquisitionOwned => 'Déjà propriétaire';

  @override
  String get acquisitionPurchase => 'Achat envisagé';

  @override
  String get acquisitionTypeHint =>
      'Évaluez-vous un achat ou êtes-vous déjà propriétaire de ce bien?';

  @override
  String get acquisitionTypeLabel => 'Statut de la propriété';

  @override
  String acrossProperties(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'les propriétés',
      one: 'la propriété',
    );
    return 'sur $_temp0';
  }

  @override
  String get actionDelete => 'Supprimer';

  @override
  String get actionEdit => 'Modifier';

  @override
  String get add => 'Ajouter';

  @override
  String get addExpense => 'Ajouter une dépense';

  @override
  String get addExpenseButton => 'Ajouter une dépense';

  @override
  String get addExpenseSubtitle =>
      'Ajoutez une dépense d’exploitation récurrente pour ce scénario.';

  @override
  String get addExpenseTitle => 'Ajouter une dépense';

  @override
  String get addIncome => 'Ajouter un revenu';

  @override
  String get addIncomeButton => 'Ajouter un revenu';

  @override
  String get addIncomeSubtitle =>
      'Ajoutez une source de revenu récurrente pour ce scénario.';

  @override
  String get addIncomeTitle => 'Ajouter un revenu';

  @override
  String get addNotes => 'Ajouter des notes';

  @override
  String get addProperty => 'Ajouter une propriété';

  @override
  String get addPropertyForPortfolio =>
      'Ajoutez une propriété pour voir votre portefeuille.';

  @override
  String get addPropertySubtitle =>
      'Créez une propriété pour suivre ses flux de trésorerie.';

  @override
  String get addPropertyTitle => 'Ajouter une propriété';

  @override
  String get addPropertyToCompare =>
      'Ajoutez une propriété pour commencer à comparer des scénarios.';

  @override
  String get addScenario => 'Ajouter un scénario';

  @override
  String get addScenarioTitle => 'Ajouter un scénario';

  @override
  String get addStreetAddress => 'Ajouter une rue ou une adresse';

  @override
  String get addressLabel => 'Adresse';

  @override
  String get addressPlaceholder => 'Ajoutez une rue ou une adresse';

  @override
  String get allProperties => 'Toutes les propriétés';

  @override
  String get amortMonths => 'Mois d\'amortissement';

  @override
  String get amortMonthsLabel => 'Amortissement (mois)';

  @override
  String amortShort(int months, int years) {
    return '${years}a ${months}m';
  }

  @override
  String get amortYears => 'Années d\'amortissement';

  @override
  String get amortYearsLabel => 'Amortissement (années)';

  @override
  String amortYearsShort(int years) {
    return '${years}a';
  }

  @override
  String get amortizationLabel => 'Amortissement';

  @override
  String amortizationValue(String value) {
    return 'Amortissement : $value';
  }

  @override
  String amortizationYearsMonths(int months, int years) {
    return '$years ans $months mois';
  }

  @override
  String get amountHint => '0,00';

  @override
  String get amountLabel => 'Montant';

  @override
  String get amountModeFixed => 'Montant';

  @override
  String get amountModePercent => '% du revenu';

  @override
  String get analyzeAction => 'Analyser';

  @override
  String get annual => 'Annuel';

  @override
  String annualAfterFinancing(String amount) {
    return 'Annuel $amount après financement';
  }

  @override
  String annualCashFlow(String amount) {
    return '$amount par an après financement';
  }

  @override
  String get annualLabel => 'Annuel';

  @override
  String get annualRunRate => 'Rythme annuel';

  @override
  String annualizedPrimaryNote(String name) {
    return 'Basé sur le scénario principal « $name », annualisé.';
  }

  @override
  String get appTitle => 'Facture';

  @override
  String get balanceLabel => 'Solde';

  @override
  String balanceEndOfYear(int year) {
    return 'Solde à la fin de l\'année $year';
  }

  @override
  String get businessAddressHint => 'Rue, ville, code postal';

  @override
  String get businessAddressLabel => 'Adresse';

  @override
  String get businessDisclaimer =>
      'Vous êtes responsable de l\'exactitude de vos informations d\'entreprise et de votre statut fiscal. Facture ne fournit pas de conseils fiscaux.';

  @override
  String get businessEmailLabel => 'Courriel';

  @override
  String get businessNameHint => 'p. ex. Atelier Nord';

  @override
  String get businessNameLabel => 'Nom de l\'entreprise';

  @override
  String get businessNameRequired => 'Entrez le nom de votre entreprise';

  @override
  String get businessPhoneLabel => 'Téléphone';

  @override
  String get businessProfileSubtitle => 'Nom, coordonnées, statut TPS/TVQ';

  @override
  String get businessProfileTitle => 'Profil d\'entreprise';

  @override
  String get businessTaxStatusHelper =>
      'Les petits fournisseurs (30 000 \$ ou moins de ventes taxables au cours des quatre derniers trimestres) ne sont pas tenus de s\'inscrire et ne doivent pas percevoir la TPS/TVQ.';

  @override
  String get businessTaxStatusLabel => 'Inscription aux TPS/TVQ';

  @override
  String get businessTaxStatusRegistered => 'Inscrit';

  @override
  String get businessTaxStatusRegisteredSub => 'Perçoit la TPS/TVQ';

  @override
  String get businessTaxStatusSmallSupplier => 'Petit fournisseur';

  @override
  String get businessTaxStatusSmallSupplierSub => 'Aucune taxe perçue';

  @override
  String get businessTpsNumberHint => '123456789RT0001';

  @override
  String get businessTpsNumberLabel => 'Numéro d\'inscription TPS';

  @override
  String get businessTvqNumberHint => '1234567890TQ0001';

  @override
  String get businessTvqNumberLabel => 'Numéro d\'inscription TVQ';

  @override
  String firstMonthOfYear(int year) {
    return 'Premier mois de l\'année $year';
  }

  @override
  String get invoiceBackToDraft => 'Remettre en brouillon';

  @override
  String get invoiceChangeStatus => 'Changer le statut';

  @override
  String get invoiceMarkPaid => 'Marquer comme payée';

  @override
  String get invoiceMarkSent => 'Marquer comme envoyée';

  @override
  String invoicePaidOn(String date) {
    return 'Payée le $date';
  }

  @override
  String get invoiceProfileNudge =>
      'Ajoutez les informations de votre entreprise et vos numéros de taxe pour les afficher sur vos factures.';

  @override
  String get invoiceProfileNudgeAction => 'Configurer';

  @override
  String get invoiceReopenAsSent => 'Rouvrir comme envoyée';

  @override
  String get invoiceSharePdf => 'Partager le PDF';

  @override
  String get emailTemplateTitle => 'Modèle de courriel';

  @override
  String get emailTemplateSubtitle =>
      'Objet et message utilisés pour envoyer une facture par courriel — insérez les variables ci-dessous';

  @override
  String get emailTemplateSubjectLabel => 'Objet';

  @override
  String get emailTemplateBodyLabel => 'Message';

  @override
  String get emailTemplateSubjectRequired => 'Saisissez un objet';

  @override
  String get emailTemplateBodyRequired => 'Saisissez un message';

  @override
  String get emailTemplatePlaceholdersTitle => 'Variables';

  @override
  String get emailTemplatePlaceholdersHint =>
      'Remplacées automatiquement à l\'ouverture du courriel.';

  @override
  String get emailTemplateReset => 'Réinitialiser';

  @override
  String get invoiceSendEmail => 'Envoyer par courriel';

  @override
  String get invoicePreviewSend => 'Envoyer la facture';

  @override
  String get invoicePreviewEdit => 'Modifier la facture';

  @override
  String get invoicePreviewNotFound => 'Cette facture n\'existe plus.';

  @override
  String get invoiceEmailFailed =>
      'Impossible d\'ouvrir l\'éditeur de courriel.';

  @override
  String get invoiceNoClientEmailTitle => 'Aucune adresse courriel';

  @override
  String invoiceNoClientEmailMessage(String name) {
    return 'Ajoutez une adresse courriel pour $name afin de lui envoyer la facture.';
  }

  @override
  String get invoiceNoClientEmailAdd => 'Ajouter le courriel';

  @override
  String get primaryScenarioSection => 'Scénario principal';

  @override
  String get primaryScenarioSectionSubtitle =>
      'Le scénario principal contient vos hypothèses principales — vous pourrez en ajouter d\'autres pour comparer.';

  @override
  String get primaryScenarioCopyHelper =>
      'S\'applique uniquement en partant de zéro — une propriété copiée conserve ses scénarios.';

  @override
  String get propertyDetails => 'Détails de la propriété';

  @override
  String get scenarioName => 'Nom du scénario';

  @override
  String get primaryScenarioNameHint => 'p. ex. Base case';

  @override
  String get bar => 'Barres';

  @override
  String get barChart => 'Barres';

  @override
  String get basedOn => 'Basé sur';

  @override
  String get basedOnLabel => 'Basé sur';

  @override
  String get byProperty => 'Par propriété';

  @override
  String buyingDerivedLine(String balance, String percent) {
    return 'Solde : $balance · mise de fonds de $percent %';
  }

  @override
  String get calcError => 'Impossible de calculer ce scénario.';

  @override
  String get calculated => 'Calculé';

  @override
  String get calculatedPayment => 'Versement calculé';

  @override
  String get canada => 'Canada';

  @override
  String get canadaCompounding => 'Capitalisation semestrielle';

  @override
  String get canadaUsExplainer =>
      'Les hypothèques canadiennes se capitalisent semestriellement; les hypothèques américaines se capitalisent mensuellement.';

  @override
  String get cannotDeleteLastScenario =>
      'Une propriété doit conserver au moins un scénario.';

  @override
  String get cannotOpenUrl => 'Impossible d\'ouvrir le lien';

  @override
  String get capRateLabel => 'Taux cap.';

  @override
  String get cashFlowComparison => 'Comparaison des flux de trésorerie';

  @override
  String get cashFlowLabel => 'Flux de trésorerie';

  @override
  String get cashOnCashLabel => 'Rendement sur mise de fonds';

  @override
  String get categoryField => 'Catégorie';

  @override
  String get categoryInsurance => 'Assurance';

  @override
  String get categoryMaintenance => 'Entretien';

  @override
  String get categoryOther => 'Autre';

  @override
  String get categoryParking => 'Stationnement';

  @override
  String get categoryPropertyManagement => 'Gestion immobilière';

  @override
  String get categoryPropertyTax => 'Taxes foncières';

  @override
  String get categoryRent => 'Loyer';

  @override
  String get categoryRepairs => 'Réparations';

  @override
  String get categoryStorage => 'Entreposage';

  @override
  String get categoryUtilities => 'Services publics';

  @override
  String get chartDisplayBy => 'Graphique par';

  @override
  String get classificationSection => 'Classification';

  @override
  String get comparisonTitle => 'Comparaison';

  @override
  String get compoundingHelper =>
      'Le même taux nominal donne un versement légèrement plus bas avec la capitalisation semestrielle.';

  @override
  String get compoundingLabel => 'Capitalisation';

  @override
  String get confirm => 'Confirmer';

  @override
  String get convCashFlow => 'Flux de trésorerie = RNE − coûts de financement.';

  @override
  String get convCompounding =>
      'Les hypothèques canadiennes se capitalisent semestriellement; les hypothèques américaines, mensuellement. Les nouvelles hypothèques utilisent la capitalisation semestrielle canadienne par défaut.';

  @override
  String get convFrequencies =>
      'Les fréquences sont normalisées : annuel ÷ 12, hebdomadaire × 52 ÷ 12.';

  @override
  String get convNoi =>
      'RNE (revenu net d’exploitation) = revenus effectifs − dépenses d’exploitation. Les versements hypothécaires sont exclus du RNE.';

  @override
  String get convOneTime =>
      'Les éléments uniques sont conservés, mais exclus des chiffres mensuels récurrents.';

  @override
  String get convPrimary =>
      'Le scénario principal est la référence pour les totaux du portefeuille.';

  @override
  String get convVacancy =>
      'L\'inoccupation / perte de revenus est une dépense comme les autres : entrez un montant fixe ou un pourcentage du revenu brut.';

  @override
  String get conventionCashFlow =>
      'Flux de trésorerie = bénéfice d\'exploitation net − coûts de financement.';

  @override
  String get conventionCompounding =>
      'Les hypothèques canadiennes se capitalisent semestriellement; les américaines mensuellement. Les nouvelles hypothèques utilisent la capitalisation semestrielle canadienne par défaut.';

  @override
  String get conventionFrequencies =>
      'Fréquences normalisées : annuel ÷ 12, hebdomadaire × 52 ÷ 12.';

  @override
  String get conventionNoi =>
      'Bénéfice d\'exploitation net = revenus effectifs − charges d\'exploitation. Les versements hypothécaires sont exclus du bénéfice d\'exploitation net.';

  @override
  String get conventionOneTime =>
      'Les éléments ponctuels sont conservés, mais exclus des chiffres mensuels récurrents.';

  @override
  String get conventionPrimary =>
      'Le scénario principal est la référence pour les totaux du portefeuille.';

  @override
  String get conventionVacancy =>
      'L\'inoccupation / perte de revenus est un pourcentage des revenus bruts prévus.';

  @override
  String get copyScenarioHint =>
      'Copiez les chiffres d\'un scénario existant ou partez de zéro.';

  @override
  String get createPropertySubtitle =>
      'Créez une propriété pour commencer à suivre son flux de trésorerie.';

  @override
  String get createScenarioSubtitle =>
      'Modélisez une variante hypothétique (refinancement, hausse de loyer, nouvel achat) sans toucher à votre scénario principal.';

  @override
  String get csvHeader => 'Catégorie,Montant';

  @override
  String get currentMonthlyPayment => 'Versement mensuel actuel';

  @override
  String get currentMortgageBalance => 'Solde hypothécaire actuel';

  @override
  String get currentScenario => 'Scénario actuel';

  @override
  String get currentTotalInterest => 'Intérêts totaux actuels';

  @override
  String get dashboardMonthlyPerformance => 'Rendement mensuel';

  @override
  String dataInvalidError(String error) {
    return 'Les données locales contiennent une valeur invalide : $error';
  }

  @override
  String dataReadError(String error) {
    return 'Les données locales n\'ont pas pu être lues : $error';
  }

  @override
  String get dataSaveError =>
      'Les données locales n\'ont pas pu être enregistrées.';

  @override
  String dataSaveErrorDetail(String error) {
    return 'Les données locales n\'ont pas pu être enregistrées : $error';
  }

  @override
  String dealCapRate(String value) {
    return 'Taux cap. : $value';
  }

  @override
  String dealCashFlow(String amount) {
    return 'Flux de trésorerie mensuel : $amount';
  }

  @override
  String dealCashOnCash(String value) {
    return 'Rendement sur mise de fonds : $value';
  }

  @override
  String dealDownPayment(String amount) {
    return 'Mise de fonds : $amount';
  }

  @override
  String dealDscr(String value) {
    return 'Ratio de couverture : $value';
  }

  @override
  String dealGrossRent(String amount) {
    return 'Loyer mensuel brut : $amount';
  }

  @override
  String dealMonthlyPayment(String amount) {
    return 'Versement hypothécaire mensuel : $amount';
  }

  @override
  String dealPurchasePrice(String amount) {
    return 'Prix d\'achat : $amount';
  }

  @override
  String dealScenario(String scenarioName) {
    return 'Scénario : $scenarioName';
  }

  @override
  String dealSnapshotTitle(String propertyName) {
    return 'Aperçu de l\'affaire — $propertyName';
  }

  @override
  String get delete => 'Supprimer';

  @override
  String get deleteItemMessage => 'Voulez-vous vraiment supprimer cet élément?';

  @override
  String get deleteItemTitle => 'Supprimer?';

  @override
  String deletePropertyConfirm(String name) {
    return 'Supprimer « $name » et ses scénarios?';
  }

  @override
  String get deletePropertyMessage =>
      'Cela supprimera aussi tous les scénarios associés à cette propriété.';

  @override
  String get deletePropertyTitle => 'Supprimer la propriété?';

  @override
  String get deleteScenarioMessage =>
      'Voulez-vous vraiment supprimer ce scénario?';

  @override
  String get deleteScenarioTitle => 'Supprimer le scénario?';

  @override
  String get dialogCancel => 'Annuler';

  @override
  String get dialogConfirm => 'Confirmer';

  @override
  String get dialogDelete => 'Supprimer';

  @override
  String get dialogOk => 'OK';

  @override
  String get dialogSave => 'Enregistrer';

  @override
  String get dscrLabel => 'RCD';

  @override
  String get downPayment => 'Mise de fonds';

  @override
  String get downPaymentCustomOption => 'Montant personnalisé';

  @override
  String get downPaymentMinimumHint => 'Paliers SCHL : 5 % / 10 % / 20 %';

  @override
  String get downPaymentMinimumHintInvestment =>
      'Minimum 20 % — les immeubles à revenu ne sont pas assurables SCHL';

  @override
  String get downPaymentMinimumOption => 'Minimale';

  @override
  String get downPaymentModeLabel => 'Mise de fonds';

  @override
  String get downPaymentPercentMode => 'Mise de fonds (%)';

  @override
  String get duplicatePropertyName =>
      'Une propriété portant ce nom existe déjà.';

  @override
  String get duplicateScenarioName =>
      'Un scénario portant ce nom existe déjà pour cette propriété.';

  @override
  String get eachPropertyPrimary =>
      'Chaque propriété est représentée par son scénario principal.';

  @override
  String get eachSideNeedsScenario =>
      'Chaque côté a besoin d\'un scénario à comparer.';

  @override
  String get edit => 'Modifier';

  @override
  String get editExpense => 'Modifier la dépense';

  @override
  String get editExpenseSubtitle => 'Mettez à jour cette dépense.';

  @override
  String get editExpenseTitle => 'Modifier la dépense';

  @override
  String get editIncome => 'Modifier le revenu';

  @override
  String get editIncomeSubtitle => 'Mettez à jour ce revenu.';

  @override
  String get editIncomeTitle => 'Modifier le revenu';

  @override
  String get editMortgage => 'Modifier l\'hypothèque';

  @override
  String get editProperty => 'Modifier la propriété';

  @override
  String get editPropertyName => 'Modifier le nom de la propriété';

  @override
  String get editPropertySubtitle =>
      'Mettez à jour les détails de la propriété.';

  @override
  String get editPropertyTitle => 'Modifier la propriété';

  @override
  String get editStreetAddress => 'Modifier la rue ou l’adresse';

  @override
  String get emptyExpenseMessage =>
      'Ajoutez votre première charge d’exploitation pour compléter le portrait.';

  @override
  String get emptyExpenseTitle => 'Aucune dépense pour l’instant';

  @override
  String get emptyIncomeMessage =>
      'Ajoutez votre première source de revenus pour voir vos liquidités prendre forme.';

  @override
  String get emptyIncomeTitle => 'Aucun revenu pour l’instant';

  @override
  String get errorTitle => 'Un problème est survenu';

  @override
  String get enterMortgageDetails =>
      'Entrez le solde, le taux et l\'amortissement; l\'appli calcule le versement mensuel.';

  @override
  String get enterValidTerms =>
      'Entrez des modalités de refinancement valides pour comparer.';

  @override
  String get estimatedMonthlyPayment => 'Paiement mensuel estimé';

  @override
  String get expenseNameHint => 'p. ex. Taxe foncière';

  @override
  String get expenseTitle => 'Dépense';

  @override
  String expensesTitle(String name) {
    return 'Dépenses · $name';
  }

  @override
  String explainerTitle(String title) {
    return 'Qu\'est-ce que $title?';
  }

  @override
  String get fieldAmount => 'Montant';

  @override
  String get fieldCategory => 'Catégorie';

  @override
  String get fieldFrequency => 'Fréquence';

  @override
  String get fieldName => 'Nom';

  @override
  String get fieldNotes => 'Notes';

  @override
  String get financialConventions => 'Conventions financières';

  @override
  String get financialConventionsSubtitle =>
      'Comment l’app calcule ses chiffres';

  @override
  String get financingAssumptions =>
      'Hypothèses de financement pour ce scénario.';

  @override
  String get financingAssumptionsTitle => 'Hypothèses de financement';

  @override
  String get financingExcludedNote =>
      'Le versement hypothécaire est traité comme un coût de financement et est exclu du bénéfice d’exploitation net.';

  @override
  String get financingLabel => 'Financement';

  @override
  String get formAdd => 'Ajouter';

  @override
  String get formCancel => 'Annuler';

  @override
  String get formSave => 'Enregistrer';

  @override
  String feedbackEmailSubject(String version) {
    return 'Commentaires sur Facture $version';
  }

  @override
  String get feedbackEmailCopied =>
      'Adresse de soutien copiée — collez-la dans votre application courriel.';

  @override
  String get feedbackSubtitle => 'Signalez un problème ou proposez une idée.';

  @override
  String get feedbackTitle => 'Envoyer un commentaire';

  @override
  String get frequenciesNote =>
      'Fréquences normalisées : annuel ÷ 12, hebdomadaire × 52 ÷ 12.';

  @override
  String get frequencyField => 'Fréquence';

  @override
  String get frequencyMonthly => 'Mensuel';

  @override
  String get frequencyOneTime => 'Ponctuel';

  @override
  String get frequencyWeekly => 'Hebdomadaire';

  @override
  String get frequencyYearly => 'Annuel';

  @override
  String get settingsBusiness => 'Entreprise';

  @override
  String shareInvoiceSubject(String number) {
    return 'Facture $number';
  }

  @override
  String shareInvoiceText(String number, String total) {
    return 'Voici la facture $number — $total.';
  }

  @override
  String get yearPickerLabel => 'Année';

  @override
  String get blank => 'Vide';

  @override
  String get generatedBy => 'Généré par Rentable.';

  @override
  String get grossRents => 'Loyers bruts';

  @override
  String get guideAnalysisBody =>
      'Choisissez deux scénarios pour les comparer côte à côte : revenus, dépenses, flux de trésorerie, financement et les métriques d’investisseur ci-dessous.';

  @override
  String get guideAnalysisTitle => 'Analyse';

  @override
  String get guideDashboardBody =>
      'Le tableau de bord montre une propriété et un scénario à la fois ou — choisissez « Toutes les propriétés » — tout votre portefeuille d’un coup. La vue portefeuille additionne le scénario principal de chaque propriété, donc elle reflète toujours vos chiffres de référence.';

  @override
  String get guideDashboardTitle => 'Tableau de bord';

  @override
  String get guideIncomeBody =>
      'Ajoutez les revenus récurrents et les dépenses d’exploitation d’un scénario : loyer, buanderie, taxe foncière, assurance, entretien. Chaque élément a une fréquence (mensuelle, annuelle, hebdomadaire, unique) et est normalisé en montant mensuel.\n\nL’inoccupation / perte de revenu se règle en pourcentage du revenu brut dans l’onglet Dépenses.';

  @override
  String get guideIncomeTitle => 'Revenus et dépenses';

  @override
  String get guideMortgageBody =>
      'Entrez le solde, le taux et l’amortissement; l’app calcule le versement mensuel. Choisissez le type de taux qui correspond au prêt : Canada (capitalisation semestrielle) ou États-Unis (capitalisation mensuelle).\n\nLes versements hypothécaires sont des coûts de financement : ils réduisent le flux de trésorerie, mais sont exclus du RNE, selon la convention standard.';

  @override
  String get guideMortgageTitle => 'Hypothèque';

  @override
  String get guidePropertiesBody =>
      'Une propriété est un immeuble que vous suivez — un multiplex, un condo, une maison. Ajoutez-en une à partir de l’onglet Propriétés. Tout dans l’app (scénarios, revenus, dépenses, hypothèque) est rattaché à une propriété.';

  @override
  String get guidePropertiesTitle => 'Propriétés';

  @override
  String get guideScenariosBody =>
      'Chaque propriété contient un ou plusieurs scénarios : des variantes hypothétiques du même immeuble. Modélisez un refinancement, une hausse de loyer ou une offre d’achat sans toucher à vos chiffres de référence.\n\nUn scénario est toujours le principal. C’est la référence utilisée pour le tableau de bord Toutes les propriétés et il reflète la réalité actuelle de l’immeuble. Copiez un scénario pour explorer des alternatives, puis changez le scénario principal quand l’alternative devient le plan.';

  @override
  String get guideScenariosTitle => 'Scénarios';

  @override
  String get howItWorks => 'Comment fonctionne Facture';

  @override
  String get howItWorksSubtitle => 'Clients, factures et taxes du Québec.';

  @override
  String get hypotheticalTerms => 'Modalités hypothétiques de refinancement';

  @override
  String get incomeNameHint => 'p. ex. Loyer unité 1';

  @override
  String incomeScreenTitle(String name) {
    return 'Revenus · $name';
  }

  @override
  String get incomeTitle => 'Revenu';

  @override
  String get interestLabel => 'Intérêts';

  @override
  String get interestRateLabel => 'Taux d\'intérêt';

  @override
  String get interestRatePercent => 'Taux d\'intérêt (%)';

  @override
  String get investorMetrics => 'Indicateurs investisseurs';

  @override
  String get investorMetricsExplained => 'Indicateurs investisseurs expliqués';

  @override
  String get investorMetricsSubtitle =>
      'RCD, taux cap., rendement sur mise de fonds, RPV';

  @override
  String get investorMetricsTitle => 'Indicateurs investisseurs';

  @override
  String get loanAmountLabel => 'Montant du prêt';

  @override
  String get loanDetails => 'Détails du prêt';

  @override
  String get ltvDisclaimer =>
      'Hypothèse V1 : l\'emprunt potentiel est plafonné à 80 % de la valeur de la propriété. Ce n\'est ni une opération de refinancement ni un résultat d\'admissibilité d\'un prêteur.';

  @override
  String get ltvLabel => 'RPV';

  @override
  String get listingUrlHint =>
      'Collez un lien d\'annonce ou un texte partagé Centris';

  @override
  String get listingUrlLabel => 'URL de l\'annonce';

  @override
  String get listingUrlPrefillHelper =>
      'Collez un lien d’annonce : le nom, la ville et les logements seront pré-remplis.';

  @override
  String listingPlexDetected(int count) {
    return 'Plex détecté : $count loyers seront créés.';
  }

  @override
  String get makePrimaryScenario => 'Définir comme scénario principal';

  @override
  String get manageScenarios => 'Gérer les scénarios';

  @override
  String get manualMonthlyPayment => 'Versement mensuel manuel';

  @override
  String get manualOverride => 'Remplacement manuel';

  @override
  String get manualPaymentHint =>
      'Entrez un versement manuel seulement si votre versement réel diffère de celui calculé.';

  @override
  String get maxMortgageBalance => 'Solde hypothécaire maximal (RPV 80 %)';

  @override
  String get metricCapRate => 'Taux cap. — Taux de capitalisation';

  @override
  String get metricCapRateMeaning =>
      'Bénéfice d\'exploitation net annuel divisé par la valeur de la propriété. Il répond à : quel rendement cet immeuble rapporterait-il s\'il était acheté comptant?';

  @override
  String get metricCapRateReading =>
      'Plus il est élevé, moins l\'immeuble est cher par rapport à ses revenus. Servez-vous-en pour comparer des immeubles, peu importe leur financement.';

  @override
  String get metricCapRateShort => 'Taux de capitalisation';

  @override
  String get metricCashOnCash => 'Rendement sur mise de fonds';

  @override
  String get metricCashOnCashMeaning =>
      'Flux de trésorerie annuel divisé par l\'argent réellement investi (valeur de la propriété moins le solde hypothécaire). Il répond à : quel rendement est-ce que je gagne sur mon argent?';

  @override
  String get metricCashOnCashReading =>
      'Plus il est élevé, plus votre mise de fonds travaille fort. Contrairement au taux cap., il tient compte de votre financement.';

  @override
  String get metricCashOnCashShort => 'Rendement sur mise de fonds';

  @override
  String get metricDscr => 'RCD — Ratio de couverture de la dette';

  @override
  String get metricDscrMeaning =>
      'Bénéfice d\'exploitation net annuel divisé par les versements hypothécaires annuels. Il répond à : est-ce que le loyer couvre le prêt?';

  @override
  String get metricDscrReading =>
      'Au-dessus de 1,20, c\'est confortable et c\'est ce que la plupart des prêteurs veulent voir. Sous 1,00, l\'immeuble ne s\'autofinance pas.';

  @override
  String get metricDscrShort => 'DSCR';

  @override
  String get metricLtv => 'RPV — Ratio prêt-valeur';

  @override
  String get metricLtvMeaning =>
      'Solde hypothécaire divisé par la valeur de la propriété. Il répond à : quelle part de l\'immeuble appartient au prêteur?';

  @override
  String get metricLtvReading =>
      'Plus il est bas, plus vous avez une marge de sécurité. La plupart des prêteurs résidentiels plafonnent les prêts assurés autour de 80 %.';

  @override
  String get metricLtvShort => 'Ratio prêt-valeur';

  @override
  String get monthly => 'Mensuel';

  @override
  String get monthlyCashFlowChart => 'FLUX DE TRÉSORERIE MENSUEL';

  @override
  String get monthlyCashFlowLabel => 'Flux de trésorerie mensuel';

  @override
  String get monthlyDifference => 'Différence mensuelle';

  @override
  String get monthlyLabel => 'Mensuel';

  @override
  String get monthlyPayment => 'Versement mensuel';

  @override
  String get monthlyPaymentCalculated => 'Versement mensuel (calculé)';

  @override
  String get monthlyPaymentManual => 'Versement mensuel (manuel)';

  @override
  String get monthlyPerformance => 'Performance mensuelle';

  @override
  String get mortgageBalance => 'Solde hypothécaire';

  @override
  String get mortgageBalanceLabel => 'Solde hypothécaire';

  @override
  String get mortgageCalculatorSubtitle => 'Estimez votre paiement mensuel';

  @override
  String get mortgageCalculatorTitle => 'Calculateur hypothécaire';

  @override
  String get mortgageInterestNote =>
      'Les intérêts hypothécaires sont une estimation (intérêts mensuels actuels × 12) et n\'apparaissent ici qu\'à des fins fiscales — ils restent exclus du bénéfice d\'exploitation net.';

  @override
  String mortgageTitle(String scenarioName) {
    return 'Hypothèque · $scenarioName';
  }

  @override
  String get nameHintExpense => 'p. ex. Taxes foncières';

  @override
  String get nameHintIncome => 'p. ex. Loyer unité 1';

  @override
  String get nameLabel => 'Nom';

  @override
  String get navAnalysis => 'Analyse';

  @override
  String get analyzeMode => 'Analyser';

  @override
  String get compareMode => 'Comparer';

  @override
  String get scenarioFieldLabel => 'Scénario';

  @override
  String get navProperties => 'Propriétés';

  @override
  String get navSettings => 'Réglages';

  @override
  String get needScenarioEachSide =>
      'Chaque côté a besoin d’un scénario à comparer.\nAjoutez un scénario pour continuer.';

  @override
  String get netRentalIncome => 'Revenu net de location';

  @override
  String get newBalance => 'Nouveau solde';

  @override
  String get newInterestRate => 'Nouveau taux d\'intérêt (%)';

  @override
  String get newMortgagesDefault =>
      'Les nouvelles hypothèques utilisent la capitalisation semestrielle canadienne par défaut.';

  @override
  String get noExpenseCategories =>
      'Aucune catégorie de dépense d’exploitation pour le moment.';

  @override
  String get noExpenses => 'Aucune charge d\'exploitation pour l\'instant.';

  @override
  String get noIncomeCategories => 'Aucune catégorie de revenu pour le moment.';

  @override
  String get noIncomeItems => 'Aucun revenu pour le moment.';

  @override
  String get noOperatingExpenses =>
      'Aucune dépense d’exploitation pour le moment.';

  @override
  String get noScenario => 'Aucun scénario';

  @override
  String get noiLabel => 'Bénéf. expl.';

  @override
  String get noiShort => 'RNE';

  @override
  String get notAvailable => 's.o.';

  @override
  String get notesField => 'Notes';

  @override
  String get notesOptional => 'Facultatif';

  @override
  String get ok => 'OK';

  @override
  String get oneTimeNote =>
      'Les éléments ponctuels sont conservés, mais exclus des chiffres mensuels récurrents.';

  @override
  String get operatingExpensesLabel => 'Dépenses d’exploitation';

  @override
  String get optional => 'Facultatif';

  @override
  String get paymentMode => 'Mode de versement';

  @override
  String perMonthShort(String amount) {
    return '$amount / mois';
  }

  @override
  String perWeekShort(String amount) {
    return '$amount / sem';
  }

  @override
  String perYearShort(String amount) {
    return '$amount / an';
  }

  @override
  String percentOfGrossRevenue(String rate) {
    return '$rate % du revenu brut';
  }

  @override
  String get percentage => 'Pourcentage';

  @override
  String get persistenceLoadError =>
      'Impossible de charger les données locales.';

  @override
  String get pickTwoScenarios =>
      'Choisissez deux scénarios à comparer côte à côte : revenus, dépenses, flux de trésorerie, financement et indicateurs.';

  @override
  String get pie => 'Circulaire';

  @override
  String get pieChart => 'Circulaire';

  @override
  String portfolioAnnualLine(String amount, int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count propriétés',
      one: '$count propriété',
    );
    return 'Annuel $amount pour $_temp0';
  }

  @override
  String get portfolioCashFlow => 'FLUX DE TRÉSORERIE DU PORTEFEUILLE';

  @override
  String get portfolioCashFlowLabel => 'Flux de trésorerie du portefeuille';

  @override
  String get potentialAdditional => 'Montant supplémentaire potentiel';

  @override
  String get potentialRefinanceTitle =>
      'Refinancement supplémentaire potentiel';

  @override
  String get ppSuffix => 'p.p.';

  @override
  String get primaryBadge => 'Principal';

  @override
  String get primaryForAllProperties =>
      'Le scénario principal est utilisé pour les calculs Toutes les propriétés';

  @override
  String get primaryScenarioCalculations =>
      'Le scénario principal est utilisé pour les calculs Toutes les propriétés';

  @override
  String get primaryScenarioNote =>
      'Chaque propriété est représentée par son scénario principal.';

  @override
  String get primaryScenarioTooltip => 'Scénario principal';

  @override
  String get principalLabel => 'Capital';

  @override
  String get propertiesTitle => 'Propriétés';

  @override
  String get propertyActions => 'Actions de la propriété';

  @override
  String get propertyAddressHint => 'Facultatif';

  @override
  String get propertyAddressLabel => 'Rue ou adresse';

  @override
  String get propertyFallbackName => 'Propriété';

  @override
  String get propertyLabel => 'Propriété';

  @override
  String get propertyMortgage => 'Propriété / Hypothèque';

  @override
  String get propertyName => 'Nom de la propriété';

  @override
  String get propertyNameHint => 'p. ex. Triplex à Montréal';

  @override
  String get propertyNameLabel => 'Nom de la propriété';

  @override
  String get propertyValue => 'Valeur de la propriété';

  @override
  String get propertyValueLabel => 'Valeur de la propriété';

  @override
  String get purchasePrice => 'Prix d\'achat';

  @override
  String rateAmortLine(String amort, String rate) {
    return 'Taux : $rate  ·  Amortissement : $amort';
  }

  @override
  String get rateAppSubtitle =>
      'L\'application vous plaît? Laissez une évaluation.';

  @override
  String get rateAppTitle => 'Évaluer Facture';

  @override
  String get rateCompounding => 'Capitalisation du taux';

  @override
  String rateLabel(String rate) {
    return 'Taux : $rate';
  }

  @override
  String get rateType => 'Type de taux';

  @override
  String get recurringAnnualizedNote =>
      'Basé sur les éléments récurrents, annualisé. Éléments ponctuels exclus.';

  @override
  String get refinanceMonthlyPayment => 'Versement mensuel refinancé';

  @override
  String get refinanceOption => 'Refinancement';

  @override
  String get refinanceOptionSubtitle =>
      'Dupliquer le scénario principal avec de nouvelles modalités hypothécaires';

  @override
  String refinanceScenarioName(String rate, String term) {
    return 'Refi $rate % / $term';
  }

  @override
  String get refinanceTotalInterest => 'Intérêts totaux refinancés';

  @override
  String get rentalIncomeLabel => 'Revenus de location';

  @override
  String get retry => 'Réessayer';

  @override
  String get rowPropertyMortgage => 'Propriété / hypothèque';

  @override
  String get rowRentalIncome => 'Revenus de location';

  @override
  String get rowVacancyLoss => 'Inoccupation / perte de revenu';

  @override
  String get saveFailed => 'Enregistrement impossible. Veuillez réessayer.';

  @override
  String get saveAsScenario => 'Enregistrer comme scénario';

  @override
  String get scenarioA => 'Scénario A';

  @override
  String get scenarioB => 'Scénario B';

  @override
  String get scenarioNameHint => 'p. ex. Refinancé à 4,5 %';

  @override
  String get scenarioNameLabel => 'Nom du scénario';

  @override
  String get scenarioNotFound => 'Scénario introuvable.';

  @override
  String get scenariosTitle => 'Scénarios';

  @override
  String get scheduleSection => 'Périodicité';

  @override
  String get selectPropertyScenario =>
      'Sélectionnez une propriété et un scénario pour commencer.';

  @override
  String get selectPropertyToBegin =>
      'Sélectionnez une propriété et un scénario pour commencer.';

  @override
  String get selectScenario => 'Sélectionnez un scénario';

  @override
  String get selectScenarioFinancing =>
      'Sélectionnez un scénario pour modifier le financement.';

  @override
  String get selectTwoScenarios =>
      'Sélectionnez deux scénarios différents à comparer.';

  @override
  String get settingsAbout => 'À propos';

  @override
  String get settingsLearn => 'Apprendre';

  @override
  String get shareDealSnapshot => 'Partager l\'aperçu de l\'affaire';

  @override
  String get shareTaxSummary => 'Partager le sommaire fiscal';

  @override
  String get sheetDone => 'Terminé';

  @override
  String get startFrom => 'Partir de';

  @override
  String get startFromPropertySubtitle =>
      'Choisissez de partir de zéro ou de copier une propriété existante.';

  @override
  String get startFromScenarioSubtitle =>
      'Copiez les chiffres d’un scénario existant ou partez de zéro.';

  @override
  String get startFromSubtitle =>
      'Choisissez de partir de zéro ou de copier une propriété existante.';

  @override
  String get startFromTitle => 'Point de départ';

  @override
  String get statExpenses => 'Dépenses';

  @override
  String get statIncome => 'Revenus';

  @override
  String get statInterest => 'Intérêts';

  @override
  String get statInterestRate => 'Taux d\'intérêt';

  @override
  String get statMortgage => 'Hypothèque';

  @override
  String get statPrincipal => 'Capital';

  @override
  String get streetAddress => 'Rue ou adresse';

  @override
  String get t776Header => 'Dépenses (catégories T776 de l\'ARC) :';

  @override
  String get taxCategoryAdvertising => 'Publicité';

  @override
  String get taxCategoryInsurance => 'Assurance';

  @override
  String get taxCategoryInterest => 'Intérêts';

  @override
  String get taxCategoryMaintenanceRepairs => 'Entretien et réparations';

  @override
  String get taxCategoryManagementAdmin => 'Gestion et administration';

  @override
  String get taxCategoryOffice => 'Fournitures de bureau';

  @override
  String get taxCategoryOther => 'Autres dépenses';

  @override
  String get taxCategoryProfessionalFees => 'Honoraires professionnels';

  @override
  String get taxCategoryPropertyTaxes => 'Taxes foncières';

  @override
  String get taxCategoryTravel => 'Déplacements';

  @override
  String get taxCategoryUtilities => 'Services publics';

  @override
  String get taxExportBasis =>
      'Basé sur les éléments récurrents, annualisé. Éléments ponctuels exclus.';

  @override
  String get taxExportInterestNote =>
      'Les intérêts sont une estimation (intérêts hypothécaires mensuels actuels × 12).';

  @override
  String taxExportScenario(String scenarioName) {
    return 'Scénario : $scenarioName';
  }

  @override
  String taxExportTitle(String propertyName, int year) {
    return 'Sommaire fiscal des revenus de location — $propertyName ($year)';
  }

  @override
  String get taxSummary => 'Sommaire fiscal';

  @override
  String taxSummaryBasisNote(String name) {
    return 'Basé sur le scénario principal « $name », annualisé. Les intérêts hypothécaires sont une estimation (intérêts mensuels actuels × 12) et n’apparaissent ici qu’à des fins fiscales — ils restent exclus du bénéfice d’exploitation net.';
  }

  @override
  String get testRefinance => 'Tester un refinancement…';

  @override
  String get taxSummaryButton => 'Sommaire fiscal';

  @override
  String taxSummaryTitle(String propertyName) {
    return 'Sommaire fiscal · $propertyName';
  }

  @override
  String get taxYear => 'Année d\'imposition';

  @override
  String get totalExpenses => 'Dépenses totales';

  @override
  String get totalInterestDifference => 'Différence d\'intérêts totaux';

  @override
  String get totalInterestNote =>
      'Les intérêts totaux sont simulés sur toute la durée d\'amortissement de chaque prêt.';

  @override
  String get totalInterestOverAmortization =>
      'Intérêts totaux sur l\'amortissement';

  @override
  String unableToCalculate(String error) {
    return 'Impossible de calculer ce scénario.\n$error';
  }

  @override
  String unableToLoadData(String error) {
    return 'Impossible de charger vos données.\n$error';
  }

  @override
  String get us => 'É.-U.';

  @override
  String get usCompounding => 'Capitalisation mensuelle';

  @override
  String get vacancyModeAmount => 'Montant';

  @override
  String get vacancyModePercent => 'Pourcentage';

  @override
  String vacancyOfGrossRent(String percent) {
    return '$percent des loyers bruts';
  }

  @override
  String get validationDownPaymentPercentRange =>
      'La mise de fonds doit être inférieure à 100 %';

  @override
  String get validationEnterAmount => 'Entrez un montant valide';

  @override
  String get validationEnterAnAmount => 'Entrez un montant';

  @override
  String get validationAmortizationRange => 'Entrez de 1 à 30 ans';

  @override
  String get validationEnterName => 'Entrez un nom';

  @override
  String get validationEnterNonNegative =>
      'Entrez un nombre valide non négatif';

  @override
  String get validationEnterPercentage => 'Entrez un pourcentage de 0 à 100';

  @override
  String get validationEnterPropertyName => 'Entrez un nom de propriété';

  @override
  String get validationEnterScenarioName => 'Entrez un nom de scénario';

  @override
  String get validationInvalidUrl =>
      'Entrez une URL valide commençant par http:// ou https://';

  @override
  String get validationMonthsRange => 'Les mois doivent être entre 0 et 11.';

  @override
  String get validationPercentRange => 'Entrez un pourcentage de 0 à 100';

  @override
  String get validationDownPaymentRange =>
      'La mise de fonds doit être inférieure au prix d\'achat';

  @override
  String get amortizationCappedNote =>
      'Amortissement limité à 25 ans avec moins de 20 % de mise de fonds.';

  @override
  String get amortizationYearsLabel => 'Amortissement (années)';

  @override
  String get bindingConstraintGds =>
      'Ce sont les coûts du logement qui limitent (ratio ABD).';

  @override
  String get bindingConstraintTds =>
      'Ce sont les dettes totales qui limitent (ratio ATD).';

  @override
  String get borrowingCapacityDisclaimer =>
      'Estimation seulement, basée sur les lignes directrices ABD/ATD et le test de résistance fédéral. Ne constitue pas un conseil financier ni une préapprobation — les prêteurs considèrent d’autres facteurs.';

  @override
  String get borrowingCapacityEnterTerms =>
      'Indiquez vos revenus et vos dettes pour voir votre estimation.';

  @override
  String get borrowingCapacitySubtitle =>
      'Estimez combien vous pourriez emprunter selon les règles canadiennes standards.';

  @override
  String get borrowingCapacityTitle => 'Capacité d’emprunt';

  @override
  String get creditScoreNote =>
      'Votre cote de crédit ne change pas ce calcul — elle change le taux auquel vous êtes admissible. C’est là qu’une bonne cote paie.';

  @override
  String get estimateBorrowingCapacity => 'Estimez votre capacité d’emprunt';

  @override
  String get estimatesSection => 'Estimations';

  @override
  String get estimatesSectionSubtitle =>
      'Estimations préremplies pour la future propriété — ajustez au besoin.';

  @override
  String get expectedMortgageRate => 'Taux hypothécaire prévu';

  @override
  String get expectedMortgageRateHint =>
      'Taux fixe 5 ans typique — ajustez selon votre situation.';

  @override
  String get grossAnnualIncome => 'Revenu brut annuel du ménage';

  @override
  String get incomeAndDebts => 'Revenus et dettes';

  @override
  String investmentDownPaymentError(String price, String required) {
    return 'Pour un immeuble à revenu, la mise de fonds doit être d’au moins 20 % du prix d’achat — environ $required pour un achat de $price.';
  }

  @override
  String get investmentPropertyNote =>
      'Estimation approximative — les prêteurs évaluent différemment les immeubles à revenu et peuvent inclure une partie des revenus locatifs, ce que cet outil ne modélise pas.';

  @override
  String get maxMortgageAmount => 'Hypothèque maximale';

  @override
  String get maxPurchasePrice => 'Prix d’achat maximal';

  @override
  String get minimumDownPayment => 'Mise de fonds minimale';

  @override
  String get monthlyDebtPayments => 'Paiements mensuels des dettes actuelles';

  @override
  String get monthlyHeating => 'Estimation du chauffage mensuel';

  @override
  String get monthlyPaymentAtContractRate => 'Paiement mensuel (à votre taux)';

  @override
  String get mortgageAmortization => 'Amortissement hypothécaire';

  @override
  String get mortgageAmortizationHint =>
      'En combien d’années rembourser le prêt — plus c’est long, plus les paiements sont petits, mais plus vous payez d’intérêts.';

  @override
  String percentValue(Object value) {
    return '$value%';
  }

  @override
  String get propertyTaxPercent => 'Taxes foncières (% du prix)';

  @override
  String get propertyUseInvestment => 'Immeuble à revenu';

  @override
  String get propertyUseLabel => 'Usage de la propriété';

  @override
  String get propertyUsePrincipal => 'Résidence principale';

  @override
  String get qualifyingRate => 'Taux admissible (test de résistance)';

  @override
  String get rateSensitivity => 'Sensibilité au taux';

  @override
  String get validationEnterPositive => 'Entrez un nombre positif valide';

  @override
  String versionLabel(String version) {
    return 'Version $version';
  }

  @override
  String get viewListing => 'Voir l\'annonce';

  @override
  String get whatIfDisclaimer =>
      'Ceci est une comparaison hypothétique, pas une offre de prêteur.';

  @override
  String whatIs(String title) {
    return 'Qu’est-ce que $title?';
  }

  @override
  String get invoicesTitle => 'Factures';

  @override
  String get invoicesEmptyTitle => 'Aucune facture';

  @override
  String get invoicesEmptySubtitle =>
      'Créez votre première facture pour commencer.';

  @override
  String get done => 'Terminé';

  @override
  String get invoiceNewTitle => 'Nouvelle facture';

  @override
  String get invoiceEditTitle => 'Modifier la facture';

  @override
  String get invoiceNumberLabel => 'Numéro de facture';

  @override
  String get invoiceClientLabel => 'Client';

  @override
  String get invoiceSelectClient => 'Choisir un client';

  @override
  String get invoiceClientRequired => 'Veuillez choisir un client.';

  @override
  String get invoiceNewClient => 'Nouveau client';

  @override
  String get invoiceIssueDate => 'Date d\'émission';

  @override
  String get invoiceDueDate => 'Date d\'échéance';

  @override
  String get invoiceStatusLabel => 'Statut';

  @override
  String get statusDraft => 'Brouillon';

  @override
  String get statusSent => 'Envoyée';

  @override
  String get statusPaid => 'Payée';

  @override
  String get statusOverdue => 'En retard';

  @override
  String get invoiceChargeTaxes => 'Percevoir TPS/TVQ';

  @override
  String get invoiceChargeTaxesHelper =>
      'Désactivez si vous êtes un petit fournisseur (non inscrit aux TPS/TVQ).';

  @override
  String get invoiceLinesLabel => 'Lignes';

  @override
  String get invoiceAddLine => 'Ajouter une ligne';

  @override
  String get invoiceLineDescription => 'Description';

  @override
  String get invoiceLineQty => 'Qté';

  @override
  String get invoiceLineUnitPrice => 'Prix unitaire';

  @override
  String get invoiceLinesRequired => 'Ajoutez au moins une ligne.';

  @override
  String get invoiceNotesLabel => 'Notes';

  @override
  String get invoiceNotesHint => 'Merci de votre confiance…';

  @override
  String get invoiceSubtotal => 'Sous-total';

  @override
  String get invoiceTotal => 'Total';

  @override
  String get invoiceDeleteTitle => 'Supprimer la facture ?';

  @override
  String invoiceDeleteMessage(Object number) {
    return 'La facture « $number » sera définitivement supprimée.';
  }

  @override
  String invoiceDueOn(Object date) {
    return 'Échéance : $date';
  }

  @override
  String get newInvoice => 'Nouvelle facture';

  @override
  String get settingsTitle => 'Réglages';

  @override
  String get navInvoices => 'Factures';

  @override
  String get navTools => 'Outils';

  @override
  String get navClients => 'Clients';

  @override
  String get clientsEmptyTitle => 'Aucun client pour l\'instant';

  @override
  String get clientsEmptyMessage =>
      'Ajoutez votre premier client pour commencer à le facturer.';

  @override
  String get clientsAddClient => 'Ajouter un client';

  @override
  String get clientsSearchHint => 'Rechercher des clients';

  @override
  String get clientsSearchClear => 'Effacer la recherche';

  @override
  String get clientsSortBy => 'Trier les clients';

  @override
  String get clientsSortTitle => 'Trier par';

  @override
  String get clientsSortNameAsc => 'Nom (A à Z)';

  @override
  String get clientsSortNameDesc => 'Nom (Z à A)';

  @override
  String get clientsSortNewest => 'Plus récents d\'abord';

  @override
  String get clientsSortOldest => 'Plus anciens d\'abord';

  @override
  String get clientsNoResultsTitle => 'Aucun client trouvé';

  @override
  String get clientsNoResultsMessage => 'Essayez une autre recherche.';

  @override
  String get clientNewTitle => 'Nouveau client';

  @override
  String get clientEditTitle => 'Modifier le client';

  @override
  String get clientNameLabel => 'Nom';

  @override
  String get clientNameRequired => 'Veuillez saisir le nom du client.';

  @override
  String get clientEmailLabel => 'Courriel';

  @override
  String get clientPhoneLabel => 'Téléphone';

  @override
  String get clientAddressLabel => 'Adresse';

  @override
  String get clientNotesLabel => 'Notes';

  @override
  String get clientNotesHint => 'Conditions de paiement, personne-ressource…';

  @override
  String get clientDeleteTitle => 'Supprimer le client ?';

  @override
  String clientDeleteMessage(Object name) {
    return '« $name » sera définitivement supprimé.';
  }

  @override
  String get save => 'Enregistrer';

  @override
  String get guideStep1Title => 'Ajoutez votre client';

  @override
  String get guideStep1Text =>
      'Enregistrez les entreprises que vous facturez, avec leurs coordonnées.';

  @override
  String get guideStep2Title => 'Créez une facture';

  @override
  String get guideStep2Text =>
      'Ajoutez des lignes — la TPS et la TVQ sont calculées automatiquement.';

  @override
  String get guideStep3Title => 'Envoyez le PDF';

  @override
  String get guideStep3Text =>
      'Exportez un PDF propre et partagez-le avec votre client.';

  @override
  String get tpsTvqTitle => 'Comprendre la TPS et la TVQ';

  @override
  String get tpsTvqSubtitle => 'Comment fonctionnent les taxes de vente.';

  @override
  String get tpsTvqBody1 =>
      'La TPS (5 %) s\'applique au montant avant taxes de chaque ligne.';

  @override
  String get tpsTvqBody2 =>
      'La TVQ (9,975 %) s\'applique au montant incluant la TPS — une taxe sur la taxe. C\'est la règle québécoise que la plupart des outils génériques ignorent.';

  @override
  String get tpsTvqBody3 =>
      'Chaque taxe est arrondie au cent près par ligne, puis additionnée. Si vos ventes taxables sont de 30 000 \$ ou moins, vous n\'avez peut-être pas besoin de vous inscrire ni de percevoir les taxes.';

  @override
  String get toolsTaxCalculator => 'Calculatrice TPS/TVQ';

  @override
  String get toolsTaxCalculatorSubtitle =>
      'Ajouter les taxes ou les extraire d\'un total.';

  @override
  String get calcAmountLabel => 'Montant';

  @override
  String get calcAddTaxes => 'Ajouter les taxes';

  @override
  String get calcExtractTaxes => 'Taxes incluses';

  @override
  String get calcPreTaxAmount => 'Montant avant taxes';

  @override
  String get calcTotalWithTaxes => 'Total avec taxes';

  @override
  String get dashboardUnpaid => 'Impayées';

  @override
  String get dashboardPaidMonth => 'Payées ce mois-ci';

  @override
  String get dashboardClients => 'Clients';

  @override
  String get dashboardSearchHint => 'Rechercher des factures';

  @override
  String get dashboardFilterAll => 'Toutes';

  @override
  String get dashboardNoResultsTitle => 'Aucune facture trouvée';

  @override
  String get dashboardNoResultsMessage =>
      'Essayez de modifier votre recherche ou votre filtre.';

  @override
  String get dashboardAttentionTitle => 'À relancer';

  @override
  String dashboardOverdueBy(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours de retard',
      one: '$days jour de retard',
    );
    return '$_temp0';
  }

  @override
  String get dashboardDueToday => 'Échéance aujourd\'hui';

  @override
  String dashboardDueIn(num days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Échéance dans $days jours',
      one: 'Échéance demain',
    );
    return '$_temp0';
  }

  @override
  String get proTitle => 'Facture Pro';

  @override
  String get proSubtitle => 'Débloquez la facturation illimitée';

  @override
  String get proFeatureUnlimited => 'Factures illimitées';

  @override
  String get proFeatureOneTime => 'Achat unique — à vous pour toujours';

  @override
  String get proFeatureNoSubscription => 'Sans abonnement, sans publicité';

  @override
  String proBuy(String price) {
    return 'Acheter — $price';
  }

  @override
  String get proActive => 'Pro actif';

  @override
  String get proRestore => 'Restaurer les achats';

  @override
  String get proRestoring => 'Restauration…';

  @override
  String get proNoticeUnavailable =>
      'Les achats sont indisponibles pour le moment. Réessayez plus tard.';

  @override
  String get proNoticeFailed => 'L\'achat n\'a pas abouti. Veuillez réessayer.';

  @override
  String get proNoticeRestored => 'Votre achat Pro a été restauré.';

  @override
  String get proNoticeNothingToRestore =>
      'Aucun achat précédent trouvé pour cet identifiant Apple.';

  @override
  String get proFinePrint =>
      'Le paiement est débité de votre identifiant Apple. Achat unique, sans abonnement.';

  @override
  String proFreeLimit(int used, int total) {
    return 'Plan gratuit : $used factures sur $total utilisées';
  }

  @override
  String get settingsPro => 'Facture Pro';

  @override
  String get settingsProSubtitleActive => 'Factures illimitées';

  @override
  String get settingsProSection => 'Abonnement';

  @override
  String get backupTitle => 'Sauvegarde et export';

  @override
  String get backupSubtitle => 'Enregistrez ou restaurez toutes vos données';

  @override
  String get backupExplainer =>
      'Votre sauvegarde contient tout : factures, clients, profil d\'entreprise et modèle de courriel. Conservez le fichier en lieu sûr — Facture n\'envoie jamais vos données nulle part.';

  @override
  String get backupSection => 'Sauvegarde';

  @override
  String get backupExport => 'Exporter la sauvegarde';

  @override
  String get backupExportSubtitle =>
      'Toutes vos données dans un seul fichier JSON';

  @override
  String get backupImport => 'Importer une sauvegarde';

  @override
  String get backupImportSubtitle =>
      'Restaurez tout depuis un fichier de sauvegarde JSON';

  @override
  String get backupImportConfirmTitle => 'Remplacer toutes les données ?';

  @override
  String get backupImportConfirmMessage =>
      'Vos factures, clients et réglages actuels seront remplacés par le contenu de la sauvegarde. Cette action est irréversible.';

  @override
  String get backupImportConfirmAction => 'Importer';

  @override
  String get backupRestored => 'Sauvegarde restaurée';

  @override
  String get backupInvalid =>
      'Ce fichier n\'est pas une sauvegarde Facture valide.';

  @override
  String get backupExportSection => 'Export';

  @override
  String get backupCsv => 'Factures (CSV)';

  @override
  String get backupCsvSubtitle => 'Pour votre comptable — s\'ouvre dans Excel';

  @override
  String get csvNumber => 'Numéro';

  @override
  String get csvClient => 'Client';

  @override
  String get csvIssueDate => 'Date d\'émission';

  @override
  String get csvDueDate => 'Échéance';

  @override
  String get csvStatus => 'Statut';

  @override
  String get csvSubtotal => 'Sous-total';

  @override
  String get csvTps => 'TPS';

  @override
  String get csvTvq => 'TVQ';

  @override
  String get csvTotal => 'Total';

  @override
  String get catalogTitle => 'Services et articles';

  @override
  String get catalogSubtitle => 'Lignes réutilisables pour vos factures';

  @override
  String get catalogAddItem => 'Ajouter un article';

  @override
  String get catalogNewTitle => 'Nouvel article';

  @override
  String get catalogEditTitle => 'Modifier l\'article';

  @override
  String get catalogDescriptionLabel => 'Description';

  @override
  String get catalogDescriptionHint => 'p. ex. Design de logo, à l\'heure';

  @override
  String get catalogDescriptionRequired => 'Entrez une description';

  @override
  String get catalogPriceLabel => 'Prix unitaire';

  @override
  String get catalogPriceRequired => 'Entrez un prix supérieur à 0 \$';

  @override
  String get catalogEmptyTitle => 'Aucun article enregistré';

  @override
  String get catalogEmptyMessage =>
      'Enregistrez les services et articles que vous facturez souvent, puis ajoutez-les à une facture en un toucher.';

  @override
  String get catalogPickTitle => 'Choisir au catalogue';

  @override
  String get invoiceAddBlankLine => 'Ligne vide';

  @override
  String get invoiceAddFromCatalog => 'Depuis le catalogue…';

  @override
  String get businessLogoLabel => 'Logo';

  @override
  String get businessLogoHint => 'Affiché sur vos factures PDF';

  @override
  String get businessLogoRemove => 'Retirer le logo';

  @override
  String get businessLogoCreate => 'Créer un logo';

  @override
  String get toolsLogoCreator => 'Créer un logo';

  @override
  String get toolsLogoCreatorSubtitle =>
      'Générez un logo à partir du nom de votre entreprise.';

  @override
  String get logoCreatorTitle => 'Créer un logo';

  @override
  String get logoCreatorSubtitle =>
      'Choisissez un style et une couleur, le nom de votre entreprise fait le reste.';

  @override
  String get logoCreatorNameLabel => 'Nom de l\'entreprise';

  @override
  String get logoCreatorStyleLabel => 'Style';

  @override
  String get logoCreatorStyleCircle => 'Cercle';

  @override
  String get logoCreatorStyleSquare => 'Carré arrondi';

  @override
  String get logoCreatorStyleWordmark => 'Logotype';

  @override
  String get logoCreatorColorLabel => 'Couleur';

  @override
  String get logoCreatorSave => 'Utiliser ce logo';

  @override
  String get logoCreatorEmptyName =>
      'Entrez le nom de votre entreprise pour voir un aperçu du logo.';

  @override
  String get onboardingGetStarted => 'Commencer';

  @override
  String get onboardingTagline =>
      'La facturation pour les travailleurs autonomes du Québec — sans abonnement.';

  @override
  String get onboardingBusinessTitle => 'Votre entreprise';

  @override
  String get onboardingBusinessSubtitle =>
      'Ces informations apparaîtront sur vos factures. Modifiables à tout moment dans Réglages.';

  @override
  String get onboardingBusinessContinue => 'Continuer';

  @override
  String get onboardingTaxRequired =>
      'Choisissez votre statut fiscal pour continuer';

  @override
  String get onboardingHowTitle => 'Comment ça marche';

  @override
  String get onboardingHow1Title => 'Créez des factures en quelques secondes';

  @override
  String get onboardingHow1Body =>
      'Ajoutez un client, des lignes, envoyez le PDF. C\'est tout.';

  @override
  String get onboardingHow2Title => 'Des taxes conformes au Québec';

  @override
  String get onboardingHow2Body =>
      'TPS 5 % et TVQ 9,975 % calculées à la québécoise — TVQ sur le montant incluant la TPS — automatiquement.';

  @override
  String get onboardingHow3Title => 'Vos données restent sur votre téléphone';

  @override
  String get onboardingHow3Body =>
      'Pas de compte, pas de nuage, pas de suivi. Vos factures ne quittent jamais votre appareil.';

  @override
  String get onboardingHowNext => 'Suivant';

  @override
  String get onboardingPricingTitle => 'Un prix simple';

  @override
  String get onboardingPricingSubtitle =>
      'Commencez gratuitement. Passez à Pro une fois, pour toujours.';

  @override
  String get onboardingFreeTitle => 'Gratuit';

  @override
  String get onboardingFreeBody => '3 factures — essayez toute l\'app.';

  @override
  String get onboardingStartFree => 'Commencer gratuitement';

  @override
  String get onboardingProBody =>
      'Factures illimitées. Achat unique, sans abonnement.';

  @override
  String get onboardingGetPro => 'Obtenir Facture Pro';
}
