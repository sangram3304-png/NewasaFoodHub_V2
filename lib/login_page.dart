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

  Future<void> _sendOtp() async {
    final phone = _phoneController.text.trim();

    if (phone.length != 10) {
      _showMessage('कृपया 10 अंकी मोबाइल नंबर टाका.');
      return;
    }

    setState(() {
      _loading = true;
    });

    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: '+91$phone',

        verificationCompleted:
            (PhoneAuthCredential credential) async {
          try {
            await _auth.signInWithCredential(credential);

            if (mounted) {
              _showMessage('Login यशस्वी झाले.');
            }
          } catch (e) {
            if (mounted) {
              _showMessage('Login failed: $e');
            }
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          if (mounted) {
            setState(() {
              _loading = false;
            });

            _showMessage(
              e.message ?? 'OTP पाठवता आला नाही.',
            );
          }
        },

        codeSent: (
          String verificationId,
          int? resendToken,
        ) {
          if (mounted) {
            setState(() {
              _verificationId = verificationId;
              _otpSent = true;
              _loading = false;
            });

            _showMessage('OTP पाठवला आहे.');
          }
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;

          if (mounted) {
            setState(() {
              _loading = false;
            });
          }
        },
      );
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });

        _showMessage('काहीतरी चूक झाली.');
      }
    }
  }

  Future<void> _verifyOtp() async {
    final otp = _otpController.text.trim();

    if (otp.length != 6) {
      _showMessage('कृपया 6 अंकी OTP टाका.');
      return;
    }

    if (_verificationId == null) {
      _showMessage('कृपया पुन्हा OTP मागवा.');
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

      if (mounted) {
        setState(() {
          _loading = false;
        });

        _showMessage('Login यशस्वी झाले.');

        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });

        _showMessage(
          e.message ?? 'OTP चुकीचा आहे.',
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
        });

        _showMessage('OTP verify करता आला नाही.');
      }
    }
  }

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.phone_android,
                      size: 65,
                      color: Colors.orange,
                    ),

                    const SizedBox(height: 15),

                    const Text(
                      'Newasa Food Hub',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _otpSent
                          ? 'तुमच्या मोबाइलवर आलेला OTP टाका'
                          : 'मोबाइल नंबरने Login करा',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.grey.shade700,
                      ),
                    ),

                    const SizedBox(height: 25),

                    TextField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      enabled: !_otpSent,
                      decoration: InputDecoration(
                        labelText: 'Mobile Number',
                        hintText: '10 अंकी मोबाइल नंबर',
                        prefixText: '+91 ',
                        prefixIcon: const Icon(
                          Icons.phone,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade100,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(14),
                        ),
                      ),
                    ),

                    if (_otpSent) ...[
                      const SizedBox(height: 10),

                      TextField(
                        controller: _otpController,
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                        decoration: InputDecoration(
                          labelText: 'OTP',
                          hintText: '6 अंकी OTP',
                          prefixIcon: const Icon(
                            Icons.lock,
                          ),
                          filled: true,
                          fillColor: Colors.grey.shade100,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 15),

                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: _loading
                            ? null
                            : (_otpSent
                                ? _verifyOtp
                                : _sendOtp),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                          ),
                        ),
                        child: _loading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child:
                                    CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                            : Text(
                                _otpSent
                                    ? 'Verify OTP'
                                    : 'Send OTP',
                                style: const TextStyle(
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                    ),

                    if (_otpSent) ...[
                      const SizedBox(height: 12),

                      TextButton(
                        onPressed: _loading
                            ? null
                            : () {
                                setState(() {
                                  _otpSent = false;
                                  _verificationId = null;
                                  _otpController.clear();
                                });
                              },
                        child: const Text(
                          'मोबाइल नंबर बदला',
                        ),
                      ),
                    ],
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
