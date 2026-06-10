import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart' hide ImageFormat;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import '../../../core/theme/spacing.dart';
import '../../../providers/user_provider.dart';
import 'verification_upload_sheet.dart';

/// 3초 인증 영상 촬영 화면.
/// 카메라 초기화 → 카운트다운 → 자동 녹화 정지 → 미리보기 → 업로드.
class VerificationRecordScreen extends ConsumerStatefulWidget {
  final String? sharedLinkId;
  final String alarmTitle;

  const VerificationRecordScreen({
    super.key,
    required this.alarmTitle,
    this.sharedLinkId,
  });

  static const int recordSeconds = 3;

  @override
  ConsumerState<VerificationRecordScreen> createState() =>
      _VerificationRecordScreenState();
}

class _VerificationRecordScreenState
    extends ConsumerState<VerificationRecordScreen>
    with WidgetsBindingObserver {
  CameraController? _controller;
  Future<void>? _initFuture;
  bool _isRecording = false;
  bool _enableAudio = true;
  int _countdownRemaining = VerificationRecordScreen.recordSeconds;
  Timer? _timer;
  String? _recordedPath;
  String? _thumbnailPath;
  bool _frontCamera = true;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('카메라를 찾을 수 없어요')),
        );
      }
      return;
    }

    final selected = cameras.firstWhere(
      (c) =>
          c.lensDirection ==
          (_frontCamera
              ? CameraLensDirection.front
              : CameraLensDirection.back),
      orElse: () => cameras.first,
    );

    final isPremium = ref.read(userProfileProvider).value?.isPremium ?? false;
    // 비용 절감: 인증 영상은 짧고 작은 화면에서 보여주는 용도라 한 단계씩 낮춤.
    // 프리미엄: high(1280×720) → medium(640×480), 일반: medium → low(320×240).
    final preset = isPremium ? ResolutionPreset.medium : ResolutionPreset.low;

    final controller = CameraController(
      selected,
      preset,
      enableAudio: _enableAudio,
    );

    setState(() {
      _controller = controller;
      _initFuture = controller.initialize();
    });

    try {
      await _initFuture;
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('카메라 초기화 실패: $e')),
        );
      }
    }
    if (mounted) setState(() {});
  }

  Future<void> _switchCamera() async {
    setState(() => _frontCamera = !_frontCamera);
    await _controller?.dispose();
    await _initCamera();
  }

  Future<void> _toggleAudio() async {
    setState(() => _enableAudio = !_enableAudio);
    await _controller?.dispose();
    await _initCamera();
  }

  Future<void> _startRecording() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (_isRecording) return;

    try {
      await controller.startVideoRecording();
      if (!mounted) return;
      setState(() {
        _isRecording = true;
        _countdownRemaining = VerificationRecordScreen.recordSeconds;
      });

      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        setState(() => _countdownRemaining--);
        if (_countdownRemaining <= 0) {
          timer.cancel();
          _stopRecording();
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('녹화 시작 실패: $e')),
        );
      }
    }
  }

  Future<void> _stopRecording() async {
    final controller = _controller;
    if (controller == null) return;
    if (!controller.value.isRecordingVideo) return;

    try {
      final file = await controller.stopVideoRecording();
      _timer?.cancel();

      // 임시 디렉토리로 이동 (camera 패키지는 이미 임시 위치에 저장)
      final dir = await getTemporaryDirectory();
      final destPath =
          '${dir.path}/verification_${DateTime.now().millisecondsSinceEpoch}.mp4';
      await File(file.path).copy(destPath);

      // 썸네일 추출 (첫 프레임)
      String? thumbPath;
      try {
        thumbPath = await VideoThumbnail.thumbnailFile(
          video: destPath,
          thumbnailPath: dir.path,
          imageFormat: ImageFormat.JPEG,
          quality: 75,
          maxWidth: 320,
        );
      } catch (_) {
        // 썸네일 실패해도 영상 자체는 사용 가능
      }

      if (!mounted) return;
      setState(() {
        _isRecording = false;
        _recordedPath = destPath;
        _thumbnailPath = thumbPath;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('녹화 정지 실패: $e')),
        );
      }
    }
  }

  Future<void> _onUpload() async {
    final recorded = _recordedPath;
    if (recorded == null) return;
    final profile = ref.read(userProfileProvider).value;
    if (profile == null) return;

    final resolution = profile.isPremium ? 720 : 360;

    final uploaded = await VerificationUploadSheet.show(
      context,
      videoFile: File(recorded),
      thumbnailFile: _thumbnailPath != null ? File(_thumbnailPath!) : null,
      uploaderNickname: profile.nickname,
      uploaderProfileEmoji: profile.profileEmoji,
      resolution: resolution,
      sharedLinkId: widget.sharedLinkId,
    );

    if (uploaded == true && mounted) Navigator.pop(context, true);
  }

  void _retake() {
    setState(() {
      _recordedPath = null;
      _thumbnailPath = null;
      _countdownRemaining = VerificationRecordScreen.recordSeconds;
    });
  }

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context);
    final isKorean = locale.languageCode == 'ko';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          _recordedPath != null
              ? (isKorean ? '미리보기' : 'Preview')
              : (isKorean ? '3초 인증' : '3-sec Proof'),
        ),
        actions: [
          if (_recordedPath == null)
            IconButton(
              icon: Icon(_enableAudio ? Icons.mic : Icons.mic_off),
              tooltip: isKorean ? '소리 켜기/끄기' : 'Toggle audio',
              onPressed: _toggleAudio,
            ),
          if (_recordedPath == null)
            IconButton(
              icon: const Icon(Icons.cameraswitch),
              tooltip: isKorean ? '카메라 전환' : 'Switch camera',
              onPressed: _switchCamera,
            ),
        ],
      ),
      body: _recordedPath != null
          ? _buildPreview(isKorean)
          : _buildRecorder(isKorean),
    );
  }

  Widget _buildRecorder(bool isKorean) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(
        child: CircularProgressIndicator(color: Colors.white),
      );
    }
    return Stack(
      children: [
        Positioned.fill(child: CameraPreview(_controller!)),
        if (_isRecording)
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.md,
                  vertical: Spacing.sm,
                ),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.fiber_manual_record,
                        color: Colors.white, size: 16),
                    const SizedBox(width: 6),
                    Text(
                      '$_countdownRemaining',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).padding.bottom + Spacing.lg,
              top: Spacing.lg,
              left: Spacing.lg,
              right: Spacing.lg,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.6),
                ],
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isKorean
                      ? '"${widget.alarmTitle}"\n방금 다녀온 알람을 3초 인증해봐!'
                      : '"${widget.alarmTitle}"\nRecord a 3-sec proof!',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: Spacing.lg),
                GestureDetector(
                  onTap: _isRecording ? null : _startRecording,
                  child: Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: _isRecording
                          ? Colors.red.withValues(alpha: 0.6)
                          : Colors.transparent,
                      border: Border.all(
                        color: Colors.white,
                        width: 4,
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.red,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: Spacing.sm),
                Text(
                  _isRecording
                      ? (isKorean ? '녹화 중...' : 'Recording...')
                      : (isKorean ? '버튼 눌러 녹화 시작' : 'Tap to record'),
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.8),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPreview(bool isKorean) {
    return Column(
      children: [
        Expanded(
          child: Container(
            color: Colors.black,
            child: Center(
              child: _thumbnailPath != null
                  ? Image.file(File(_thumbnailPath!))
                  : Icon(
                      Icons.videocam,
                      size: 96,
                      color: Colors.white.withValues(alpha: 0.5),
                    ),
            ),
          ),
        ),
        SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.all(Spacing.lg),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.refresh),
                    label: Text(isKorean ? '다시 찍기' : 'Retake'),
                    onPressed: _retake,
                  ),
                ),
                const SizedBox(width: Spacing.md),
                Expanded(
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    icon: const Icon(Icons.cloud_upload_outlined),
                    label: Text(isKorean ? '업로드' : 'Upload'),
                    onPressed: _onUpload,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
