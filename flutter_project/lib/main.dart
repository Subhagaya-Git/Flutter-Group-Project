import 'package:flutter/material.dart';
import 'registration_page.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'config/theme_config.dart';
import 'services/settings_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_animate/flutter_animate.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://mdjckakosceheneezuox.supabase.co',
    anonKey: 'sb_publishable_eZsgnC2E1LKOXqaqKPal8g_YEhRknho',
  );

  // Initialize Settings Service
  final settingsService = SettingsService();
  await settingsService.init();

  runApp(MyApp(settingsService: settingsService));
}

final supabase = Supabase.instance.client;

class MyApp extends StatefulWidget {
  final SettingsService settingsService;

  const MyApp({required this.settingsService, super.key});

  @override
  State<MyApp> createState() => _MyAppState();

  static _MyAppState? of(BuildContext context) =>
      context.findAncestorStateOfType<_MyAppState>();
}

class _MyAppState extends State<MyApp> {
  late ThemeMode _themeMode;
  late String _currencyCode;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  void _loadSettings() {
    final themeModeString = widget.settingsService.getThemeMode();
    _themeMode = _stringToThemeMode(themeModeString);
    _currencyCode = widget.settingsService.getCurrencyCode();
  }

  ThemeMode _stringToThemeMode(String mode) {
    switch (mode) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  void updateThemeMode(ThemeMode newThemeMode) {
    setState(() {
      _themeMode = newThemeMode;
    });
  }

  void updateCurrencyCode(String newCurrencyCode) {
    setState(() {
      _currencyCode = newCurrencyCode;
    });
  }

  String get currencyCode => _currencyCode;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AppleMart',
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: _themeMode,
      home: const HomePage(title: 'AppleMart'),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    colorScheme.surface,
                    colorScheme.background,
                    const Color(0xFF000000),
                  ]
                : [
                    const Color(0xFFFFFFFF),
                    const Color(0xFFF2F2F7),
                    const Color(0xFFE5ECF4),
                  ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo section
            Container(
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isDark ? colorScheme.primary : Colors.black,
                boxShadow: [
                  BoxShadow(
                    color: isDark
                        ? colorScheme.primary.withOpacity(0.3)
                        : Colors.black12,
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(
                Icons.apple,
                size: 64,
                color: isDark ? colorScheme.onPrimary : Colors.white,
              ),
            ).animate().fadeIn(duration: 800.ms).scale(begin: const Offset(0.5, 0.5), curve: Curves.easeOutBack),

            const SizedBox(height: 28),

            // App name
            Text(
              "AppleMart",
              style: GoogleFonts.montserrat(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
                color: colorScheme.onBackground,
              ),
            ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.2),

            const SizedBox(height: 10),

            // Tagline
            Text(
              "Premium Apple Products Only",
              style: GoogleFonts.inter(
                fontSize: 16,
                color: colorScheme.onBackground.withOpacity(0.7),
                letterSpacing: 0.5,
              ),
            ).animate().fadeIn(delay: 400.ms),

            const SizedBox(height: 60),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, anim, second) => const RegistrationPage(),
                    transitionsBuilder: (context, anim, second, child) {
                      return FadeTransition(opacity: anim, child: child);
                    },
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? colorScheme.primary : Colors.black,
                foregroundColor: isDark ? colorScheme.onPrimary : Colors.white,
                elevation: 12,
                shadowColor: isDark
                    ? colorScheme.primary.withOpacity(0.4)
                    : Colors.black45,
                minimumSize: const Size(260, 64),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32),
                ),
              ),
              child: Text(
                'Start Shopping',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                ),
              ),
            ).animate().fadeIn(delay: 600.ms).scale(begin: const Offset(0.9, 0.9)),
          ],
        ),
      ),
    );
  }
}
