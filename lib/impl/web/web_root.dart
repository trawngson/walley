import 'package:flutter/material.dart';
import 'package:motion/motion.dart';
import 'package:walley/global_variable.dart';
import 'package:walley/impl/web/web_app_bar.dart';
import 'package:walley/util/interface_util.dart';

class WebRoot extends StatelessWidget {
  const WebRoot({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: const WebAppBar(),
          backgroundColor: Colors.white,
          body: GridView.count(
            padding: InterfaceUtil.getResponsivePadding(context, offset: -30),
            crossAxisSpacing: 50,
            mainAxisSpacing: 10,
            crossAxisCount: MediaQuery.sizeOf(context).width < 900 ? 1 : 2,
            children: [
              Center(
                child: Motion(
                  shadow: const ShadowConfiguration(
                    opacity: 0,
                  ),
                  glare: GlareConfiguration.fromElevation(70),
                  child: GlobalVariable.image,
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "The ultimate financial literacy guide.",
                    style: TextStyle(
                      fontFamily: "SF Pro Display",
                      fontSize: 40,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    "Track every penny and boost your money knowledge today.",
                    style: TextStyle(
                      fontFamily: "Hedvig",
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: ElevatedButton(
                      onPressed: () => {},
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(
                          Theme.of(context).primaryColor,
                        ),
                        shape: WidgetStatePropertyAll(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                        minimumSize: const WidgetStatePropertyAll(
                          Size(150, 150),
                        ),
                      ),
                      child: Text(
                        "Get started",
                        style: TextStyle(
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          )
          // body: Center(
          //   child: SingleChildScrollView(
          //     padding: EdgeInsets.only(
          //       left: MediaQuery.of(context).size.width * 0.1,
          //       right: MediaQuery.of(context).size.width * 0.1,
          //     ),
          //     child: const Column(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Row(
          //           children: [
          //             Placeholder(),
          //             Placeholder(),
          //           ],
          //         ),
          //         SizedBox(
          //           height: 500,
          //         ),
          //         Placeholder(),
          //       ],
          //     ),
          //   ),
          // ),
          ),
    );
  }
}
