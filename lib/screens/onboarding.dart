import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fadein/flutter_fadein.dart';
import 'package:resipros/login_signup/registration_screen.dart';
import 'package:resipros/model/onboard_model.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen>
    with TickerProviderStateMixin {
  int currentIndex = 0;

  List<OnBoardModel> screens = [
    OnBoardModel(
      imgUrl: "assets/images/onBoardingScreen/INTER PSD.png",
      title: "Hey!! Pro Interior Designer",
      description:
          "We heard you have very creative interior ideas? We can help you spread your creativity amongst people and help you get work.",
    ),
    OnBoardModel(
      imgUrl: "assets/images/onBoardingScreen/ELEC PSD.png",
      title: "Hey!! Pro Electrician",
      description:
          "Problem finding work! You can now pack your stuff and get ready for work, our platform is here to keep you busy, feeling excited!",
    ),
    OnBoardModel(
      imgUrl: "assets/images/onBoardingScreen/CONS PSD.png",
      title: "Hey!! Pro Constructor",
      description:
          "We know you are awesome, you are making people's dreams come true by helping them build their dream houses, we can help you find more such projects and continue to get the blessings.",
    ),
    OnBoardModel(
        imgUrl: "assets/images/onBoardingScreen/PLUMBER PSD.png",
        title: "Hey!! Pro Plumber",
        description:
            "Looking for work! Let us help you. You can get work just by following some simple, easy steps, near your location with good wages.")
  ];
  PageController myPageViewController = new PageController(initialPage: 0);
  final ValueNotifier<double> currentPage = ValueNotifier<double>(0.0);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xFFF4F4F4),
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        child: Stack(
          children: [
            PageView.builder(
              physics: BouncingScrollPhysics(),
              controller: myPageViewController,
              onPageChanged: (value) {
                setState(() {
                  currentIndex = value;
                  try {
                    currentPage.value = value.toDouble();
                  } catch (e) {}
                });
              },
              itemCount: screens.length,
              itemBuilder: (BuildContext context, int index) {
                return Stack(
                  children: [
                    Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            child: Image.asset(
                              screens[index].imgUrl,
                              fit: BoxFit.fill,
                            ),
                          ),
                          flex: 6,
                        ),
                        Expanded(
                          child: Container(
                            color: Color(0xFFF4F4F4),
                          ),
                          flex: 4,
                        ),
                      ],
                    ),
                    Positioned(
                        bottom: MediaQuery.of(context).size.height / 3.3,
                        child: Align(
                          child: Column(
                            children: [
                              Container(
                                child: Text(
                                  screens[index].title,
                                  style: TextStyle(
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                  textAlign: TextAlign.justify,
                                ),
                              ),
                            ],
                          ),
                          alignment: Alignment.bottomCenter,
                        ),
                        left: index != 0
                            ? MediaQuery.of(context).size.width * 0.16
                            : MediaQuery.of(context).size.width * 0.080),
                    Positioned(
                      bottom: index == 2
                          ? MediaQuery.of(context).size.height * 0.1
                          : MediaQuery.of(context).size.height * 0.15,
                      left: MediaQuery.of(context).size.width * 0.12,
                      child: Align(
                        child: Column(
                          children: [
                            SizedBox(
                              child: Text(
                                screens[index].description,
                                style: const TextStyle(
                                  fontFamily: "Roboto",
                                  color: Color(0xFF545454),
                                  fontWeight: FontWeight.normal,
                                  fontSize: 18,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                              width: 300,
                            ),
                          ],
                        ),
                        alignment: Alignment.bottomCenter,
                      ),
                    ),
                  ],
                );
              },
            ),
            Positioned(
              left: 0,
              bottom: MediaQuery.of(context).size.height / 2.65,
              child: Align(
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                      color: Color(0xFFF4F4F4),
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(120.0))),
                  width: MediaQuery.of(context).size.width,
                ),
              ),
            ),
            Positioned(
              left: MediaQuery.of(context).size.width * 0.42,
              bottom: MediaQuery.of(context).size.height * 0.4,
              child: Align(
                child: AnimatedSmoothIndicator(
                  activeIndex: currentIndex,
                  count: screens.length,
                  effect: const WormEffect(
                    type: WormType.thin,
                    dotWidth: 11.5,
                    dotHeight: 11.5,
                    spacing: 5,
                    dotColor: Color(0xFFD6D6D6),
                    activeDotColor: Color(0xFF454136),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: currentIndex != screens.length - 1 ? true : false,
              child: Positioned(
                bottom: MediaQuery.of(context).size.height / 35,
                left: MediaQuery.of(context).size.width / 2.3,
                child: Align(
                  child: currentPage != 3
                      ? Material(
                          color: Colors.transparent,
                          shape: const CircleBorder(),
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () {
                              myPageViewController.nextPage(
                                  duration: const Duration(milliseconds: 565),
                                  curve: Curves.ease);
                            },
                            child: Ink(
                              child: const Icon(
                                Icons.chevron_right,
                                size: 50,
                              ),
                            ),
                          ),
                        )
                      : const SizedBox(),
                ),
              ),
            ),
            Visibility(
              visible: currentIndex == screens.length - 1 ? true : false,
              child: Positioned(
                left: MediaQuery.of(context).size.width / 2.85,
                bottom: 30,
                child: Align(
                  child: FadeIn(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (context) => RegistrationScreen()),
                            (Route<dynamic> route) => false);
                      },
                      child: const Text("Get Started",
                          style: TextStyle(color: Color(0xFFF4F4F4))),
                      style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: const EdgeInsets.all(12.0),
                          primary: const Color(0xFF454136),
                          textStyle: const TextStyle(
                              fontFamily: "Roboto",
                              fontSize: 18,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
//TODO: Remove Navigator.pushRemove
//TODO: Add Gist
