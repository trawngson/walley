import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:motion/motion.dart';
import 'package:shimmer/shimmer.dart';
import 'package:walley/global_variable.dart';
import 'package:walley/impl/web/web_app_bar.dart';
import 'package:walley/util/interface_util.dart';

class WebRoot extends StatelessWidget {
  const WebRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SelectionArea(
        child: Scaffold(
          appBar: const WebAppBar(),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GridView.count(
                  padding:
                      InterfaceUtil.getResponsivePadding(context, offset: -30),
                  crossAxisSpacing: 50,
                  mainAxisSpacing: 10,
                  crossAxisCount:
                      MediaQuery.sizeOf(context).width < 900 ? 1 : 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Motion(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            80,
                          ),
                        ),
                        shadow: const ShadowConfiguration(
                          opacity: 0,
                          blurRadius: 500,
                        ),
                        filterQuality: FilterQuality.high,
                        child: GlobalVariable.image,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: [
                            const Text(
                              "The",
                              style: TextStyle(
                                fontFamily: "SF Pro Display",
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                              ),
                            ),
                            Shimmer.fromColors(
                              baseColor:
                                  Theme.of(context).colorScheme.onSurface,
                              highlightColor: Colors.grey,
                              period: const Duration(milliseconds: 2000),
                              child: const Text(
                                " ultimate ",
                                style: TextStyle(
                                  fontFamily: "SF Pro Display",
                                  fontSize: 40,
                                  fontWeight: FontWeight.w600,
                                  height: 1.1,
                                ),
                              ),
                            ),
                            const Text(
                              "financial literacy guide.",
                              style: TextStyle(
                                fontFamily: "SF Pro Display",
                                fontSize: 40,
                                fontWeight: FontWeight.w600,
                                height: 1.1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Track every penny and boost your money knowledge today.",
                          style: TextStyle(
                            fontFamily: "Hedvig",
                            fontSize: 24,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(150),
                          ),
                        ),
                        const SizedBox(height: 40),
                        Center(
                          child: ElevatedButton(
                            onPressed: () => {},
                            style: ButtonStyle(
                              backgroundColor: const WidgetStatePropertyAll(
                                Color.fromARGB(255, 31, 70, 29),
                              ),
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              minimumSize: const WidgetStatePropertyAll(
                                Size(150, 50),
                              ),
                            ),
                            child: const Text(
                              "Get started",
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Row(
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
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.waving_hand_outlined,
                              size: 50,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          "Meet the Ever Curious Bee, your pal. Just as bees diligently save and work together, we’ll help you build smart money habits one step at a time.",
                          style: TextStyle(
                            fontFamily: "Hedvig",
                            fontSize: 24,
                            color: Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withAlpha(150),
                          ),
                        ),
                      ],
                    ),
                    Center(
                      child: Image.asset("assets/bee-llo.png"),
                    ),
                  ],
                ),
                Container(
                  width: double.infinity,
                  color: const Color.fromARGB(255, 217, 217, 217),
                  padding: const EdgeInsets.only(
                    bottom: 120,
                    top: 40,
                    left: 40,
                    right: 40,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 150,
                        child: Stack(
                          children: [
                            Positioned(
                              left: 0,
                              child: SvgPicture.asset(
                                'assets/text_logo.svg',
                                semanticsLabel: 'Text Logo',
                                height: 150,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Text(
                        'Connect With Us!',
                        style: TextStyle(
                          fontFamily: 'SF Pro Display',
                          fontSize: 40,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2 - 40,
                        child: const Text(
                          'Take the next step toward mastering your finances. Join us and explore tools, tips, and a buzzing community focused on building better money habits.',
                          softWrap: true,
                          style: TextStyle(
                            fontFamily: 'Hedvig',
                            fontSize: 22,
                            height: 1.3,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 35,
                      ),
                      const Row(
                        children: [
                          Text("Terms of service"),
                          SizedBox(
                            width: 12,
                          ),
                          Text("Privacy policy"),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
