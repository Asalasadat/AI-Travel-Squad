import 'package:flutter/material.dart';
import 'result_screen.dart';

class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key});

  @override
  State<PreferencesScreen> createState() =>
      _PreferencesScreenState();
}

class _PreferencesScreenState
    extends State<PreferencesScreen> {
  final _formKey = GlobalKey<FormState>();

  static const Color primaryBlue = Color(0xFF1687E8);
  static const Color darkBlue = Color(0xFF102D52);
  static const Color lightBlue = Color(0xFFEAF5FF);
  static const Color borderBlue = Color(0xFFBCD8F0);
  static const Color green = Color(0xFF48B59D);
  static const Color background = Color(0xFFF8FBFF);

  final List<String> cities = [
    'قلقيلية',
    'طوباس',
    'جنين',
    'طولكرم',
    'نابلس',
    'القدس',
    'بيت لحم',
    'أريحا',
    'الخليل',
    'رام الله',
  ];

  final List<String> tripTypes = [
    'ديني',
    'ثقافي',
    'مغامرة',
    'عائلي',
    'استرخاء',
    'تعليمي',
  ];

  final List<String> ageGroups = [
    'أطفال',
    'شباب',
    'بالغون',
    'جميع الأعمار',
  ];

  final Set<String> selectedCities = {};
  final Set<String> selectedTripTypes = {};

  String? selectedAgeGroup;

  final TextEditingController budgetController =
      TextEditingController();

  final TextEditingController peopleController =
      TextEditingController();

  bool loading = false;

  @override
  void dispose() {
    budgetController.dispose();
    peopleController.dispose();
    super.dispose();
  }

  Future<void> continueToResults() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCities.isEmpty) {
      _showMessage('يرجى اختيار مدينة واحدة على الأقل');
      return;
    }

    if (selectedTripTypes.isEmpty) {
      _showMessage('يرجى اختيار نوع رحلة واحدة على الأقل');
      return;
    }

    if (selectedAgeGroup == null) {
      _showMessage('يرجى اختيار الفئة العمرية');
      return;
    }

    final double? budget =
        double.tryParse(budgetController.text.trim());

    final int? people =
        int.tryParse(peopleController.text.trim());

    if (budget == null || budget <= 0) {
      _showMessage('أدخل ميزانية صحيحة');
      return;
    }

    if (people == null || people <= 0) {
      _showMessage(
        'أدخل عدد الأشخاص فوق 10 سنوات بشكل صحيح',
      );
      return;
    }

    setState(() {
      loading = true;
    });

    try {
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResultsScreen(
            cities: selectedCities.toList(),
            tripTypes: selectedTripTypes.toList(),
            ageGroup: selectedAgeGroup!,
            totalBudget: budget,
            peopleOver10: people,
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,
        body: SafeArea(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(22),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [Row(
  children: [
    Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(
          Icons.arrow_forward_ios,
          color: darkBlue,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    ),
    const Spacer(),
    const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          'التفضيلات السياحية',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
        SizedBox(height: 5),
        Text(
          'اختر ما يناسبك من الخيارات التالية',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ],
),

const SizedBox(height: 30),

_sectionTitle(
  icon: Icons.location_on,
  title: 'اختر المدن',
  color: primaryBlue,
),

const SizedBox(height: 15),

_buildCities(),

const SizedBox(height: 30),

_sectionTitle(
  icon: Icons.luggage,
  title: 'نوع الرحلة',
  color: green,
),

const SizedBox(height: 15),

_buildTripTypes(),

const SizedBox(height: 30),

_sectionTitle(
  icon: Icons.groups,
  title: 'الفئة العمرية',
  color: Colors.orange,
),

const SizedBox(height: 15),

DropdownButtonFormField<String>(
  value: selectedAgeGroup,
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: borderBlue,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(
        color: primaryBlue,
        width: 2,
      ),
    ),
  ),
  hint: const Text(
    'اختر الفئة العمرية',
  ),
  items: ageGroups.map((age) {
    return DropdownMenuItem(
      value: age,
      child: Text(age),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedAgeGroup = value;
    });
  },
),

const SizedBox(height: 30),

_fieldLabel(
  icon: Icons.account_balance_wallet_outlined,
  title: 'الميزانية الإجمالية',
),

const SizedBox(height: 10),

TextFormField(
  controller: budgetController,
  keyboardType: const TextInputType.numberWithOptions(
    decimal: true,
  ),
  decoration: InputDecoration(
    hintText: '500',
    prefixText: '₪ ',
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'أدخل الميزانية';
    }
    return null;
  },
),

const SizedBox(height: 25),

_fieldLabel(
  icon: Icons.people,
  title: 'عدد الأشخاص فوق 10 سنوات',
),

const SizedBox(height: 10),

TextFormField(
  controller: peopleController,
  keyboardType: TextInputType.number,
  decoration: InputDecoration(
    hintText: '2',
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
    ),
  ),
  validator: (value) {
    if (value == null || value.isEmpty) {
      return 'أدخل عدد الأشخاص';
    }
    return null;
  },
),

const SizedBox(height: 30),
SizedBox(
  width: double.infinity,
  height: 60,
  child: ElevatedButton(
    onPressed: loading ? null : continueToResults,
    style: ElevatedButton.styleFrom(
      backgroundColor: primaryBlue,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
    child: loading
        ? const CircularProgressIndicator(
            color: Colors.white,
          )
        : const Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(
                Icons.auto_awesome,
                color: Colors.white,
              ),
              SizedBox(width: 10),
              Text(
                'احصل على التوصيات',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
  ),
),

const SizedBox(height: 25),

const Center(
  child: Text(
    'Discover Palestine with AI Travel Squad',
    style: TextStyle(
      color: Colors.grey,
    ),
  ),
),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: color,
          size: 26,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _fieldLabel({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: primaryBlue,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildCities() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: cities.map((city) {
        final selected =
            selectedCities.contains(city);

        return FilterChip(
          label: Text(city),
          selected: selected,
          onSelected: (_) {
            setState(() {
              if (selected) {
                selectedCities.remove(city);
              } else {
                selectedCities.add(city);
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTripTypes() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tripTypes.map((type) {
        final selected =
            selectedTripTypes.contains(type);

        return FilterChip(
          label: Text(type),
          selected: selected,
          onSelected: (_) {
            setState(() {
              if (selected) {
                selectedTripTypes.remove(type);
              } else {
                selectedTripTypes.add(type);
              }
            });
          },
        );
      }).toList(),
    );
  }
}