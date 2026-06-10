import 'package:flutter/material.dart';

import '../../../services/auth_service.dart';
import '../../../services/firestore_service.dart';
import 'admin_dashboard_screen.dart';

/// 관리자 로그인 화면 (Firebase 계정 + Firestore 권한 확인)
class AdminLoginScreen extends StatefulWidget {
  const AdminLoginScreen({super.key});

  @override
  State<AdminLoginScreen> createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  bool _isLoading = false;
  String? _error;
  Future<void> _loginWithGoogle() async {
    setState(() {
      _error = null;
      _isLoading = true;
    });

    try {
      final credential = await AuthService.instance.signInWithGoogle();
      if (credential == null) {
        setState(() {
          _error = '로그인이 취소되었습니다';
          _isLoading = false;
        });
        return;
      }

      final isAdmin = await FirestoreService.instance.isCurrentUserAdmin();
      if (!isAdmin) {
        await AuthService.instance.signOut();
        if (!mounted) return;
        setState(() {
          _error = '관리자 권한이 없습니다';
          _isLoading = false;
        });
        return;
      }

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const AdminDashboardScreen()),
      );
    } catch (_) {
      setState(() {
        _error = '로그인 중 오류가 발생했습니다';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1a1a2e), Color(0xFF16213e), Color(0xFF0f3460)],
          ),
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 400),
            padding: const EdgeInsets.all(32),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 로고
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: const Color(0xFFe94560).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Icon(
                        Icons.admin_panel_settings,
                        size: 48,
                        color: Color(0xFFe94560),
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Linkku 관리자',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Google 로그인 후 관리자 권한을 확인합니다',
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 32),

                    if (_error != null) ...[
                      Text(
                        _error!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                    ],

                    // 로그인 버튼
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isLoading ? null : _loginWithGoogle,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFe94560),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text('Google로 로그인'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
