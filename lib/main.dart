import 'package:flutter/material.dart';
import 'package:toi/news_screen.dart'; //Assuming you have this for RSS feed parsing
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:toi/signup_page.dart';
import 'firebase_options.dart'; //Assuming you have this file for Firebase options
import 'package:firebase_auth/firebase_auth.dart';

// Light Theme Color
const lightBgColor = Color(0xFFF5F5F5);
const lightFontColor = Color(0xFF333333);
const lightDivColor = Color(0xFFE0E0E0);
const lightPrimaryColor = Color(0xFF1E88E5);
const lightLabelColor = Color(0xFF757575);

// Dark Theme Color
const darkBgColor = Color(0xFF121212);
const darkFontColor = Color(0xFFE0E0E0);
const darkDivColor = Color(0xFF2C2C2C);
const darkPrimaryColor = Color(0xFF64B5F6);
const darkLabelColor = Color(0xFFBDBDBD);

const accentColor = Color(0xFFFF4081);
const successColor = Color(0xFF4CAF50);
const warningColor = Color(0xFFFFC107);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const SportsNewsApp());
}

class SportsNewsApp extends StatefulWidget {
  const SportsNewsApp({super.key});

  @override
  _SportsNewsAppState createState() => _SportsNewsAppState();
}

class _SportsNewsAppState extends State<SportsNewsApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _toggleTheme() {
    setState(() {
      _themeMode =
          _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sports News',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        primaryColor: lightPrimaryColor,
        scaffoldBackgroundColor: lightBgColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: lightPrimaryColor,
          foregroundColor: lightBgColor,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: Colors.white,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIconColor: lightLabelColor,
          labelStyle: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            color: lightFontColor,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 15,
            color: lightLabelColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        colorScheme: const ColorScheme.light(
          primary: lightPrimaryColor,
          secondary: accentColor,
          surface: lightBgColor,
          onSurface: lightFontColor,
          background: lightBgColor,
          onBackground: lightFontColor,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: "Poppins",
            fontSize: 28,
            color: lightFontColor,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            fontFamily: "Poppins",
            fontSize: 24,
            color: lightFontColor,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            color: lightFontColor,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            color: lightFontColor,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            color: lightFontColor,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            fontFamily: "Poppins",
            fontSize: 12,
            color: lightFontColor,
            fontWeight: FontWeight.w400,
          ),
          labelSmall: TextStyle(
            fontFamily: "Poppins",
            fontSize: 11,
            color: lightLabelColor,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        primaryColor: darkPrimaryColor,
        scaffoldBackgroundColor: darkBgColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: darkDivColor,
          foregroundColor: darkFontColor,
          elevation: 0,
        ),
        inputDecorationTheme: InputDecorationTheme(
          fillColor: darkDivColor,
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIconColor: darkLabelColor,
          labelStyle: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            color: darkFontColor,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: const TextStyle(
            fontFamily: "Poppins",
            fontSize: 15,
            color: darkLabelColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: darkPrimaryColor,
          secondary: accentColor,
          surface: darkBgColor,
          onSurface: darkFontColor,
          background: darkBgColor,
          onBackground: darkFontColor,
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(
            fontFamily: "Poppins",
            fontSize: 28,
            color: darkFontColor,
            fontWeight: FontWeight.w700,
          ),
          headlineMedium: TextStyle(
            fontFamily: "Poppins",
            fontSize: 24,
            color: darkFontColor,
            fontWeight: FontWeight.w600,
          ),
          headlineSmall: TextStyle(
            fontFamily: "Poppins",
            fontSize: 20,
            color: darkFontColor,
            fontWeight: FontWeight.w600,
          ),
          bodyLarge: TextStyle(
            fontFamily: "Poppins",
            fontSize: 16,
            color: darkFontColor,
            fontWeight: FontWeight.w500,
          ),
          bodyMedium: TextStyle(
            fontFamily: "Poppins",
            fontSize: 14,
            color: darkFontColor,
            fontWeight: FontWeight.w400,
          ),
          bodySmall: TextStyle(
            fontFamily: "Poppins",
            fontSize: 12,
            color: darkFontColor,
            fontWeight: FontWeight.w400,
          ),
          labelSmall: TextStyle(
            fontFamily: "Poppins",
            fontSize: 11,
            color: darkLabelColor,
            fontWeight: FontWeight.w300,
          ),
        ),
      ),
      themeMode: _themeMode,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data != null) {
            return MainScreen(toggleTheme: _toggleTheme);
          }
          return const SignUpPage();
        },
      ),
    );
  }
}

class MainScreen extends StatefulWidget {
  final VoidCallback toggleTheme;

  const MainScreen({super.key, required this.toggleTheme});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  List<Map<String, String?>> selectedCategories = [];

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(selectedCategories: []),
    SettingsScreen(onCategoriesSelected: (categories) {}, toggleTheme: () {}),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updateSelectedCategories(List<Map<String, String?>> categories) {
    setState(() {
      selectedCategories = categories;
    });
  }

  @override
  void initState() {
    super.initState();
    loadDefaultCategories();
  }

  void loadDefaultCategories() {
    final defaultCategories = [
      'Cricket',
      'Kabaddi',
      'Football',
      'Chess',
      'Badminton',
      'Hockey',
      'Tennis',
      'Basketball'
    ];
    selectedCategories = sportsCategories
        .where((category) => defaultCategories.contains(category['name']))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          HomeScreen(
              selectedCategories: selectedCategories.isEmpty
                  ? selectedCategories
                  : selectedCategories),
          SettingsScreen(
              onCategoriesSelected: updateSelectedCategories,
              toggleTheme: widget.toggleTheme),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        selectedFontSize: 14,
        unselectedFontSize: 12,
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  final List<Map<String, String?>> selectedCategories;

  const HomeScreen({
    super.key,
    required this.selectedCategories,
  });
  @override
  Widget build(BuildContext context) {
    final categoriesToDisplay = selectedCategories.isEmpty
        ? sportsCategories
            .where((category) => [
                  'Cricket',
                  'Kabaddi',
                  'Football',
                  'Chess',
                  'Badminton',
                  'Hockey',
                  'Tennis',
                  'Basketball'
                ].contains(category['name']))
            .toList()
        : selectedCategories;

    return DefaultTabController(
      length: categoriesToDisplay.length,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: [
              Icon(Icons.sports, size: 32, color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Color(0xFF333333)),
              SizedBox(width: 8),
              Text(
                'Sportify',
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Color(0xFF333333),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Theme.of(context).colorScheme.secondary,
            indicatorWeight: 3.0,
            labelColor: Theme.of(context).colorScheme.onPrimary,
            unselectedLabelColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
            tabs: categoriesToDisplay
                .map((category) => Tab(
                      child: Text(
                          category['name']!,
                          style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      
                    ))
                .toList(),
          ),
        ),
        body: TabBarView(
          children: categoriesToDisplay.map((category) {
            final rssUrl = category['rssUrl'] ?? '';
            return SportsCategoryContainer(
              categoryName: category['name']!,
              rssUrl: rssUrl,
            );
          }).toList(),
        ),
      ),
    );
  }
}

class SportsCategoryContainer extends StatelessWidget {
  final String categoryName;
  final String rssUrl;

  const SportsCategoryContainer({
    super.key,
    required this.categoryName,
    required this.rssUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Expanded(
            child: RssFeedScreen(
              rssUrls: [rssUrl],
            ),
          ),
        ],
      ),
    );
  }
}

class SettingsScreen extends StatefulWidget {
  final Function(List<Map<String, String?>>) onCategoriesSelected;
  final VoidCallback toggleTheme;

  const SettingsScreen({
    super.key,
    required this.onCategoriesSelected,
    required this.toggleTheme,
  });

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final Map<String, bool> selectedCategories = {
    for (var category in sportsCategories) category['name']!: false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.brightness_6,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Select Your Favorite Sports',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 3 / 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: sportsCategories.length,
              itemBuilder: (context, index) {
                final category = sportsCategories[index];
                return _buildCategoryCard(category);
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _saveCategories,
        icon: const Icon(Icons.save),
        label: const Text('Save'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
    );
  }

  Widget _buildCategoryCard(Map<String, String?> category) {
    final isSelected = selectedCategories[category['name']!] ?? false;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCategories[category['name']!] = !isSelected;
        });
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isSelected ? Theme.of(context).colorScheme.primary : Colors.transparent,
            width: 2,
          ),
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _getCategoryIcon(category['name']!),
                    size: 32,
                    color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                  ),
                  SizedBox(height: 8),
                  Text(
                    category['name']!,
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: isSelected ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            if (isSelected)
              Positioned(
                top: 8,
                right: 8,
                child: Icon(
                  Icons.check_circle,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'cricket':
        return Icons.sports_cricket;
      case 'football':
        return Icons.sports_soccer;
      case 'basketball':
        return Icons.sports_basketball;
      case 'tennis':
        return Icons.sports_tennis;
      case 'badminton':
        return Icons.sports_tennis;
      case 'hockey':
        return Icons.sports_hockey;
      case 'chess':
        return Icons.casino;
      default:
        return Icons.sports;
    }
  }

  void _saveCategories() {
    final selected = sportsCategories
        .where((category) => selectedCategories[category['name']!] == true)
        .toList();
    widget.onCategoriesSelected(selected);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Categories saved successfully!'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

// Define the sports categories with their respective RSS feed URLs
const List<Map<String, String?>> sportsCategories = [
  {
    'name': 'Archery',
    'rssUrl': 'https://sportstar.thehindu.com/archery/feeder/default.rss'
  },
  {
    'name': 'Athletics',
    'rssUrl': 'https://sportstar.thehindu.com/athletics/feeder/default.rss'
  },
  {
    'name': 'Badminton',
    'rssUrl': 'https://sportstar.thehindu.com/badminton/feeder/default.rss'
  },
  {
    'name': 'Basketball',
    'rssUrl': 'https://sportstar.thehindu.com/basketball/feeder/default.rss'
  },
  {
    'name': 'Boxing',
    'rssUrl': 'https://sportstar.thehindu.com/boxing/feeder/default.rss'
  },
  {
    'name': 'Chess',
    'rssUrl': 'https://sportstar.thehindu.com/chess/feeder/default.rss'
  },
  {
    'name': 'Cricket',
    'rssUrl': 'https://sportstar.thehindu.com/cricket/feeder/default.rss'
  },
  {
    'name': 'Cue Sport',
    'rssUrl': 'https://sportstar.thehindu.com/cue-sport/feeder/default.rss'
  },
  {
    'name': 'Esports',
    'rssUrl': 'https://sportstar.thehindu.com/esports/feeder/default.rss'
  },
  {
    'name': 'Football',
    'rssUrl': 'https://sportstar.thehindu.com/football/feeder/default.rss'
  },
  {
    'name': 'Golf',
    'rssUrl': 'https://sportstar.thehindu.com/golf/feeder/default.rss'
  },
  {
    'name': 'Hockey',
    'rssUrl': 'https://sportstar.thehindu.com/hockey/feeder/default.rss'
  },
  {
    'name': 'Kabaddi',
    'rssUrl': 'https://sportstar.thehindu.com/kabaddi/feeder/default.rss'
  },
  {
    'name': 'MMA',
    'rssUrl': 'https://sportstar.thehindu.com/mma/feeder/default.rss'
  },
  {
    'name': 'Motorsport',
    'rssUrl': 'https://sportstar.thehindu.com/motorsport/feeder/default.rss'
  },
  {
    'name': 'Shooting',
    'rssUrl': 'https://sportstar.thehindu.com/shooting/feeder/default.rss'
  },
  {
    'name': 'Squash',
    'rssUrl': 'https://sportstar.thehindu.com/squash/feeder/default.rss'
  },
  {
    'name': 'Swimming',
    'rssUrl': 'https://sportstar.thehindu.com/swimming/feeder/default.rss'
  },
  {
    'name': 'Table Tennis',
    'rssUrl': 'https://sportstar.thehindu.com/table-tennis/feeder/default.rss'
  },
  {
    'name': 'Tennis',
    'rssUrl': 'https://sportstar.thehindu.com/tennis/feeder/default.rss'
  },
  {
    'name': 'Volleyball',
    'rssUrl': 'https://sportstar.thehindu.com/volleyball/feeder/default.rss'
  },
  {
    'name': 'Wrestling',
    'rssUrl': 'https://sportstar.thehindu.com/wrestling/feeder/default.rss'
  },
];

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _picker = ImagePicker();
  String? _imagePath;
  String? _email;
  String? _bio;
  String? _name;

  final _nameController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _loadUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email;
        _name = user.displayName;
      });
    }
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _imagePath = prefs.getString('profileImage');
      _bio = prefs.getString('profileBio');
      _nameController.text = _name ?? '';
      _bioController.text = _bio ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: GestureDetector(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Welcome to your profile, ${_name ?? 'User'}!'),
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: Row(
            children: [
              Icon(Icons.person, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                'Profile',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
              
            ],
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).colorScheme.primary,
                Theme.of(context).colorScheme.secondary,
              ],
            ),
          ),
        ),
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.edit, color: Colors.white),
            onPressed: () {
              // TODO: Implement edit profile functionality
            },
          ),
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Logout'),
                    content: Text('Are you sure you want to logout?'),
                    actions: [
                      TextButton(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      TextButton(
                        child: Text('Logout'),
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const SignUpPage()),
                          );
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Theme.of(context).colorScheme.primary, Theme.of(context).colorScheme.secondary],
                ),
              ),
              child: Center(
                child: GestureDetector(
                  onTap: () async {
                    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        _imagePath = pickedFile.path;
                      });
                      _saveProfile();
                    }
                  },
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: _imagePath != null ? FileImage(File(_imagePath!)) : null,
                    child: _imagePath == null
                        ? Icon(Icons.add_a_photo, size: 60, color: Theme.of(context).colorScheme.onPrimary)
                        : null,
                    backgroundColor: Colors.white.withOpacity(0.5),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Personal Information',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      prefixIcon: Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _name = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _bioController,
                    decoration: InputDecoration(
                      labelText: 'Bio',
                      prefixIcon: Icon(Icons.info, color: Theme.of(context).colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    maxLines: 3,
                    onChanged: (value) {
                      setState(() => _bio = value);
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    initialValue: _email ?? 'No email',
                    readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email, color: Theme.of(context).colorScheme.primary),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Center(
                    child: ElevatedButton.icon(
                      icon: Icon(Icons.save),
                      label: Text('Save Profile'),
                      onPressed: _saveProfile,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onPrimary,
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImage', _imagePath ?? '');
    await prefs.setString('profileName', _name ?? '');
    await prefs.setString('profileBio', _bio ?? '');

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await user.updateDisplayName(_name);
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
