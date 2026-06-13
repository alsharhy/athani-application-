import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../domain/entities/location_entity.dart';
import '../providers/location_provider.dart';

/// شاشة البحث عن المدن واختيار الموقع
class LocationSearchScreen extends ConsumerStatefulWidget {
  const LocationSearchScreen({super.key});

  @override
  ConsumerState<LocationSearchScreen> createState() =>
      _LocationSearchScreenState();
}

class _LocationSearchScreenState extends ConsumerState<LocationSearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<LocationEntity> _searchResults = [];
  bool _isSearching = false;
  Timer? _debounce;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    // تأخير البحث حتى يتوقف المستخدم عن الكتابة (Debounce)
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (query.trim().isEmpty) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
        return;
      }

      setState(() => _isSearching = true);
      final results =
          await ref.read(locationProvider.notifier).searchLocations(query);
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    });
  }

  Future<void> _useCurrentLocation() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(
        child: Container(
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(),
              const SizedBox(height: 16),
              Text(
                'جارٍ تحديد موقعك...',
                style: GoogleFonts.cairo(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );

    await ref.read(locationProvider.notifier).getCurrentLocation();

    if (mounted) {
      Navigator.of(context).pop(); // إغلاق الحوار
      Navigator.of(context).pop(); // الرجوع للرئيسية
    }
  }

  void _selectCity(LocationEntity location) async {
    await ref.read(locationProvider.notifier).setLocation(location);
    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('اختيار المدينة', style: GoogleFonts.cairo()),
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
      ),
      body: Column(
        children: [
          // حقل البحث
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.05),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  textDirection: TextDirection.rtl,
                  decoration: InputDecoration(
                    hintText: 'ابحث عن مدينة...',
                    hintStyle: GoogleFonts.cairo(
                      color: colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchResults = [];
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: colorScheme.surface,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.outline.withValues(alpha: 0.2),
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide(
                        color: colorScheme.primary,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                  ),
                  style: GoogleFonts.cairo(fontSize: 16),
                ),
                const SizedBox(height: 12),
                // زر الموقع التلقائي
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _useCurrentLocation,
                    icon: const Icon(Icons.my_location_rounded),
                    label: Text(
                      'استخدام موقعي الحالي',
                      style: GoogleFonts.cairo(fontWeight: FontWeight.w600),
                    ),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: BorderSide(color: colorScheme.primary),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // مؤشر التحميل أو النتائج
          if (_isSearching)
            const Padding(
              padding: EdgeInsets.all(32),
              child: CircularProgressIndicator(),
            )
          else if (_searchResults.isEmpty && _searchController.text.isNotEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      size: 60,
                      color: colorScheme.onSurface.withValues(alpha: 0.3),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'لم يتم العثور على نتائج',
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.5),
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: _searchResults.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final loc = _searchResults[index];
                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _selectCity(loc),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: colorScheme.surface,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(
                            color:
                                colorScheme.outline.withValues(alpha: 0.15),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: colorScheme.primaryContainer
                                    .withValues(alpha: 0.4),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(
                                Icons.location_city_rounded,
                                color: colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loc.cityName ?? 'مدينة غير معروفة',
                                    style: GoogleFonts.cairo(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: colorScheme.onSurface,
                                    ),
                                  ),
                                  if (loc.countryName != null)
                                    Text(
                                      loc.countryName!,
                                      style: GoogleFonts.cairo(
                                        fontSize: 13,
                                        color: colorScheme.onSurface
                                            .withValues(alpha: 0.6),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 16,
                              color:
                                  colorScheme.onSurface.withValues(alpha: 0.3),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
