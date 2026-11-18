import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/yatra_colors.dart';
import '../../../core/theme/yatra_typography.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _rampDefault = true;
  bool _extraTimeDefault = true;
  bool _audioChimes = true;
  bool _highContrast = false;
  String _selectedLanguage = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: YatraColors.parchmentBg,
      appBar: AppBar(
        title: Text('Accessibility Profile', style: YatraTypography.sectionTitle(fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
          children: [
            // User Concession Card
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [YatraColors.navyDeep, Color(0xFF0F172A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(color: Color(0x1A000000), blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'YATRA CONCESSION CARD',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFACC15),
                          letterSpacing: 1.2,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: YatraColors.heritageGreen,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'VERIFIED',
                          style: TextStyle(fontFamily: 'Inter', fontSize: 9, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Aarav Sharma',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'UDID #DL-2026-91827 · Mobility Category A',
                    style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: Color(0xFFCBD5E1)),
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Delhi Transport Corporation Pass',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: Colors.white70),
                      ),
                      Text(
                        'Expires Dec 2027',
                        style: TextStyle(fontFamily: 'Inter', fontSize: 10, color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Accessibility Preferences Section
            Text(
              'Boarding & Assistance Defaults',
              style: YatraTypography.sectionTitle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: YatraColors.surfaceCream,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: YatraColors.softBorder),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    title: const Text('Default Wheelchair Ramp', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Pre-selects ramp deployment for all AccessHandshake signals', style: TextStyle(fontSize: 12)),
                    activeThumbColor: YatraColors.terracotta,
                    value: _rampDefault,
                    onChanged: (val) => setState(() => _rampDefault = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: const Text('Extra Boarding Time', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Requests driver to pause doors for safe entry and seating', style: TextStyle(fontSize: 12)),
                    activeThumbColor: YatraColors.terracotta,
                    value: _extraTimeDefault,
                    onChanged: (val) => setState(() => _extraTimeDefault = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: const Text('Auditory Arrival Chimes', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Sound alert when approaching bus is within 200m', style: TextStyle(fontSize: 12)),
                    activeThumbColor: YatraColors.terracotta,
                    value: _audioChimes,
                    onChanged: (val) => setState(() => _audioChimes = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16),
                  SwitchListTile(
                    title: const Text('High-Contrast Map Markers', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                    subtitle: const Text('Enlarges route nodes and increases tactile border widths', style: TextStyle(fontSize: 12)),
                    activeThumbColor: YatraColors.terracotta,
                    value: _highContrast,
                    onChanged: (val) => setState(() => _highContrast = val),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Language Preference
            Text(
              'Preferred Interface Language',
              style: YatraTypography.sectionTitle(fontSize: 16),
            ),
            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: YatraColors.surfaceCream,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: YatraColors.softBorder),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLanguage,
                  isExpanded: true,
                  items: const [
                    DropdownMenuItem(value: 'English', child: Text('English (Default)')),
                    DropdownMenuItem(value: 'Hindi', child: Text('हिन्दी (Hindi)')),
                    DropdownMenuItem(value: 'Punjabi', child: Text('ਪੰਜਾਬੀ (Punjabi)')),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedLanguage = val);
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Emergency Contact Button
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Delhi Women & Senior Transit Helpline: 1091 / DTC Toll-Free: 1800-118-181')),
                );
              },
              icon: const Icon(Icons.emergency_outlined, color: YatraColors.errorRed),
              label: const Text('Emergency Conductor & Depot Helpline'),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
