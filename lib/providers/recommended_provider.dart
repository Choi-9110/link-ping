import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/recommended_link.dart';
import '../services/firestore_service.dart';

/// 추천 링크 목록 Provider (Firestore에서 fetch)
final recommendedLinksProvider =
    FutureProvider<List<RecommendedLink>>((ref) async {
  return FirestoreService.instance.getRecommendedLinks();
});
