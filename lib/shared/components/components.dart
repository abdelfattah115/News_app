import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:news_app/modules/web_view/web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

Widget defaultButton({
  Color background = Colors.blue,
  double width = double.infinity,
  bool isUppercase= true,
  required Function() function,
  required String text,
}) => Container(
  width: width,
  height: 40.0,
  child: MaterialButton(
    onPressed: function,
    child: Text(
      isUppercase ? text.toUpperCase(): text,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
  ),
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: background,
  ),
) ;

Widget defaultTextForm({
  required TextEditingController controller,
  required TextInputType type,
  //required Function validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  bool isPassword = false,
  Function()? onTap,
  Function()? suffixPressed,
  required String? validate(String? value) ,
   required Function? onChange(String? value) ,
}) => TextFormField(
  controller: controller,
  keyboardType: type,
  onTap: onTap,
  onChanged: onChange,
  obscureText: isPassword,
  validator:  validate,
  decoration: InputDecoration(
    labelText: label,
    prefixIcon: Icon(
      prefix,
    ),
    suffixIcon: suffix != null ? IconButton(
      onPressed: suffixPressed,
      icon: Icon(
        suffix,
      ),
    ) : null,
    border: OutlineInputBorder(),
  ),
);

Widget buildArticleItem(article, context) => InkWell(
  onTap: (){
    navigateTo(context, WebViewScreen(
      article['url']
    ));
  },
  child:   Padding(
    padding: const EdgeInsets.all(20.0),
    child: Row(

      children: [

        Container(

          width: 120.0,

          height: 120.0,

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10.0),

            image: DecorationImage(

              image:NetworkImage('${article['urlToImage']}'),

              fit: BoxFit.cover,

            ),

          ),

        ),

        SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Container(

            height: 120.0,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.start,

              children: [

                Expanded(

                  child: Text(

                    '${article['title']}',

                    style:Theme.of(context).textTheme.bodyText1,

                    maxLines: 3,

                    overflow: TextOverflow.ellipsis,

                  ),

                ),

                Text(

                  '${article['publishedAt']}',

                  style: TextStyle(

                    color: Colors.grey,

                  ),

                ),

              ],

            ),

          ),

        ),

      ],

    ),

  ),
);

void navigateTo(context, widget)=>Navigator.push(
    context,
    MaterialPageRoute(builder: (context)=> widget,));

Widget articleBuilder(list,context,{isSearch = false}) => ConditionalBuilder(
    condition: list.length>0 ,
    builder: (context) =>  ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: ( context, index) => buildArticleItem(list[index],context),
      separatorBuilder: ( context, index) =>  Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Container(
          height: 1.0,
          width: double.infinity,
          color: Colors.grey[300],
        ),
      ),
      itemCount: list.length,
    ),
    fallback:(context) => isSearch?Container():Center(child: CircularProgressIndicator()));