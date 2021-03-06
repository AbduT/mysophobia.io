import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/plugins/iconx/icons_x_icons.dart';
import '../../../../core/plugins/responsive_size_util/responsive_size_util.dart';
import '../../../../injection.dart';
import '../../cubits/country/country_cubit.dart';
import '../../cubits/disease_sh/diseasesh_cubit.dart';
import '../../cubits/location/location_cubit.dart';
import '../../cubits/risk_area/risk_area_cubit.dart';
import '../../cubits/vaccine/vaccine_cubit.dart';
import '../about/about_page.dart';
import '../home/home_page.dart';
import '../statistics/statistics_page.dart';
import '../tracker/tracker_page.dart';
import 'widgets/widgets.dart';

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage>
    with AutomaticKeepAliveClientMixin<NavigationPage> {
  int selectedBarIndex = 0;
  List<BarItem> barItems;

  @override
  void initState() {
    super.initState();
  }

  void _selectAboutPage() {
    setState(() {
      selectedBarIndex = 3;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    barItems = [
      BarItem(
        text: 'Vaccines',
        icon: IconsX.health_increase,
        color: const Color(0xff192a56),
        pageWidget: BlocProvider(
          create: (_) => g<VaccineCubit>(),
          child: HomePage(
            onInfoPress: () => _selectAboutPage(),
          ),
        ),
      ),
      BarItem(
        text: 'Statistics',
        icon: IconsX.graph,
        color: const Color(0xff192a56),
        pageWidget: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => g<CountryCubit>()),
            BlocProvider(create: (_) => g<DiseaseshCubit>())
          ],
          child: StatisticPage(
            onInfoPress: () => _selectAboutPage(),
          ),
        ),
      ),
      BarItem(
        text: 'Tracker',
        icon: Icons.location_on,
        color: const Color(0xff192a56),
        pageWidget: TrackerPage(
          onInfoPress: () => _selectAboutPage(),
        ),
      ),
      BarItem(
        text: 'About',
        icon: IconsX.info,
        color: const Color(0xff192a56),
        pageWidget: const AboutPage(),
      ),
    ];
    return Scaffold(
      body: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => g<LocationCubit>()),
          BlocProvider(create: (_) => g<RiskAreaCubit>()),
          BlocProvider(create: (context) => g<VaccineCubit>()),
        ],
        child: AnimatedContainer(
          duration: const Duration(seconds: 2),
          curve: Curves.bounceIn,
          child: barItems[selectedBarIndex].pageWidget,
        ),
      ),
      bottomNavigationBar: AnimatedBottomBar(
        barItems: barItems,
        animationDuration: const Duration(milliseconds: 120),
        barStyle: BarStyle(
          fontSize: ResponsiveSizeUtil.getInstance().setSp(28),
          iconSize: 18.0,
        ),
        onBarTap: (int index) {
          setState(
            () {
              selectedBarIndex = index;
            },
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
