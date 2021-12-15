import 'package:bloc/bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:news_app/shared/cubit/cubit.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:news_app/shared/network/local/cache.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';

import 'layout/news_layout.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CacheHelper.init();

    // bool? isDark = CacheHelper.getBoolean(key: 'isDark');

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  //   bool isDark;
  //  MyApp(this.isDark);

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      create: (BuildContext context)=>NewsCubit()..getBusiness(),
      child: BlocConsumer<NewsCubit, NewsStates>(
        listener: (BuildContext context, state) {},
        builder: (BuildContext context, Object? state) =>  MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: AppBarTheme(
              titleSpacing: 20.0,
              backwardsCompatibility: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: Colors.white,
                statusBarIconBrightness: Brightness.dark,
              ),
              backgroundColor: Colors.white,
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.deepOrange,
              elevation: 20.0,
            ),
            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ),
          darkTheme: ThemeData(
            primarySwatch: Colors.deepOrange,
            scaffoldBackgroundColor: HexColor('333739'),
            appBarTheme: AppBarTheme(
              titleSpacing: 20.0,
              backwardsCompatibility: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                statusBarColor: HexColor('333739'),
                statusBarIconBrightness: Brightness.light,
              ),
              backgroundColor: HexColor('333739'),
              elevation: 0.0,
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              titleTextStyle: TextStyle(
                color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            bottomNavigationBarTheme: BottomNavigationBarThemeData(
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.deepOrange,
              unselectedItemColor: Colors.grey,
              elevation: 20.0,
              backgroundColor: HexColor('333739'),
            ),

            textTheme: TextTheme(
              bodyText1: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
          themeMode: NewsCubit.get(context).isDark?ThemeMode.dark:ThemeMode.light,
          home: Directionality(
              textDirection: TextDirection.rtl,
              child: NewsLayout()),
        ),
      ),
    );
  }
}