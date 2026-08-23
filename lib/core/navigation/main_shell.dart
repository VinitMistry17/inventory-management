import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:inventory_management/features/home/presentation/screens/home_screen.dart';
import 'package:inventory_management/features/items/presentation/providers/items_filter_provider.dart';
import 'package:inventory_management/features/items/presentation/screens/items_screen.dart';
import 'package:inventory_management/features/alerts/presentation/screens/alerts_screen.dart';
import 'package:inventory_management/features/profile/presentation/screens/profile_screen.dart';
import 'package:inventory_management/features/items/presentation/screens/add_item_screen.dart';
import 'package:inventory_management/features/scan/presentation/screens/scan_screen.dart';

class MainShell extends ConsumerStatefulWidget {
  const MainShell({super.key});

  @override
  ConsumerState<MainShell> createState() => _MainShellState();
}

class _MainShellState extends ConsumerState<MainShell> {
  int _selectedIndex = 0;

  // Scan (index 2) ko yahan include nahi kiya kyunki wo tab nahi hai, action hai
  List<Widget> get _screens => [
    HomeScreen(
      onNavigateToAlerts: () => _onTabTapped(2),
      onNavigateToItemsWithCategory: (categoryId) {
        ref.read(itemsFilterProvider.notifier).setCategory(categoryId);
        _onTabTapped(1);
      },
    ),
    const ItemsScreen(),
    const AlertsScreen(),
    const ProfileScreen(),
  ];

  final List<String> _titles = const ["Home", "Items", "Alerts", "Profile"];

  void _onTabTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  void _onScanTapped() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ScanScreen()),
    );
  }

  void _onAddPressed() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddItemScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            onPressed: _onAddPressed,
          ),
        ],
      ),
      body: IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _NavItem(
              icon: Icons.home_outlined,
              label: "Home",
              isSelected: _selectedIndex == 0,
              onTap: () => _onTabTapped(0),
            ),
            _NavItem(
              icon: Icons.inventory_2_outlined,
              label: "Items",
              isSelected: _selectedIndex == 1,
              onTap: () => _onTabTapped(1),
            ),
            const SizedBox(width: 48), // center FAB ke liye jagah
            _NavItem(
              icon: Icons.notifications_outlined,
              label: "Alerts",
              isSelected: _selectedIndex == 2,
              onTap: () => _onTabTapped(2),
            ),
            _NavItem(
              icon: Icons.person_outline,
              label: "Profile",
              isSelected: _selectedIndex == 3,
              onTap: () => _onTabTapped(3),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _onScanTapped,
        shape: const CircleBorder(),
        child: const Icon(Icons.qr_code_scanner),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.onSurfaceVariant;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 22),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: color, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
