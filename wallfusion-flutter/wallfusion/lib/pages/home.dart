import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:wallfusion/pages/search.dart';
// ignore: unused_import
import '../Custom_Widgets/rgb_avatar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:wallfusion/services/home_avatar_database.dart';
import 'package:wallfusion/Custom_Widgets/sliders/carousel_slider.dart';
import 'package:wallfusion/Custom_Widgets/sliders/t_phone_image_slider.dart';
//import 'package:wallfusion/Custom_Widgets/switch_bar/switch_bar.dart';
import 'package:flutter/services.dart';
import 'package:wallfusion/Custom_Widgets/sliders/posterimageslider.dart';
import 'package:wallfusion/Custom_Widgets/sliders/p_phone_image_slider.dart';
import 'package:wallfusion/Custom_Widgets/sliders/singleimageslider.dart';
import 'package:wallfusion/Custom_Widgets/sliders/gridimageshower.dart';
import 'package:wallfusion/services/notification.dart';
import 'package:wallfusion/services/notification_permission.dart';
import 'package:wallfusion/Custom_Widgets/sliders/marketing_carousel_slider.dart';
import 'package:wallfusion/Custom_Widgets/sliders/posterimageslider2.dart';

class MyHomePage extends StatefulWidget {
  final String email;
  final String title;

  // ignore: prefer_const_constructors_in_immutables
  MyHomePage({super.key, required this.title, required this.email});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();
   @override
  bool get wantKeepAlive => true; 

    @override
  void initState() {
    super.initState();
   
     NotificationPermissionService.checkNotificationPermission(context);
         _scrollController.addListener(() {
      setState(() {}); 
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
 
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop(); 
        return false; 
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(65.0),
          child: AppBar(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(18),
                  bottomLeft: Radius.circular(18)),
            ),
          leading: Padding(padding: const EdgeInsets.fromLTRB(7.0, 7.0, 3.0, 7.0),
           child: Image.asset('assets/images/logo4.png',fit: BoxFit.cover),
           ),
            title: const Text("WallFusion"),
            titleTextStyle: GoogleFonts.aboreto(
                color: isDarkMode ? Colors.white : darkcreamcolor,
                fontSize: 20,
                fontWeight: FontWeight.bold),
            actions: [
              NotificationBell(),
              IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.8,
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: const SearchPage(), 
                  ),
                ),
              );
            },
          ),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: GestureDetector(
                  onTap: () async {
                    String? selectedEmail = await showDialog(
                      context: context,
                      builder: (context) => const HomeAvatarDatabase(),
                    );
                    if (selectedEmail != null) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Selected Email: $selectedEmail')),
                      );
                    }
                  },
                  child: CircleAvatar(
                    child: Text(
                      widget.email.isNotEmpty ? widget.email[0].toUpperCase() : '?',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
        children:[
        SingleChildScrollView(
          controller: _scrollController,
          child: Column(
            children: [
              // const Padding(
              //   padding: EdgeInsets.only(top: 5.0),
              //   child: SwitchBar(),
              // ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0),
                child: CustomCarouselSlider(),
              ),
              const SizedBox(height: 20),
              const Text(
                'Welcome to WallFusion!',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              const PhoneCustomCarouselSlider(),
              const SizedBox(height: 20),
              const P_PhoneCustomCarouselSlider(),
              const Padding(
                padding: EdgeInsets.only(top: 100.0,bottom: 100.0),
                child:posterImageSlide(),
              ),
              const SizedBox(height: 20),
              Padding(padding: const EdgeInsets.only(bottom: 20.0),
              child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              const Icon(
              Icons.high_quality,
              size: 50.0,
            ),
              const SizedBox(width: 8.0), 
              Text(
              '4K Wallpapers',
              style: GoogleFonts.akshar(fontSize: 30.0),
            ),
          ],
        ),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 30.0),
              child: SingleImageSlide(jsonPath: 'assets/images/singleimageslider/slide1.json',),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 30.0),
              child: SingleImageSlide(jsonPath: 'assets/images/singleimageslider/slide2.json',),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 30.0),
              child: SingleImageSlide(jsonPath: 'assets/images/singleimageslider/slide3.json',),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 30.0),
              child: SingleImageSlide(jsonPath: 'assets/images/singleimageslider/slide4.json',),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 30.0),
              child: SingleImageSlide(jsonPath: 'assets/images/singleimageslider/slide5.json',),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 30.0),
              child: SingleImageSlide(jsonPath: 'assets/images/singleimageslider/slide6.json',),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 30.0),
              child: SingleImageSlide(jsonPath: 'assets/images/singleimageslider/slide7.json',),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 30.0),
              child: SingleImageSlide(jsonPath: 'assets/images/singleimageslider/slide8.json',),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 30.0),
              child: SingleImageSlide(jsonPath: 'assets/images/singleimageslider/slide9.json',),
              ),
              const Padding(padding: EdgeInsets.only(bottom: 30.0),
              child: SingleImageSlide(jsonPath: 'assets/images/singleimageslider/slide10.json',),
              ),
              const Padding(padding: EdgeInsets.only(top: 40,bottom: 30),
              child: GridImageShower(jsonPath: 'assets/images/grid/days_data_anime_gridimageshower.json',headerText:"Anime & Games",headerIcon: FontAwesomeIcons.eye,iconSize: 50,iconColor: Color.fromARGB(255, 237, 2, 2),height: 5320,),
              ),
              const Padding(
              padding: EdgeInsets.only(top: 30.0,bottom: 30),
              child: M_CustomCarouselSlider(),
              ),
              const Padding(padding: EdgeInsets.only(top: 40,bottom: 30),
              child: GridImageShower(jsonPath: 'assets/images/grid/days_data_marvel_gridimageshower.json',headerText:"arvel",headerIcon: FontAwesomeIcons.m,iconSize: 50,iconColor: Color.fromARGB(255, 237, 2, 2),height: 5320,),
              ),
              const Padding(padding: EdgeInsets.only(top: 40,bottom: 30),
              child: GridImageShower(jsonPath: 'assets/images/grid/days_data_dc_gridimageshower.json',headerText:"DC  Universe",headerIcon: FontAwesomeIcons.superpowers,iconSize: 50,iconColor: Color.fromARGB(255, 18, 172, 238),height: 5320,),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 100.0,bottom: 100.0),
                child:posterImageSlide2(),
              ),
              const Padding(padding: EdgeInsets.only(top: 40,bottom: 30),
              child: GridImageShower(jsonPath: 'assets/images/grid/days_data_suggestion_gridimageshower.json',headerText:"Suggestions",headerIcon: FontAwesomeIcons.accusoft,iconSize: 50,iconColor: Color.fromARGB(255, 5, 248, 134),height: 4985,),
              ),
            ],
          ),
        ),
        if (_scrollController.hasClients && _scrollController.offset > 200)
        Positioned(
          bottom: 16.0,
          left: 16.0,
          child: FloatingActionButton(
          onPressed: () {
            _scrollController.animateTo(
            0.0,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
               );
            },
            child: const Icon(Icons.arrow_upward),
          ),
        ),
      ],
    ),
    //bottomNavigationBar: const SwitchBar(),
   ),
  );
}

  static Color darkcreamcolor = Vx.gray900;
}
