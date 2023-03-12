import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:driver_app/modules/income/views/income_view.dart';

import '../../home/views/home_view.dart';
import '../controllers/dashboard_page_controller.dart';

class DashboardPageView extends GetView<DashboardPageController> {
  const DashboardPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => IndexedStack(
          index: controller.tabIndex.value,

          children: const [
            HomeView(),
            IncomeView(),

          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: controller.changeTabIndex,
          currentIndex: controller.tabIndex.value,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(CupertinoIcons.home, color: Colors.green,),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.wallet, color: Colors.green,),
              label: 'Income',
            ),
          ],
        ),
      ),
    );
  }
}
