import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController _phoneController =
      TextEditingController();

  final TextEditingController _otpController =
      TextEditingController();

  String? _verificationId;

  bool _otpSent = false;
  bool _loading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  // ============================================================
  // SEND OTP
  // ============================================================

  Future<void> _sendOtp() async {
    FocusScope.of(context).unfocus();

    String phone = _phoneController.text.trim();

    // Remove spaces and symbols
    phone = phone.replaceAll(RegExp(r'[^0-9]'), '');

    if (phone.length != 10) {
      _showMessage(
        'कृपया 10 अंकी मोबाइल नंबर टाका.',
        isError: true,
      );
      return;
    }

    if (!phone.startsWith(RegExp(r'[6-9]'))) {
      _showMessage(
        'कृपया योग्य भारतीय मोबाइल नंबर टाका.',
        isError: true,
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phone',

        // --------------------------------------------------------
        // AUTOMATIC VERIFICATION
        // --------------------------------------------------------

        verificationCompleted:
            (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);

            if (!mounted) return;

            setState(() {
              _loading = false;
            });

            _showMessage(
              'Login यशस्वी झाले. ✅',
            );

            Navigator.pop(context);
          } on FirebaseAuthException catch (e) {
            if (!mounted) return;

            setState(() {
              _loading = false;
            });

            _showFirebaseError(
              'Automatic verification failed',
              e,
            );
          } catch (e) {
            if (!mounted) return;

            setState(() {
              _loading = false;
            });

            _showMessage(
              'Login Error: $e',
              isError: true,
            );
          }
        },

        // --------------------------------------------------------
        // VERIFICATION FAILED
        // --------------------------------------------------------

        verificationFailed: (FirebaseAuthException e) {
          if (!mounted) return;

          setState(() {
            _loading = false;
          });

          _showFirebaseError(
            'OTP पाठवता आला नाही',
            e,
          );
        },

        // --------------------------------------------------------
        // CODE SENT
        // --------------------------------------------------------

        codeSent: (
          String verificationId,
          int? resendToken,
        ) {
          if (!mounted) return;

          setState(() {
            _verificationId = verificationId;
            _otpSent = true;
            _loading = false;
          });

          _showMessage(
            'OTP पाठवला आहे. 📱',
          );
        },

        // --------------------------------------------------------
        // AUTO RETRIEVAL TIMEOUT
        // --------------------------------------------------------

        codeAutoRetrievalTimeout: (
          String verificationId,
        ) {
          _verificationId = verificationId;

          if (mounted) {
            setState(() {
              _loading = false;
            });
          }
        },
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showFirebaseError(
        'Send OTP Error',
        e,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'OTP Error: $e',
        isError: true,
      );
    }
  }

  // ============================================================
  // VERIFY OTP
  // ============================================================

  Future<void> _verifyOtp() async {
    FocusScope.of(context).unfocus();

    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      _showMessage(
        'कृपया 6 अंकी OTP टाका.',
        isError: true,
      );
      return;
    }

    if (_verificationId == null) {
      _showMessage(
        'Verification ID मिळाली नाही. कृपया पुन्हा OTP मागवा.',
        isError: true,
      );
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await _auth.signInWithCredential(credential);

      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'Login यशस्वी झाले. ✅',
      );

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showFirebaseError(
        'OTP Verification Failed',
        e,
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _loading = false;
      });

      _showMessage(
        'OTP verify करता आला नाही: $e',
        isError: true,
      );
    }
  }

  // ============================================================
  // CHANGE MOBILE NUMBER
  // ============================================================

  void _changeMobileNumber() {
    setState(() {
      _otpSent = false;
      _verificationId = null;
      _otpController.clear();
      _loading = false;
    });
  }

  // ============================================================
  // FIREBASE ERROR
  // ============================================================

  void _showFirebaseError(
    String title,
    FirebaseAuthException e,
  ) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(title),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: SelectableText(
              'Error Code:\n${e.code}\n\n'
              'Message:\n${e.message ?? 'No message'}',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // MESSAGE
  // ============================================================

  void _showMessage(
    String message, {
    bool isError = false,
  }) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isError ? Colors.red : Colors.green,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text('Login / Register'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),

      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(22),
              ),

              child: Padding(
                padding: const EdgeInsets.all(24),

                child: Column(
                  children: [
                    // ------------------------------------------------
                    // ICON
                    // ------------------------------------------------

                    const Icon(
                      Icons.phone_android,
                      size: 75,
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 15),

                    // ------------------------------------------------
                    // TITLE
                    // ------------------------------------------------

                    const Text(
                      'Newasa Food Hub',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _otpSent
                          ? 'तुमच्या मोबाइलवर आलेला OTP टाका'
                          : 'मोबाइल नंबरने Login / Register करा',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ------------------------------------------------
                    // MOBILE NUMBER
                    // ------------------------------------------------

                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      enabled: !_otpSent && !_loading,

                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        hintText: '10 अंकी मोबाइल नंबर',

                        prefixText: '+91 ',

                        prefixIcon: const Icon(
                          Icons.phone,
                        ),

                        filled: true,
                        fillColor: Colors.grey.shade100,

                        counterText: '',

                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: Colors.orange,
                            width: 2,
                          ),
                        ),
                      ),
                    ),

                    // ------------------------------------------------
                    // OTP
                    // ------------------------------------------------

                    if (_otpSent) ...[
                      const SizedBox(height: 16),

                      TextField(
                        controller: _otpController,
                        keyboardType:
                            TextInputType.number,
                        maxLength: 6,
                        enabled: !_loading,

                        decoration: InputDecoration(
                          labelText: 'OTP',
                          hintText: '6 अंकी OTP',

                          prefixIcon: const Icon(
                            Icons.lock_outline,
                          ),

                          filled: true,
                          fillColor:
                              Colors.grey.shade100,

                          counterText: '',

                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),

                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                            borderSide: BorderSide(
                              color:
                                  Colors.grey.shade400,
                            ),
                          ),

                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                            borderSide:
                                const BorderSide(
                              color: Colors.orange,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 22),

                    // ------------------------------------------------
                    // MAIN BUTTON
                    // ------------------------------------------------

                    SizedBox(
                      width: double.infinity,
                      height: 54,

                      child: ElevatedButton(
                        onPressed: _loading
                            ? null
                            : (_otpSent
                                ? _verifyOtp
                                : _sendOtp),

                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.orange,
                          foregroundColor:
                              Colors.white,

                          elevation: 2,

                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),

                        child: _loading
                            ? const SizedBox(
                                width: 25,
                                height: 25,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : Text(
                                _otpSent
                                    ? 'Verify OTP'
                                    : 'Send OTP',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight:
                                      FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    // ------------------------------------------------
                    // CHANGE NUMBER
                    // ------------------------------------------------

                    if (_otpSent) ...[
                      const SizedBox(height: 12),

                      TextButton.icon(
                        onPressed: _loading
                            ? null
                            : _changeMobileNumber,

                        icon: const Icon(
                          Icons.edit,
                        ),

                        label: const Text(
                          'मोबाइल नंबर बदला',
                        ),
                      ),
                    ],

                    const SizedBox(height: 10),

                    // ------------------------------------------------
                    // INFO
                    // ------------------------------------------------

                    Text(
                      'OTP मिळण्यासाठी मोबाइल नेटवर्क आणि इंटरनेट '
                      'कनेक्शन चालू असणे आवश्यक आहे.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
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
