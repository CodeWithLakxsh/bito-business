import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {
  bool isLoading = false;

  Future<void> signIn() async {
    try {
      setState(() {
        isLoading = true;
      });

      final googleUser =
          await GoogleSignIn().signIn();

      if (googleUser == null) {
        setState(() {
          isLoading = false;
        });
        return;
      }

      final googleAuth =
          await googleUser.authentication;

      final credential =
          GoogleAuthProvider.credential(
        accessToken:
            googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      await FirebaseAuth.instance
          .signInWithCredential(
        credential,
      );

      // ⏱️ AUTO LOGOUT AFTER 60 MIN
      Future.delayed(
        const Duration(minutes: 60),
        () {
          FirebaseAuth.instance
              .signOut();
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(
        SnackBar(
          backgroundColor:
              Colors.red,
          content: Text(
            "Login Failed: $e",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0B1020),
      body: Stack(
        children: [
          // ─────────────────────────
          // BACKGROUND GLOW
          // ─────────────────────────

          Positioned(
            top: -120,
            left: -80,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(
                  0xFFFF5A5F,
                ).withOpacity(0.25),
              ),
            ),
          ),

          Positioned(
            bottom: -140,
            right: -100,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.purple
                    .withOpacity(0.18),
              ),
            ),
          ),

          // ─────────────────────────
          // CONTENT
          // ─────────────────────────

          Center(
            child: ClipRRect(
              borderRadius:
                  BorderRadius.circular(
                32,
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 18,
                  sigmaY: 18,
                ),
                child: Container(
                  width: 430,
                  padding:
                      const EdgeInsets
                          .all(36),
                  decoration:
                      BoxDecoration(
                    color: Colors.white
                        .withOpacity(
                      0.08,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      32,
                    ),
                    border: Border.all(
                      color: Colors.white
                          .withOpacity(
                        0.08,
                      ),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withOpacity(
                          0.25,
                        ),
                        blurRadius: 40,
                        spreadRadius: 3,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      // ─────────────────
                      // LOGO
                      // ─────────────────

                      Container(
                        width: 88,
                        height: 88,
                        decoration:
                            BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(
                            24,
                          ),
                          gradient:
                              const LinearGradient(
                            colors: [
                              Color(
                                0xFFFF5A5F,
                              ),
                              Color(
                                0xFFFF7A59,
                              ),
                            ],
                          ),
                        ),
                        child: const Icon(
                          Icons.storefront_rounded,
                          color:
                              Colors.white,
                          size: 42,
                        ),
                      ),

                      const SizedBox(
                        height: 28,
                      ),

                      // ─────────────────
                      // TITLE
                      // ─────────────────

                      const Text(
                        "Biteo Business",
                        style: TextStyle(
                          color:
                              Colors.white,
                          fontSize: 34,
                          fontWeight:
                              FontWeight
                                  .w800,
                          letterSpacing:
                              -1,
                        ),
                      ),

                      const SizedBox(
                        height: 10,
                      ),

                      Text(
                        "Restaurant onboarding & management dashboard",
                        textAlign:
                            TextAlign.center,
                        style: TextStyle(
                          color: Colors
                              .white
                              .withOpacity(
                            0.7,
                          ),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),

                      const SizedBox(
                        height: 40,
                      ),

                      // ─────────────────
                      // LOGIN BUTTON
                      // ─────────────────

                      SizedBox(
                        width:
                            double.infinity,
                        height: 58,
                        child:
                            ElevatedButton(
                          onPressed:
                              isLoading
                                  ? null
                                  : signIn,
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors
                                    .white,
                            elevation: 0,
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(
                                18,
                              ),
                            ),
                          ),
                          child:
                              isLoading
                                  ? const SizedBox(
                                      width:
                                          24,
                                      height:
                                          24,
                                      child:
                                          CircularProgressIndicator(
                                        strokeWidth:
                                            2.5,
                                        color:
                                            Color(
                                          0xFFFF5A5F,
                                        ),
                                      ),
                                    )
                                  : Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width:
                                              30,
                                          height:
                                              30,
                                          decoration:
                                              BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(
                                              30,
                                            ),
                                            color:
                                                Colors.white,
                                          ),
                                          child:
                                              const Center(
                                            child:
                                                Text(
                                              "G",
                                              style:
                                                  TextStyle(
                                                fontSize:
                                                    20,
                                                fontWeight:
                                                    FontWeight.bold,
                                                color:
                                                    Colors.black,
                                              ),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width:
                                              14,
                                        ),
                                        const Text(
                                          "Continue with Google",
                                          style:
                                              TextStyle(
                                            color:
                                                Colors.black,
                                            fontSize:
                                                16,
                                            fontWeight:
                                                FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                        ),
                      ),

                      const SizedBox(
                        height: 28,
                      ),

                      // ─────────────────
                      // SECURITY TEXT
                      // ─────────────────

                      Container(
                        padding:
                            const EdgeInsets.symmetric(
                          horizontal:
                              14,
                          vertical: 12,
                        ),
                        decoration:
                            BoxDecoration(
                          color: Colors
                              .white
                              .withOpacity(
                            0.05,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            16,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons
                                  .verified_user_rounded,
                              color:
                                  Color(
                                0xFFFF5A5F,
                              ),
                              size: 22,
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Expanded(
                              child: Text(
                                "Protected admin access with secure Google authentication",
                                style:
                                    TextStyle(
                                  color: Colors
                                      .white
                                      .withOpacity(
                                    0.75,
                                  ),
                                  fontSize:
                                      13,
                                  height:
                                      1.5,
                                ),
                              ),
                            ),
                          ],
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
    );
  }
}