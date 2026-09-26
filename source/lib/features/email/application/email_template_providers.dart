import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/email_template_repository.dart';
import '../domain/email_template.dart';

/// On-device email template repository (SharedPreferences JSON document).
final emailTemplateRepositoryProvider = Provider<EmailTemplateRepository>((
  ref,
) {
  return EmailTemplateRepository();
});

/// The user's invoice email template, or null when they haven't customized
/// it yet (the localized default template applies).
/// Async because the first load reads from disk.
final emailTemplateProvider =
    AsyncNotifierProvider<EmailTemplateNotifier, EmailTemplate?>(
      EmailTemplateNotifier.new,
    );

class EmailTemplateNotifier extends AsyncNotifier<EmailTemplate?> {
  @override
  Future<EmailTemplate?> build() {
    return ref.watch(emailTemplateRepositoryProvider).loadTemplate();
  }

  Future<void> saveTemplate(EmailTemplate template) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(emailTemplateRepositoryProvider).saveTemplate(template);
      return template;
    });
  }
}
