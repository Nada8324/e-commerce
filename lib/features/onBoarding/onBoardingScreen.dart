import 'package:connectx_task_shopapp/features/StartScreen/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:iconsax/iconsax.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';


class board {
  final String image;
  final String title;
  board(this.image, this.title);
}

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  var boardcontroller = PageController();

  @override
  void dispose() {
    boardcontroller.dispose();
    super.dispose();
  }

  Future<void> _finishOnBoarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alreadyRun', true);
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const SignupScreen(),),
            (route) => false);
  }
  List<board> PageViewItemsList = [
    board("assets/images/onboarding1.png", "Easy Shopping"),
    board("assets/images/onboarding2.jpg", "Secure Payment"),
    board("assets/images/onboarding3.jpg", "Quick Delivery")
  ];
  bool islast=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextButton(onPressed: (){
              _finishOnBoarding();
            }, child: Text(
              "Skip",
              style: GoogleFonts.inter(
                color: HexColor("#1D1E20"),
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          children: [
            Expanded(
              /* child: PageView(

               children: [
                BuildPageViewItem("assets/images/onboarding1.png","Easy Shopping"),
                BuildPageViewItem("assets/images/onboarding2.jpg","Secure Payment"),
                BuildPageViewItem("assets/images/onboarding3.jpeg","Quick Delivery"),
              ],
            physics:BouncingScrollPhysics(),
            controller:boardcontroller
              ),*/
              child: PageView.builder(
                  controller: boardcontroller,
                  onPageChanged: (value) {
                    if(value==PageViewItemsList.length-1)
                      {

                        setState(() {
                          islast=true;
                        });
                      }
                    else{
                      setState(() {
                        islast=false;
                      });
                    }
                  },
                  physics: const BouncingScrollPhysics(),
                  itemCount: PageViewItemsList.length,
                  itemBuilder: (context, index) =>
                      BuildPageViewItem(PageViewItemsList[index])),
            ),
            Row(
              children: [
                SmoothPageIndicator(
                  controller: boardcontroller, // PageController
                  count: 3,
                  effect: ExpandingDotsEffect(
                    dotColor: Colors.grey,
                    dotHeight: 10.h,
                    dotWidth: 10.w,
                    spacing: 5,
                      activeDotColor:  HexColor("#1D1E20")

                  ),
                ),
                const Spacer(),
                FloatingActionButton(onPressed: () {
                  if(islast){
                    _finishOnBoarding();
                    return;
                  }
                    boardcontroller.nextPage(
                      duration: const Duration(milliseconds: 750),
                      curve: Curves.fastLinearToSlowEaseIn);

                },
                  shape: const CircleBorder(),
                  backgroundColor: HexColor("#F5F6FA"),
                  child: Icon(Iconsax.arrow_right_3,color: HexColor("#1D1E20")),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget BuildPageViewItem(board model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 100.h,
        ),
        Image(image: AssetImage(model.image),width:double.infinity,height: 300.h,),
        SizedBox(
          height: 20.h,
        ),
        Text(
          model.title,
          style: GoogleFonts.inter(
            color: HexColor("#1D1E20"),
            fontSize: 28.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
      ],
    );
  }
}
