import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:walley/root_page.dart';

/// Unified authentication popup (sign in & register) with provider + email flows.
class LoginPopup extends StatefulWidget {
  final String title;
  final String subtitle;
  final bool isSignin; // true = sign-in mode, false = register mode (initial)
  const LoginPopup(
      {super.key,
      required this.title,
      required this.subtitle,
      required this.isSignin,});

  static Future<T?> show<T>(
      BuildContext context, String title, String subtitle, bool isSignin,) {
    return showDialog<T>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        backgroundColor: Colors.transparent,
        child: LoginPopup(title: title, subtitle: subtitle, isSignin: isSignin),
      ),
    );
  }

  @override
  State<LoginPopup> createState() => _LoginPopupState();
}

class _LoginPopupState extends State<LoginPopup> {
  final PageController _pageController = PageController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  bool _loading = false;
  String? _error;
  late bool _isSignin; // runtime mode

  @override
  void initState() {
    super.initState();
    _isSignin = widget.isSignin;
  }

  void _goToEmail() => _animateTo(1);
  void _goProviders() => _animateTo(0);
  void _animateTo(int page) => _pageController.animateToPage(page,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOutCubic,);

  Future<void> _signInWithGoogle() async {
    try {
      setState(() => _loading = true);
      final provider = GoogleAuthProvider();
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        await FirebaseAuth.instance.signInWithProvider(provider);
      }
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const RootPage()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Google sign-in failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signInWithFacebook() async {
    try {
      setState(() => _loading = true);
      final provider = FacebookAuthProvider();
      if (kIsWeb) {
        await FirebaseAuth.instance.signInWithPopup(provider);
      } else {
        await FirebaseAuth.instance.signInWithProvider(provider);
      }
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const RootPage()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = e.message ?? 'Facebook sign-in failed');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _signInWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      setState(() {
        _loading = true;
        _error = null;
      });
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email.text.trim(), password: _password.text,);
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const RootPage()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _mapEmailError(e.code));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _registerWithEmail() async {
    if (!_formKey.currentState!.validate()) return;
    try {
      setState(() {
        _loading = true;
        _error = null;
      });
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _email.text.trim(), password: _password.text,);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_email.text.trim())
          .set({'name': _name.text.trim()});
      if (mounted) {
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const RootPage()),
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() => _error = _mapRegisterError(e.code));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  String _mapEmailError(String code) {
    switch (code) {
      case 'invalid-credential':
      case 'wrong-password':
        return 'Incorrect password.';
      case 'user-disabled':
        return 'Account disabled.';
      case 'user-not-found':
        return 'No user found for that email.';
      case 'too-many-requests':
        return 'Too many attempts. Try again later.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  String _mapRegisterError(String code) {
    switch (code) {
      case 'weak-password':
        return 'Password too weak (min 8 chars).';
      case 'email-already-in-use':
        return 'Email already in use.';
      default:
        return 'Registration failed. Please try again.';
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _email.dispose();
    _password.dispose();
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    final double maxCardWidth = min(560, mq.size.width * 0.92);
    final double maxCardHeight = min(640, mq.size.height * 0.92);
    final bool veryNarrow = maxCardWidth < 380;
    final double headerSize = veryNarrow ? 24 : 30;
    final double subSize = veryNarrow ? 13 : 15;
    final EdgeInsets contentPadding = EdgeInsets.symmetric(
        horizontal: veryNarrow ? 20 : 32, vertical: veryNarrow ? 18 : 28,);

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(
            maxWidth: maxCardWidth, maxHeight: maxCardHeight, minWidth: 300,),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(28),
          child: Material(
            color: Theme.of(context).colorScheme.surface,
            elevation: 30,
            shadowColor: Colors.black26,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              padding: contentPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (c, a) =>
                            FadeTransition(opacity: a, child: c),
                        child: _pageController.hasClients &&
                                _pageController.page == 1
                            ? IconButton(
                                key: const ValueKey('back'),
                                tooltip: 'Back',
                                onPressed: _goProviders,
                                icon: const Icon(Icons.arrow_back_rounded),)
                            : const SizedBox(
                                width: 48, key: ValueKey('spacer'),),
                      ),
                      IconButton(
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(context).maybePop(),
                          icon: const Icon(Icons.close_rounded),),
                    ],
                  ),
                  if (_loading) const LinearProgressIndicator(minHeight: 2),
                  const SizedBox(height: 4),
                  Flexible(
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildProviderPage(context, headerSize, subSize),
                        _buildEmailPage(context, headerSize, subSize),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProviderPage(
      BuildContext context, double headerSize, double subSize,) {
    final title = _isSignin ? widget.title : 'Get Started';
    final subtitle =
        _isSignin ? widget.subtitle : 'Create an account to begin your journey';
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontFamily: 'SF Pro Display',
                  fontSize: headerSize,
                  fontWeight: FontWeight.w700,
                  height: 1.1,),),
          const SizedBox(height: 8),
          Text(subtitle,
              style: TextStyle(
                  fontFamily: 'Hedvig',
                  fontSize: subSize,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withOpacity(0.65),),),
          const SizedBox(height: 28),
          _AuthButton(
              label: '${_isSignin ? 'Continue' : 'Sign up'} with Google',
              icon: Icons.g_mobiledata,
              background: Colors.white,
              foreground: Colors.black87,
              border: BorderSide(color: Colors.grey.withOpacity(0.4)),
              onTap: _signInWithGoogle,),
          const SizedBox(height: 14),
          _AuthButton(
              label: '${_isSignin ? 'Continue' : 'Sign up'} with Facebook',
              icon: Icons.facebook_rounded,
              background: const Color(0xFF1877F2),
              foreground: Colors.white,
              onTap: _signInWithFacebook,),
          const SizedBox(height: 14),
          _AuthButton(
              label: '${_isSignin ? 'Continue' : 'Sign up'} with Email',
              icon: Icons.mail_outline_rounded,
              background: Theme.of(context).colorScheme.primary,
              foreground: Theme.of(context).colorScheme.onPrimary,
              onTap: _goToEmail,),
          const SizedBox(height: 20),
          Center(
            child: GestureDetector(
              onTap: _loading
                  ? null
                  : () {
                      setState(() {
                        _isSignin = !_isSignin;
                      });
                    },
              child: Text(
                _isSignin
                    ? "Don't have an account? Create one"
                    : "Already have an account? Sign in",
                style: TextStyle(
                    fontFamily: 'Hedvig',
                    fontSize: subSize - 1,
                    color: Theme.of(context).colorScheme.primary,
                    decoration: TextDecoration.underline,),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Divider(
              height: 32,
              thickness: 1,
              color: Theme.of(context).dividerColor.withOpacity(0.3),),
          Wrap(
            spacing: 4,
            runSpacing: 4,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text('By continuing you agree to our',
                  style: TextStyle(
                      fontFamily: 'Hedvig',
                      fontSize: subSize - 1,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.55),),),
              _LinkText('Terms', onTap: () {}),
              Text('and',
                  style: TextStyle(
                      fontFamily: 'Hedvig',
                      fontSize: subSize - 1,
                      color: Theme.of(context)
                          .colorScheme
                          .onSurface
                          .withOpacity(0.55),),),
              _LinkText('Privacy Policy', onTap: () {}),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmailPage(
      BuildContext context, double headerSize, double subSize,) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_isSignin ? 'Sign in with Email' : 'Create your account',
                style: TextStyle(
                    fontFamily: 'SF Pro Display',
                    fontSize: headerSize,
                    fontWeight: FontWeight.w700,
                    height: 1.1,),),
            const SizedBox(height: 8),
            Text(
                _isSignin
                    ? 'Enter your credentials to continue'
                    : 'Fill in the details below to register',
                style: TextStyle(
                    fontFamily: 'Hedvig',
                    fontSize: subSize,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withOpacity(0.65),),),
            const SizedBox(height: 24),
            if (!_isSignin) ...[
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Name required' : null,
                decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),),),
              ),
              const SizedBox(height: 16),
            ],
            TextFormField(
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              autofillHints: const [AutofillHints.email],
              validator: (v) {
                if (v == null || v.trim().isEmpty) return 'Email required';
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(v.trim())) {
                  return 'Invalid email';
                }
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),),),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _password,
              obscureText: true,
              autofillHints: const [AutofillHints.password],
              validator: (v) {
                if (v == null || v.isEmpty) return 'Password required';
                if (v.length < 8) return 'Min 8 characters';
                if (!_isSignin && v.length > 50) return 'Max 50 characters';
                return null;
              },
              decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),),),
            ),
            const SizedBox(height: 12),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(_error!,
                    style: TextStyle(
                        fontFamily: 'Hedvig',
                        fontSize: subSize - 1,
                        color: Theme.of(context).colorScheme.error,),),
              ),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _loading
                    ? null
                    : (_isSignin ? _signInWithEmail : _registerWithEmail),
                style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),),),
                child: _loading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),)
                    : Text(_isSignin ? 'Sign in' : 'Create account'),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: GestureDetector(
                onTap: _loading
                    ? null
                    : () {
                        _goProviders();
                      },
                child: Text('Other options',
                    style: TextStyle(
                        fontFamily: 'Hedvig',
                        fontSize: subSize - 1,
                        decoration: TextDecoration.underline,
                        color: Theme.of(context).colorScheme.primary,),),
              ),
            ),
            const SizedBox(height: 14),
            Center(
              child: GestureDetector(
                onTap: _loading
                    ? null
                    : () {
                        setState(() {
                          _isSignin = !_isSignin;
                        });
                      },
                child: Text(
                    _isSignin
                        ? 'Need an account? Register'
                        : 'Have an account? Sign in',
                    style: TextStyle(
                        fontFamily: 'Hedvig',
                        fontSize: subSize - 1,
                        color: Theme.of(context).colorScheme.primary,),),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AuthButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;
  final BorderSide? border;
  const _AuthButton(
      {required this.label,
      required this.icon,
      required this.background,
      required this.foreground,
      required this.onTap,
      this.border,});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(16),
            border: border == null ? null : Border.fromBorderSide(border!),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 16,
                  offset: const Offset(0, 4),),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: foreground, size: 26),
              const SizedBox(width: 12),
              Flexible(
                child: Text(label,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontFamily: 'SF Pro Display',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: foreground,),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LinkText extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const _LinkText(this.text, {required this.onTap});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(text,
          style: TextStyle(
              fontFamily: 'Hedvig',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary,
              decoration: TextDecoration.underline,),),
    );
  }
}
