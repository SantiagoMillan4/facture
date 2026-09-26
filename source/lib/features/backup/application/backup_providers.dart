import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../business/application/business_profile_providers.dart';
import '../../catalog/application/catalog_providers.dart';
import '../../clients/application/clients_providers.dart';
import '../../email/application/email_template_providers.dart';
import '../../invoices/application/invoices_providers.dart';
import 'backup_service.dart';

/// The backup/export service, wired to the on-device repositories.
final backupServiceProvider = Provider<BackupService>((ref) {
  return BackupService(
    invoices: ref.watch(invoicesRepositoryProvider),
    clients: ref.watch(clientsRepositoryProvider),
    business: ref.watch(businessProfileRepositoryProvider),
    email: ref.watch(emailTemplateRepositoryProvider),
    catalog: ref.watch(catalogRepositoryProvider),
  );
});
