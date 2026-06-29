import 'package:connectx_task_shopapp/features/Cart/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/Favourite/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/Home/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/Layout/Layout_screen.dart';
import 'package:connectx_task_shopapp/features/Layout/cubit/cubit.dart';
import 'package:connectx_task_shopapp/features/onBoarding/onBoardingScreen.dart';
import 'package:connectx_task_shopapp/features/profile/cubit/cubit.dart';
import 'package:connectx_task_shopapp/firebase_options.dart';
import 'package:connectx_task_shopapp/shared/component/component.dart';
import 'package:connectx_task_shopapp/shared/network/local/cache_helper.dart';
import 'package:connectx_task_shopapp/shared/network/remote/diohelper.dart';
import 'package:connectx_task_shopapp/features/StartScreen/signup_screen.dart';
import 'package:connectx_task_shopapp/features/StartScreen/start_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Import path_provider plugin
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  DioHelper.init();

  await CacheHelper.init();
  // token=CacheHelper.getData(key: 'token');
  Widget widget;
  token = CacheHelper.getData(key: 'uId');
  print(token);
  final alreadyRun = CacheHelper.getData(key: 'alreadyRun') ?? false;
  if (token != null) {
    widget = const LayoutScreen();
  } else if (alreadyRun == true) {
    widget = const SignupScreen();
  } else {
    widget = const OnBoardingScreen();
  }
  runApp(MyApp(widget));
  // FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  final Widget startwidget;
  const MyApp(this.startwidget, {super.key});
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => Shopcubit(),
        ),
        BlocProvider(
          create: (_) {
            final cubit = HomeCubit()
              ..getHomeData()
              ..getCategories();
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = FavCubit();
            if (token != null) {
              cubit.getdata();
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = CartCubit();
            if (token != null) {
              cubit.getCart(token!);
            }
            return cubit;
          },
        ),
        BlocProvider(
          create: (_) {
            final cubit = ProfileCubit();

            if (token != null) {
              cubit.getuser();
            }

            return cubit;
          },
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(375, 812),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            useMaterial3: true,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              elevation: 0,
            ),
          ),
          home: StartScreen(startwidget),
        ),
      ),
    );
  }
}
