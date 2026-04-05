import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final lang = Localizations.localeOf(context).languageCode;
    final url = 'https://linkping-prod.web.app/privacy?lang=$lang';

    WidgetsBinding.instance.addPostFrameCallback((_) {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
      Navigator.pop(context);
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyPolicy)),
      body: const Center(child: CircularProgressIndicator()),
    );
  }
}
