import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';
import 'auth_screen.dart';
import 'notification_listener_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ─────────────────────────────────────
  // SYSTEM UI
  // ─────────────────────────────────────

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
    ),
  );

  // ─────────────────────────────────────
  // FIREBASE
  // ─────────────────────────────────────

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 START REALTIME ADMIN LISTENERS
  NotificationListenerService.start();

  runApp(const MyApp());
}

// ─────────────────────────────────────
// APP
// ─────────────────────────────────────

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biteo Business',

      debugShowCheckedModeBanner: false,

      themeMode: ThemeMode.dark,

      darkTheme: ThemeData(
        useMaterial3: true,

        fontFamily: 'Roboto',

        brightness: Brightness.dark,

        scaffoldBackgroundColor:
            const Color(0xFF070B17),

        primaryColor:
            const Color(0xFFFF5A5F),

        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFFF5A5F),
          secondary: Color(0xFFFF8A5B),
          surface: Color(0xFF111827),
        ),

        // 🔥 PAGE TRANSITIONS FIX
        pageTransitionsTheme:
            const PageTransitionsTheme(
          builders: {
            TargetPlatform.android:
                FadeUpwardsPageTransitionsBuilder(),

            TargetPlatform.iOS:
                CupertinoPageTransitionsBuilder(),

            TargetPlatform.macOS:
                CupertinoPageTransitionsBuilder(),

            TargetPlatform.windows:
                FadeUpwardsPageTransitionsBuilder(),

            TargetPlatform.linux:
                FadeUpwardsPageTransitionsBuilder(),
          },
        ),

        // ─────────────────────────────
        // APP BAR
        // ─────────────────────────────

        appBarTheme: const AppBarTheme(
          elevation: 0,
          centerTitle: false,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          surfaceTintColor: Colors.transparent,
        ),

        // ─────────────────────────────
        // CARD
        // ─────────────────────────────

        cardTheme: CardThemeData(
          elevation: 0,
          color: Colors.white.withOpacity(0.05),
          surfaceTintColor: Colors.transparent,
          shadowColor: Colors.black.withOpacity(0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
            side: BorderSide(
              color: Colors.white.withOpacity(0.08),
            ),
          ),
        ),

        // ─────────────────────────────
        // INPUTS
        // ─────────────────────────────

        inputDecorationTheme:
            InputDecorationTheme(
          filled: true,

          fillColor:
              Colors.white.withOpacity(0.05),

          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 20,
          ),

          labelStyle: TextStyle(
            color:
                Colors.white.withOpacity(0.7),
          ),

          hintStyle: TextStyle(
            color:
                Colors.white.withOpacity(0.35),
          ),

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),

          enabledBorder:
              OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(20),
            borderSide: BorderSide(
              color:
                  Colors.white.withOpacity(0.08),
            ),
          ),

          focusedBorder:
              const OutlineInputBorder(
            borderRadius:
                BorderRadius.all(
              Radius.circular(20),
            ),
            borderSide: BorderSide(
              color: Color(0xFFFF5A5F),
              width: 1.6,
            ),
          ),
        ),

        // ─────────────────────────────
        // BUTTONS
        // ─────────────────────────────

        elevatedButtonTheme:
            ElevatedButtonThemeData(
          style:
              ElevatedButton.styleFrom(
            backgroundColor:
                const Color(0xFFFF5A5F),

            foregroundColor:
                Colors.white,

            elevation: 0,

            shadowColor: Colors.transparent,

            minimumSize:
                const Size(double.infinity, 58),

            padding:
                const EdgeInsets.symmetric(
              vertical: 18,
            ),

            shape:
                RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(20),
            ),

            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.2,
            ),
          ),
        ),

        // ─────────────────────────────
        // SWITCH
        // ─────────────────────────────

        switchTheme: SwitchThemeData(
          thumbColor:
              WidgetStateProperty.all(
            const Color(0xFFFF5A5F),
          ),

          trackColor:
              WidgetStateProperty.all(
            const Color(0x44FF5A5F),
          ),
        ),

        // ─────────────────────────────
        // SNACKBAR
        // ─────────────────────────────

        snackBarTheme: SnackBarThemeData(
          backgroundColor:
              const Color(0xFF151B2D),

          behavior:
              SnackBarBehavior.floating,

          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(18),
          ),

          contentTextStyle:
              const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),

        // ─────────────────────────────
        // SCROLLBAR
        // ─────────────────────────────

        scrollbarTheme: ScrollbarThemeData(
          thumbColor:
              WidgetStateProperty.all(
            const Color(0x66FF5A5F),
          ),

          radius: const Radius.circular(20),
        ),
      ),

      // ─────────────────────────────────
      // START SCREEN
      // ─────────────────────────────────

      home: const AuthScreen(),
    );
  }
}