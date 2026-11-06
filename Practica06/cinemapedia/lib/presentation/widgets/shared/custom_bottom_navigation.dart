import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:cinemapedia/config/i18n/app_strings.dart';


class CustomBottomNavigation extends StatelessWidget {

  final int currentIndex;

  const CustomBottomNavigation({
    super.key, 
    required this.currentIndex
  });

  void onItemTapped( BuildContext context, int index ) {
    // context.go('');
    switch(index) {
      case 0:
        context.go('/home/0');
        break;
      
      case 1:
        context.go('/home/1');
        break;

      case 2:
        context.go('/home/2');
        break;
    }
  }


  @override
  Widget build(BuildContext context) {

    final colors = Theme.of(context).colorScheme;
    final t = AppStrings.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (value) => onItemTapped(context, value),
      elevation: 0,
      selectedItemColor: colors.primary,
      items: [
        BottomNavigationBarItem(
          icon: const Icon( Icons.bolt_rounded ),
          activeIcon: const Icon( Icons.bolt ),
          label: t.home
        ),
        BottomNavigationBarItem(
          icon: const Icon( Icons.trending_up_rounded ),
          label: t.popular
        ),
        BottomNavigationBarItem(
          icon: const Icon( Icons.bookmark_outline_rounded ),
          activeIcon: const Icon( Icons.bookmark_rounded ),
          label: t.favorites
        ),
      ]
    );
  }
}