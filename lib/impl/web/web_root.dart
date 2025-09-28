import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:motion/motion.dart';
import 'package:shimmer/shimmer.dart';
import 'package:walley/global_variable.dart';
import 'package:walley/impl/web/web_app_bar.dart';
import 'package:walley/impl/web/authentication_popup.dart';

class WebRoot extends StatelessWidget {
  const WebRoot({super.key});

  Widget _contactRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 24,
          color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.7),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontFamily: "SF Pro Display",
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context)
                      .colorScheme
                      .onSurface
                      .withValues(alpha: 0.6),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: TextStyle(
                  fontFamily: "Hedvig",
                  fontSize: 16,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 900;

    double responsiveFont(double base) {
      if (width < 600) return base * 0.6;
      if (width < 900) return base * 0.8;
      return base;
    }

    return SafeArea(
      child: Scaffold(
        appBar: const WebAppBar(),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Hero Section
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: isMobile
                      ? 20
                      : width < 1400
                          ? 80
                          : 160,
                ),
                child: Flex(
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: isMobile ? 0 : 1,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Motion(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(80)),
                          shadow: const ShadowConfiguration(
                            opacity: 0,
                            blurRadius: 500,
                          ),
                          filterQuality: FilterQuality.high,
                          child: GlobalVariable.image,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: isMobile ? 0 : 50,
                      height: isMobile ? 30 : 0,
                    ),
                    Expanded(
                      flex: isMobile ? 0 : 1,
                      child: Column(
                        crossAxisAlignment: isMobile
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              Text(
                                "The",
                                style: TextStyle(
                                  fontFamily: "SF Pro Display",
                                  fontSize: responsiveFont(40),
                                  fontWeight: FontWeight.w600,
                                  height: 1.1,
                                ),
                              ),
                              Shimmer.fromColors(
                                baseColor:
                                    Theme.of(context).colorScheme.onSurface,
                                highlightColor: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.white.withValues(alpha: 0.6)
                                    : Colors.black.withValues(alpha: 0.2),
                                period: const Duration(milliseconds: 2000),
                                child: Text(
                                  " ultimate ",
                                  style: TextStyle(
                                    fontFamily: "SF Pro Display",
                                    fontSize: responsiveFont(40),
                                    fontWeight: FontWeight.w600,
                                    height: 1.1,
                                  ),
                                ),
                              ),
                              Text(
                                "financial literacy guide.",
                                style: TextStyle(
                                  fontFamily: "SF Pro Display",
                                  fontSize: responsiveFont(40),
                                  fontWeight: FontWeight.w600,
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Track every penny and boost your money knowledge today.",
                            textAlign:
                                isMobile ? TextAlign.center : TextAlign.start,
                            style: TextStyle(
                              fontFamily: "Hedvig",
                              fontSize: responsiveFont(24),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.85),
                            ),
                          ),
                          const SizedBox(height: 40),
                          ElevatedButton(
                            onPressed: () {
                              LoginPopup.show(
                                context,
                                "Welcome to Walley",
                                "Create an account to embark on your journey with us, today",
                                false,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(255, 31, 70, 29),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              minimumSize: const Size(150, 50),
                            ),
                            child: const Text(
                              "Get started",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bee Section
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 40,
                  horizontal: isMobile
                      ? 20
                      : width < 1400
                          ? 80
                          : 160,
                ),
                child: Flex(
                  direction: isMobile ? Axis.vertical : Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: isMobile ? 0 : 1,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: isMobile
                            ? CrossAxisAlignment.center
                            : CrossAxisAlignment.start,
                        children: [
                          const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Bee-llo!",
                                style: TextStyle(
                                  fontFamily: "SF Pro Display",
                                  fontSize: 60,
                                  fontWeight: FontWeight.w600,
                                  height: 1.1,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.waving_hand_outlined, size: 50),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Meet the Ever Curious Bee, your pal. Just as bees diligently save and work together, we’ll help you build smart money habits one step at a time.",
                            textAlign:
                                isMobile ? TextAlign.center : TextAlign.start,
                            style: TextStyle(
                              fontFamily: "Hedvig",
                              fontSize: responsiveFont(24),
                              color: Theme.of(context)
                                  .colorScheme
                                  .onSurface
                                  .withValues(alpha: 0.85),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: isMobile ? 0 : 50,
                      height: isMobile ? 30 : 0,
                    ),
                    Expanded(
                      flex: isMobile ? 0 : 1,
                      child: Center(
                        child: Image.asset("assets/bee-llo.png"),
                      ),
                    ),
                  ],
                ),
              ),

              // Footer
              Container(
                width: double.infinity,
                color: Theme.of(context).brightness == Brightness.dark
                    ? Theme.of(context).colorScheme.surfaceContainerHighest
                    : const Color.fromARGB(255, 217, 217, 217),
                padding: EdgeInsets.symmetric(
                  vertical: 50,
                  horizontal: isMobile
                      ? 20
                      : width < 1400
                          ? 80
                          : 160,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Logo
                    SvgPicture.asset(
                      'assets/text_logo.svg',
                      semanticsLabel: 'Text Logo',
                      height: 150,
                    ),
                    const SizedBox(height: 40),

                    // Text + Contact fields
                    Flex(
                      direction: isMobile ? Axis.vertical : Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left: Connect With Us text
                        Expanded(
                          flex: isMobile ? 0 : 1,
                          child: Column(
                            crossAxisAlignment: isMobile
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Connect With Us!',
                                style: TextStyle(
                                  fontFamily: 'SF Pro Display',
                                  fontSize: responsiveFont(40),
                                  fontWeight: FontWeight.w600,
                                  color:
                                      Theme.of(context).colorScheme.onSurface,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ConstrainedBox(
                                constraints:
                                    const BoxConstraints(maxWidth: 500),
                                child: Text(
                                  'Take the next step toward mastering your finances. Join us and explore tools, tips, and a buzzing community focused on building better money habits.',
                                  style: TextStyle(
                                    fontFamily: 'Hedvig',
                                    fontSize: responsiveFont(22),
                                    height: 1.3,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurface
                                        .withValues(alpha: 0.85),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (!isMobile)
                          const SizedBox(
                            width: 60,
                          ), // gap between columns on desktop

                        const SizedBox(height: 50),

                        // Right: Contact Fields
                        Expanded(
                          flex: isMobile ? 0 : 1,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _contactRow(
                                context,
                                icon: Icons.facebook_outlined,
                                label: "Facebook",
                                value: "ưa lì bee fanpage (walleybee.fanpage)",
                              ),
                              const SizedBox(height: 16),
                              _contactRow(
                                context,
                                icon: Icons.email_outlined,
                                label: "Email",
                                value: "support@walley.com",
                              ),
                              const SizedBox(height: 16),
                              _contactRow(
                                context,
                                icon: Icons.phone_outlined,
                                label: "Phone",
                                value: "+84 98-765-4321",
                              ),
                              const SizedBox(height: 16),
                              _contactRow(
                                context,
                                icon: Icons.location_on_outlined,
                                label: "Address",
                                value: "69 Tran Duy Hung, Hanoi, Vietnam",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 50),
                    const Divider(),
                    const SizedBox(height: 20),

                    // Terms & Privacy
                    Row(
                      children: [
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              // NavigationUtil.navigateTo(
                              //   const TermsOfService(),
                              //   context,
                              // );
                            },
                            child: MouseRegion(
                              child: Text(
                                "Terms of service",
                                style: TextStyle(
                                  fontFamily: "Hedvig",
                                  fontSize: 16,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onSurface
                                      .withValues(alpha: 0.7),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        MouseRegion(
                          cursor: SystemMouseCursors.click,
                          child: GestureDetector(
                            onTap: () {
                              // NavigationUtil.navigateTo(
                              //   const PrivacyPolicy(),
                              //   context,
                              // );
                            },
                            child: Text(
                              "Privacy policy",
                              style: TextStyle(
                                fontFamily: "Hedvig",
                                fontSize: 16,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurface
                                    .withValues(alpha: 0.7),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
