import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'صلِّ على النبي ﷺ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF051109),
        textTheme: GoogleFonts.cairoTextTheme(
          ThemeData(brightness: Brightness.dark).textTheme,
        ).apply(
          bodyColor: const Color(0xFFD4EADB),
          displayColor: const Color(0xFFD4EADB),
        ),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String mode = 'unlock';
  String intervalVal = 'كل مرة';
  bool showToast = false;
  bool autoHide = true;
  int duration = 1;
  bool sound = false;
  bool vibration = true;
  bool permissionGranted = false;
  TimeOfDay morningTime = const TimeOfDay(hour: 7, minute: 0);
  TimeOfDay eveningTime = const TimeOfDay(hour: 18, minute: 0);

  Timer? _toastTimer;

  String _formatTime(TimeOfDay t) {
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  void handlePreview() {
    setState(() => showToast = true);
    _toastTimer?.cancel();
    if (autoHide) {
      _toastTimer = Timer(Duration(seconds: duration), () {
        if (mounted) setState(() => showToast = false);
      });
    }
  }

  void requestPermission() {
    setState(() => permissionGranted = true);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم منح إذن الإشعارات بنجاح',
          style: GoogleFonts.cairo(),
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: const Color(0xFF1C3D2C),
      ),
    );
  }

  void saveSettings() {
    handlePreview();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم حفظ الإعدادات وتفعيل التذكير بنجاح',
          style: GoogleFonts.cairo(),
          textDirection: TextDirection.rtl,
        ),
        backgroundColor: const Color(0xFFC9A84C),
      ),
    );
  }

  Future<void> _pickTime(bool isMorning) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: isMorning ? morningTime : eveningTime,
      builder: (context, child) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        if (isMorning) morningTime = picked;
        else eveningTime = picked;
      });
    }
  }

  @override
  void dispose() {
    _toastTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Stack(
            children: [
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width > 600 ? 480 : double.infinity,
                  ),
                  child: ListView(
                    padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * 0.04,
                      vertical: 20,
                    ),
                    children: [
                      _buildHeaderCard(),
                      const SizedBox(height: 16),
                      _buildPreviewButton(),
                      const SizedBox(height: 16),
                      _buildModeSelection(),
                      const SizedBox(height: 16),
                      _buildNotificationSettings(),
                      const SizedBox(height: 16),
                      _buildPermissionCard(),
                      const SizedBox(height: 16),
                      _buildSaveButton(),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
              // Toast Notification
              AnimatedPositioned(
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeOutCubic,
                top: showToast ? 16 : -160,
                left: 16,
                right: 16,
                child: GestureDetector(
                  onTap: () => setState(() => showToast = false),
                  child: Material(
                    color: Colors.transparent,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xEE163324),
                        border: Border.all(color: const Color(0xFFC9A84C)),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black54,
                            blurRadius: 20,
                            offset: Offset(0, 10),
                          )
                        ],
                      ),
                      child: Row(
                        textDirection: TextDirection.rtl,
                        children: [
                          const Text('🌙', style: TextStyle(fontSize: 26)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'صلِّ على الحبيب ﷺ',
                                  style: GoogleFonts.amiri(
                                    color: const Color(0xFFE8C96A),
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'قلبك يطيب 💛 اللهم صلِّ وسلِّم على سيدنا محمد',
                                  style: GoogleFonts.cairo(
                                    color: const Color(0xFF7AAA8A),
                                    fontSize: 11,
                                  ),
                                  textDirection: TextDirection.rtl,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'الآن',
                            style: GoogleFonts.cairo(
                              color: const Color(0xFF7A6128),
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2115),
        border: Border.all(color: const Color(0xFF1A3324)),
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 20, offset: Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              boxShadow: [BoxShadow(color: Color(0x66FFD700), blurRadius: 24)],
            ),
            child: Transform.rotate(
              angle: -0.2,
              child: const Icon(Icons.nightlight_round, color: Color(0xFFFFD700), size: 64),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'اللهم صلِّ على سيدنا محمد ﷺ',
            style: GoogleFonts.amiri(
              color: const Color(0xFFF3D991),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 4),
          Text(
            'تطبيق التذكير بالصلاة على النبي',
            style: GoogleFonts.cairo(color: const Color(0xFFA8D5B8), fontSize: 12),
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 20),
          Container(height: 0.5, color: const Color(0x44C9A84C)),
          const SizedBox(height: 20),
          Text(
            '«إنَّ أَوْلَى النَّاسِ بِي يَوْمَ القِيَامَةِ أَكْثَرُهُمْ عَلَيَّ صَلَاةً»',
            style: GoogleFonts.amiri(
              color: const Color(0xFFF3D991),
              fontSize: 14,
              height: 1.9,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('✦', style: TextStyle(color: Color(0xFFC9A84C), fontSize: 10)),
              SizedBox(width: 16),
              Text('✦', style: TextStyle(color: Color(0xFFC9A84C), fontSize: 10)),
              SizedBox(width: 16),
              Text('✦', style: TextStyle(color: Color(0xFFC9A84C), fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '«مَنْ صَلَّى عَلَيَّ صَلَاةً صَلَّى اللَّهُ عَلَيْهِ بِهَا عَشْرًا»',
            style: GoogleFonts.amiri(
              color: const Color(0xFFF3D991),
              fontSize: 14,
              height: 1.9,
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
          ),
        ],
      ),
    );
  }

  Widget _buildPreviewButton() {
    return InkWell(
      onTap: handlePreview,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFF0D2115),
          border: Border.all(color: const Color(0xFFC9A84C), width: 2),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.remove_red_eye, color: Color(0xFFF3D991), size: 18),
                const SizedBox(width: 8),
                Text(
                  'اضغط لمعاينة الإشعار',
                  style: GoogleFonts.cairo(
                    color: const Color(0xFFF3D991),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'يظهر ثم يختفي تلقائياً',
              style: GoogleFonts.cairo(color: const Color(0xFF7AAA8A), fontSize: 11),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2115),
        border: Border.all(color: const Color(0xFF1A3324)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.settings, color: Color(0xFFC9A84C), size: 15),
              const SizedBox(width: 8),
              Text(
                'وقت الإشعار',
                style: GoogleFonts.cairo(
                  color: const Color(0xFFC9A84C),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(child: _buildModeButton('unlock', 'عند فتح الشاشة', Icons.smartphone)),
              const SizedBox(width: 10),
              Expanded(child: _buildModeButton('time', 'أوقات محددة', Icons.access_time)),
            ],
          ),
          if (mode == 'unlock') ...[
            const SizedBox(height: 14),
            Text(
              'الحد الأدنى بين الإشعارات:',
              style: GoogleFonts.cairo(color: const Color(0xFF7AAA8A), fontSize: 11),
              textDirection: TextDirection.rtl,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildIntervalButton('كل مرة')),
                const SizedBox(width: 8),
                Expanded(child: _buildIntervalButton('كل 15د')),
                const SizedBox(width: 8),
                Expanded(child: _buildIntervalButton('كل 30د')),
              ],
            ),
          ] else ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(child: _buildTimeInput('🌅 الصباح', morningTime, true)),
                const SizedBox(width: 10),
                Expanded(child: _buildTimeInput('🌆 المساء', eveningTime, false)),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildModeButton(String modeValue, String title, IconData icon) {
    final isActive = mode == modeValue;
    return InkWell(
      onTap: () => setState(() => mode = modeValue),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1C3D2C) : const Color(0xFF0F2218),
          border: Border.all(
            color: isActive ? const Color(0xFFC9A84C) : const Color(0xFF2A5038),
            width: isActive ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: isActive ? const Color(0xFFE8C96A) : const Color(0xFF7AAA8A), size: 20),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.cairo(
                color: isActive ? const Color(0xFFE8C96A) : const Color(0xFF7AAA8A),
                fontSize: 11,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalButton(String val) {
    final isActive = intervalVal == val;
    return InkWell(
      onTap: () => setState(() => intervalVal = val),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1A3326) : const Color(0xFF0F2218),
          border: Border.all(
            color: isActive ? const Color(0xFFC9A84C) : const Color(0xFF2A5038),
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        alignment: Alignment.center,
        child: Text(
          val,
          style: GoogleFonts.cairo(
            color: isActive ? const Color(0xFFE8C96A) : const Color(0xFF7AAA8A),
            fontSize: 11,
          ),
        ),
      ),
    );
  }

  Widget _buildTimeInput(String label, TimeOfDay time, bool isMorning) {
    return InkWell(
      onTap: () => _pickTime(isMorning),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0F2218),
          border: Border.all(color: const Color(0xFF2A5038)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: GoogleFonts.cairo(color: const Color(0xFF7A6128), fontSize: 10)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(time),
                  style: GoogleFonts.cairo(
                    color: const Color(0xFFE8C96A),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Icon(Icons.edit, color: Color(0xFF7A6128), size: 14),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationSettings() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2115),
        border: Border.all(color: const Color(0xFF1A3324)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.notifications, color: Color(0xFFC9A84C), size: 15),
              const SizedBox(width: 8),
              Text(
                'إعدادات الإشعار',
                style: GoogleFonts.cairo(
                  color: const Color(0xFFC9A84C),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildToggleRow(
            'اختفاء تلقائي',
            'بعد ثوانٍ من الظهور',
            autoHide,
            (v) => setState(() => autoHide = v),
            icon: Icons.timer,
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('⏱ مدة بقاء الإشعار', style: GoogleFonts.cairo(color: const Color(0xFFD4EADB), fontSize: 12)),
              Text('ثوانٍ', style: GoogleFonts.cairo(color: const Color(0xFF7AAA8A), fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildDurationButton(1, '١', 'ثانية')),
              const SizedBox(width: 8),
              Expanded(child: _buildDurationButton(2, '٢', 'ثانيتان')),
              const SizedBox(width: 8),
              Expanded(child: _buildDurationButton(3, '٣', 'ثوانٍ')),
            ],
          ),
          const SizedBox(height: 16),
          _buildToggleRow(
            'صوت خفيف',
            'تنبيه صوتي عند الإشعار',
            sound,
            (v) => setState(() => sound = v),
            icon: Icons.volume_up,
          ),
          const SizedBox(height: 16),
          _buildToggleRow(
            'اهتزاز',
            'تنبيه باهتزاز الجهاز',
            vibration,
            (v) => setState(() => vibration = v),
            icon: Icons.vibration,
          ),
        ],
      ),
    );
  }

  Widget _buildDurationButton(int val, String numStr, String label) {
    final isActive = duration == val;
    return InkWell(
      onTap: () => setState(() => duration = val),
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF1C3D2C) : const Color(0xFF0F2218),
          border: Border.all(
            color: isActive ? const Color(0xFFC9A84C) : const Color(0xFF2A5038),
            width: isActive ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              numStr,
              style: GoogleFonts.cairo(
                color: isActive ? const Color(0xFFE8C96A) : const Color(0xFF7AAA8A),
                fontSize: 24,
                fontWeight: FontWeight.w900,
              ),
            ),
            Text(
              label,
              style: GoogleFonts.cairo(color: const Color(0xFF7AAA8A), fontSize: 9),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToggleRow(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged, {
    IconData? icon,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(icon, color: const Color(0xFFC9A84C), size: 18),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.cairo(color: const Color(0xFFD4EADB), fontSize: 12),
                      textDirection: TextDirection.rtl,
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.cairo(color: const Color(0xFF7AAA8A), fontSize: 10),
                      textDirection: TextDirection.rtl,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        GestureDetector(
          onTap: () => onChanged(!value),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            width: 48,
            height: 26,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              color: value ? const Color(0xFF1C4A30) : const Color(0xFF0F2218),
              border: Border.all(
                color: value ? const Color(0xFFC9A84C) : const Color(0xFF2A5038),
              ),
            ),
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 250),
              // FIX: In RTL, "on" = right side, "off" = left side
              alignment: value ? Alignment.centerRight : Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: value ? const Color(0xFFE8C96A) : const Color(0xFF7AAA8A),
                    boxShadow: value
                        ? [const BoxShadow(color: Color(0xFFC9A84C), blurRadius: 8)]
                        : null,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPermissionCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0D2115),
        border: Border.all(color: const Color(0xFF1A3324)),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '🔔 إذن الإشعارات',
            style: GoogleFonts.cairo(
              color: const Color(0xFFC9A84C),
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          InkWell(
            onTap: requestPermission,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14),
              decoration: BoxDecoration(
                color: const Color(0xFF1C3D2C),
                border: Border.all(color: const Color(0xFFC9A84C), width: 2),
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(
                '⚙️ فتح الإعدادات لتفعيل الإشعارات',
                style: GoogleFonts.cairo(
                  color: const Color(0xFFE8C96A),
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textDirection: TextDirection.rtl,
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: permissionGranted ? const Color(0xFF0F2A12) : const Color(0xFF2A0F0F),
              border: Border.all(
                color: permissionGranted ? const Color(0xFF2A5A30) : const Color(0xFF5A2A2A),
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: permissionGranted ? const Color(0xFF4CAF50) : const Color(0xFFCF4444),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    permissionGranted
                        ? '✓ الإذن ممنوح — التطبيق جاهز للعمل'
                        : 'اضغط الزر أعلاه لتفعيل الإشعارات',
                    style: GoogleFonts.cairo(
                      color: permissionGranted ? const Color(0xFF6DBF6D) : const Color(0xFFBF6D6D),
                      fontSize: 11,
                    ),
                    textDirection: TextDirection.rtl,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return InkWell(
      onTap: saveSettings,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF7A6128), Color(0xFFC9A84C), Color(0xFFE8C96A)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: const [
            BoxShadow(color: Color(0x55C9A84C), blurRadius: 16, offset: Offset(0, 6)),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'حفظ الإعدادات وتفعيل التذكير ✓',
          style: GoogleFonts.cairo(
            color: const Color(0xFF0B1F0E),
            fontSize: 14,
            fontWeight: FontWeight.w900,
          ),
          textDirection: TextDirection.rtl,
        ),
      ),
    );
  }
}
