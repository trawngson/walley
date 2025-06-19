import 'package:dim_loading_dialog/dim_loading_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_validator/form_validator.dart';
import 'package:walley/gobal.dart';
import 'package:walley/impl/auth/register_screen.dart';
import 'package:walley/root_page.dart';
import 'package:walley/util/navigation_util.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final DimLoadingDialog loadingDialog = DimLoadingDialog(
    GlobalVariable.navState.currentState!.context,
    blur: 0,
    backgroundColor: const Color(0x33000000),
    dismissable: false,
  );

  loginSection(BuildContext context, form) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Welcome back",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w600,
          ),
        ),
        Row(
          children: [
            const Text(
              "Don't have an account?",
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            GestureDetector(
              onTap: () => NavigationUtil.navigateTo(
                const RegisterScreen(),
                context,
              ),
              child: Text(
                " Register here.",
                style: TextStyle(
                  fontSize: 14,
                  color: MediaQuery.of(context).platformBrightness ==
                          Brightness.dark
                      ? Colors.blue.shade600
                      : Colors.blue.shade800,
                ),
              ),
            ),
          ],
        ),
        Form(
          key: form,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                controller: emailController,
                autocorrect: false,
                maxLines: 1,
                validator: ValidationBuilder().email().maxLength(30).build(),
                decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordController,
                autocorrect: false,
                maxLines: 1,
                obscureText: true,
                validator: ValidationBuilder()
                    .minLength(
                      8,
                      "Your password must be at least 8 characters long",
                    )
                    .maxLength(
                      50,
                      "Your password must not exceed 50 characters.",
                    )
                    .build(),
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.all(5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Forgot password?"),
                    ElevatedButton(
                      onPressed: attemptLogIn,
                      style: ButtonStyle(
                        shape: WidgetStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            side: BorderSide(
                              color: Theme.of(context).hintColor.withAlpha(90),
                            ),
                          ),
                        ),
                      ),
                      child: const Text(
                        "Sign in",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  attemptLogIn() async {
    try {
      if (_form.currentState!.validate()) {
        loadingDialog.show();
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );

        if (mounted) {
          loadingDialog.dismiss();
          NavigationUtil.navigateToWithoutBack(const RootPage(), context);
        }
      }
    } on FirebaseAuthException catch (e) {
      String msg() {
        switch (e.code) {
          case 'wrong-password':
          case "invalid-credential":
            return 'The password you entered is incorrect. Please try again.';
          case "user-disabled": // test 123456
            return "The account you are trying to log into has been disabled.";
          case "user-not-found":
            return "This email does not belong to an account.";
          case "network-request-failed":
            return "Walley's server could not be reached. Please check your Internet connection.";
          case "too-many-requests":
            return "Please click on 'Forgot password' if you'd like to reset your password.";
          default:
            return "An internal error occurred. Please try again later.";
        }
      }

      if (mounted) {
        loadingDialog.dismiss();
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Text(msg()),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK"),
              ),
            ],
            title: Row(
              children: [
                const Icon(Icons.error_rounded),
                const SizedBox(
                  width: 15,
                ),
                e.code ==
                        "invalid-email" // Prevent leaking passwords used by other accounts
                    ? const Text("Error")
                    : e.code == "too-many-requests"
                        ? const Text("Forgot password?")
                        : Text(
                            e.code
                                .split("-")
                                .map(
                                  (e) =>
                                      e[0].toUpperCase() +
                                      (e.length > 1 ? e.substring(1) : ''),
                                )
                                .join(" "),
                          ),
              ],
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 25, right: 25),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxHeight > 500) {
                // big screen

                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 4,
                      child: GlobalVariable.image,
                    ),
                    Expanded(
                      flex: 7,
                      child: loginSection(
                        context,
                        _form,
                      ),
                    ),
                  ],
                );
              } else {
                // small screen

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 1,
                      child: GlobalVariable.textLogo,
                    ),
                    Expanded(
                      flex: 7,
                      child: loginSection(
                        context,
                        _form,
                      ),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
