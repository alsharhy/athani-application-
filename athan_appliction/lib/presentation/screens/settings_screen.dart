import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../providers/settings_provider.dart';

/// شاشة الإعدادات
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  // طرق حساب مواقيت الصلاة المدعومة من API
  static const Map<int, String> calculationMethods = {
    0: 'جامعة العلوم الإسلامية - كراتشي',
    1: 'الجمعية الإسلامية لأمريكا الشمالية (ISNA)',
    2: 'رابطة العالم الإسلامي',
    3: 'أم القرى - مكة المكرمة',
    4: 'الهيئة المصرية العامة للمساحة',
    5: 'معهد الجيوفيزياء - جامعة طهران',
    7: 'معهد الخليج',
    8: 'الكويت',
    9: 'قطر',
    10: 'سنغافورة',
    11: 'فرنسا (UOIF)',
    12: 'تركيا (Diyanet)',
    13: 'روسيا',
    14: 'دبي',
    15: 'ماليزيا (JAKIM)',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('الإعدادات', style: GoogleFonts.cairo()),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // --- قسم المظهر ---
          _buildSectionTitle(context, 'المظهر'),
          const SizedBox(height: 8),
          _buildSettingsCard(
            context,
            children: [
              // الوضع الداكن
              SwitchListTile(
                title: Text('الوضع الداكن', style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  settings.isDarkMode ? 'مفعّل' : 'معطّل',
                  style: GoogleFonts.cairo(fontSize: 12),
                ),
                value: settings.isDarkMode,
                onChanged: (val) => settings.toggleTheme(val),
                secondary: Icon(
                  settings.isDarkMode ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- قسم الوقت ---
          _buildSectionTitle(context, 'الوقت'),
          const SizedBox(height: 8),
          _buildSettingsCard(
            context,
            children: [
              // صيغة الوقت
              SwitchListTile(
                title: Text('صيغة 24 ساعة', style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  settings.is24HourFormat ? '14:30' : '2:30 م',
                  style: GoogleFonts.cairo(fontSize: 12),
                ),
                value: settings.is24HourFormat,
                onChanged: (val) => settings.toggleTimeFormat(val),
                secondary: Icon(Icons.access_time_rounded, color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- قسم طريقة الحساب ---
          _buildSectionTitle(context, 'طريقة حساب المواقيت'),
          const SizedBox(height: 8),
          _buildSettingsCard(
            context,
            children: [
              ListTile(
                title: Text('طريقة الحساب', style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  calculationMethods[settings.calculationMethod] ?? 'غير محدد',
                  style: GoogleFonts.cairo(fontSize: 12),
                ),
                leading: Icon(Icons.calculate_rounded, color: colorScheme.primary),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () => _showCalculationMethodPicker(context, ref, settings),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // --- قسم الإشعارات ---
          _buildSectionTitle(context, 'الإشعارات'),
          const SizedBox(height: 8),
          _buildSettingsCard(
            context,
            children: [
              ListTile(
                title: Text('إعدادات الإشعارات', style: GoogleFonts.cairo(fontWeight: FontWeight.w600)),
                subtitle: Text('تفعيل وتعطيل إشعار كل صلاة', style: GoogleFonts.cairo(fontSize: 12)),
                leading: Icon(Icons.notifications_active_rounded, color: colorScheme.primary),
                trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16),
                onTap: () => _showNotificationSettings(context),
              ),
            ],
          ),
          const SizedBox(height: 30),

          // زر إعادة تعيين
          Center(
            child: TextButton.icon(
              onPressed: () => _resetSettings(context, ref, settings),
              icon: Icon(Icons.restart_alt_rounded, color: colorScheme.error),
              label: Text(
                'إعادة تعيين الإعدادات',
                style: GoogleFonts.cairo(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),

          // معلومات التطبيق
          Center(
            child: Column(
              children: [
                Icon(Icons.mosque_rounded, size: 30, color: colorScheme.primary.withValues(alpha: 0.4)),
                const SizedBox(height: 8),
                Text(
                  'مواقيت الصلاة v1.0.0',
                  style: GoogleFonts.cairo(
                    fontSize: 13,
                    color: colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Text(
        title,
        style: GoogleFonts.cairo(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
    );
  }

  Widget _buildSettingsCard(BuildContext context, {required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.1),
        ),
      ),
      child: Column(children: children),
    );
  }

  void _showCalculationMethodPicker(BuildContext context, WidgetRef ref, SettingsNotifier settings) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6,
          maxChildSize: 0.85,
          minChildSize: 0.4,
          expand: false,
          builder: (_, scrollController) {
            return Column(
              children: [
                // مقبض السحب
                Container(
                  margin: const EdgeInsets.only(top: 12),
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    'اختر طريقة الحساب',
                    style: GoogleFonts.cairo(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: calculationMethods.length,
                    itemBuilder: (_, index) {
                      final entry = calculationMethods.entries.elementAt(index);
                      final isSelected = settings.calculationMethod == entry.key;

                      return ListTile(
                        title: Text(
                          entry.value,
                          style: GoogleFonts.cairo(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : null,
                          ),
                        ),
                        trailing: isSelected
                            ? Icon(Icons.check_circle_rounded,
                                color: Theme.of(context).colorScheme.primary)
                            : null,
                        onTap: () {
                          settings.setCalculationMethod(entry.key);
                          Navigator.of(ctx).pop();
                        },
                      );
                    },
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showNotificationSettings(BuildContext context) {
    // شاشة إعدادات الإشعارات لكل صلاة
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const _NotificationSettingsPage(),
      ),
    );
  }

  void _resetSettings(BuildContext context, WidgetRef ref, SettingsNotifier settings) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('إعادة تعيين', style: GoogleFonts.cairo(fontWeight: FontWeight.bold)),
        content: Text(
          'هل تريد إعادة جميع الإعدادات إلى القيم الافتراضية؟',
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('إلغاء', style: GoogleFonts.cairo()),
          ),
          FilledButton(
            onPressed: () {
              settings.toggleTheme(false);
              settings.toggleTimeFormat(false);
              settings.setCalculationMethod(4);
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('تم إعادة تعيين الإعدادات', style: GoogleFonts.cairo()),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
            child: Text('تأكيد', style: GoogleFonts.cairo()),
          ),
        ],
      ),
    );
  }
}

/// صفحة إعدادات الإشعارات لكل صلاة بشكل منفصل
class _NotificationSettingsPage extends ConsumerStatefulWidget {
  const _NotificationSettingsPage();

  @override
  ConsumerState<_NotificationSettingsPage> createState() =>
      _NotificationSettingsPageState();
}

class _NotificationSettingsPageState
    extends ConsumerState<_NotificationSettingsPage> {
  // حالة الإشعارات لكل صلاة (محلية مؤقتة - يمكن ربطها بـ SharedPreferences)
  final Map<String, bool> _notifications = {
    'الفجر': true,
    'الشروق': false,
    'الظهر': true,
    'العصر': true,
    'المغرب': true,
    'العشاء': true,
  };

  final Map<String, IconData> _icons = {
    'الفجر': Icons.brightness_3_rounded,
    'الشروق': Icons.wb_sunny_outlined,
    'الظهر': Icons.wb_sunny_rounded,
    'العصر': Icons.sunny_snowing,
    'المغرب': Icons.nights_stay_rounded,
    'العشاء': Icons.dark_mode_rounded,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('إشعارات الصلاة', style: GoogleFonts.cairo()),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline_rounded, color: colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'فعّل الإشعارات التي تريد تلقيها عند دخول وقت الصلاة.',
                    style: GoogleFonts.cairo(fontSize: 13, color: colorScheme.onSurface),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ..._notifications.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: colorScheme.outline.withValues(alpha: 0.1),
                ),
              ),
              child: SwitchListTile(
                title: Text(
                  entry.key,
                  style: GoogleFonts.cairo(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                secondary: Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: entry.value
                        ? colorScheme.primaryContainer.withValues(alpha: 0.5)
                        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    _icons[entry.key],
                    color: entry.value ? colorScheme.primary : colorScheme.onSurface.withValues(alpha: 0.4),
                  ),
                ),
                value: entry.value,
                onChanged: (val) {
                  setState(() {
                    _notifications[entry.key] = val;
                  });
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
