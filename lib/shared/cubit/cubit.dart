
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/modules/business/business_screen.dart';
import 'package:news_app/modules/science/science_screen.dart';
import 'package:news_app/modules/sports/sports_screen.dart';
import 'package:news_app/shared/cubit/states.dart';
import 'package:news_app/shared/network/local/cache.dart';
import 'package:news_app/shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>{

  List<Widget> screens = [
    BusinessScreen(),
    SportsScreen(),
    ScienceScreen(),
  ];

  NewsCubit() : super(NewsInitialStates());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<BottomNavigationBarItem> bottomItems = [
    BottomNavigationBarItem(
      icon: Icon(
        Icons.business
      ),
      label: 'Business'
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.sports
      ),
      label: 'Sports'
    ),
    BottomNavigationBarItem(
      icon: Icon(
        Icons.science
      ),
      label: 'Science'
    ),
  ];

  void changeBottomNavItem(index){
    currentIndex = index;
    if(index==1){
      getSports();
    }
    if(index==2){
      getScience();
    }

    emit(NewsBottomNavStates());
  }

  List<dynamic> business = [];

  void getBusiness(){
    emit(NewsGetBusinessLoadingStates());
    DioHelper.getData(
        url: 'v2/top-headlines',
        query:
        {
          'country':'eg',
          'category':'business',
          'apiKey':'b18eea0a3b3f4b60a8027ac0cbf15d1a',
        }
    ).then((value) {
      business = value.data['articles'];
      //print(business[0]['title']);
      emit(NewsGetBusinessSuccessStates());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetBusinessErrorStates(error.toString()));
    });
  }

  List<dynamic> sports = [];

  void getSports(){
    emit(NewsGetSportsLoadingStates());
    if(sports.length == 0)
    {
      DioHelper.getData(
          url: 'v2/top-headlines',
          query:
          {
            'country':'eg',
            'category':'sports',
            'apiKey':'b18eea0a3b3f4b60a8027ac0cbf15d1a',
          }
      ).then((value) {
        sports = value.data['articles'];
        //print(business[0]['title']);
        emit(NewsGetSportsSuccessStates());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetSportsErrorStates(error.toString()));
      });
    }else{
      emit(NewsGetSportsSuccessStates());
    }
  }

  List<dynamic> science = [];

  void getScience(){
    emit(NewsGetScienceLoadingStates());
    if(science.length == 0)
    {
      DioHelper.getData(
          url: 'v2/top-headlines',
          query:
          {
            'country':'eg',
            'category':'science',
            'apiKey':'b18eea0a3b3f4b60a8027ac0cbf15d1a',
          }
      ).then((value) {
        science = value.data['articles'];
        //print(business[0]['title']);
        emit(NewsGetScienceSuccessStates());
      }).catchError((error){
        print(error.toString());
        emit(NewsGetScienceErrorStates(error.toString()));
      });
    }else
      {
        emit(NewsGetScienceSuccessStates());
      }
  }

  List<dynamic> search = [];

  void getSearch(String value){
    emit(NewsGetSearchLoadingStates());
    search = [];
    DioHelper.getData(
        url: 'v2/everything',
        query:
        {
          'q':'$value',
          'apiKey':'b18eea0a3b3f4b60a8027ac0cbf15d1a',
        }
    ).then((value) {
      search = value.data['articles'];
      //print(business[0]['title']);
      emit(NewsGetSearchSuccessStates());
    }).catchError((error){
      print(error.toString());
      emit(NewsGetSearchErrorStates(error.toString()));
    });
  }

  bool isDark = false;
  void changeMode({bool? fromShared}){
    if(fromShared != null){
      isDark = fromShared;
      emit(NewsChangeModeStates());
    }else
      {
        isDark = !isDark;
        CacheHelper.putBoolean(key: 'isDark', value: isDark).then((value)
        {
          emit(NewsChangeModeStates());
        } );
    }
  }
}