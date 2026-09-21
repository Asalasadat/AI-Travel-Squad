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

  // =========================
  // الألوان
  // =========================

  static const Color primaryBlue = Color(0xFF1687E8);
  static const Color darkBlue = Color(0xFF102D52);
  static const Color lightBlue = Color(0xFFEAF5FF);
  static const Color borderBlue = Color(0xFFBCD8F0);
  static const Color green = Color(0xFF48B59D);
  static const Color background = Color(0xFFF8FBFF);

  // =========================
  // المدن
  // =========================

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

  // =========================
  // أنواع الرحلات
  // =========================

  final List<String> tripTypes = [
    'ديني',
    'ثقافي',
    'مغامرة',
    'عائلي',
    'استرخاء',
    'تعليمي',
  ];

  final Set<String> selectedCities = {};
  final Set<String> selectedTripTypes = {};

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

  // =========================
  // الانتقال للنتائج
  // =========================

  Future<void> continueToResults() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (selectedCities.isEmpty) {
      _showMessage('يرجى اختيار مدينة واحدة على الأقل');
      return;
    }

    if (selectedTripTypes.isEmpty) {
      _showMessage('يرجى اختيار نوع رحلة واحد على الأقل');
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
          builder: (context) => ResultsScreen(
            cities: selectedCities.toList(),
            tripTypes: selectedTripTypes.toList(),
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

  // =========================
  // رسالة الخطأ
  // =========================

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textDirection: TextDirection.rtl,
        ),
        behavior: SnackBarBehavior.floating,
        backgroundColor: darkBlue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // =========================
  // Build
  // =========================

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: background,

        body: SafeArea(
          child: Stack(
            children: [

              // =========================
              // الزخارف الخلفية
              // =========================

              Positioned(
                top: -100,
                left: -80,
                child: Container(
                  width: 260,
                  height: 180,
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.circular(150),
                  ),
                ),
              ),

              Positioned(
                top: 40,
                right: -50,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: Color(0xFFEAF8F5),
                    shape: BoxShape.circle,
                  ),
                ),
              ),

              // =========================
              // المحتوى
              // =========================

              Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    22,
                    10,
                    22,
                    35,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [

                      // =========================
                      // Header
                      // =========================

                      Row(
                        children: [

                          // زر الرجوع
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.circular(15),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black
                                      .withOpacity(0.05),
                                  blurRadius: 10,
                                  offset:
                                      const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_forward_ios,
                                color: darkBlue,
                                size: 20,
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),

                          const Spacer(),

                          // عنوان الصفحة
                          Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.end,
                            children: const [
                              Text(
                                'التفضيلات السياحية',
                                style: TextStyle(
                                  fontSize: 30,
                                  fontWeight:
                                      FontWeight.bold,
                                  color: darkBlue,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'اختر ما يناسبك من الخيارات التالية',
                                style: TextStyle(
                                  fontSize: 16,
                                  color:
                                      Color(0xFF58708F),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // =========================
                      // المدن
                      // =========================

                      _sectionTitle(
                        icon: Icons.location_on,
                        title: 'اختر المدن',
                        color: primaryBlue,
                      ),

                      const SizedBox(height: 15),

                      _buildCities(),

                      const SizedBox(height: 30),

                      // =========================
                      // نوع الرحلة
                      // =========================

                      _sectionTitle(
                        icon: Icons.luggage,
                        title: 'نوع الرحلة',
                        color: green,
                      ),

                      const SizedBox(height: 15),

                      _buildTripTypes(),

                      const SizedBox(height: 30),

                      // =========================
                      // الميزانية
                      // =========================

                      _fieldLabel(
                        icon: Icons.location_on_outlined,
                        title: 'الميزانية الإجمالية',
                      ),

                      const SizedBox(height: 9),

                      TextFormField(
                        controller: budgetController,
                        keyboardType:
                            const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontSize: 17,
                          color: darkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'مثال: 500',
                          hintStyle: const TextStyle(
                            color: Color(0xFF8295AD),
                          ),
                          prefixText: '₪  ',
                          prefixStyle:
                              const TextStyle(
                            color: primaryBlue,
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: borderBlue,
                              width: 1.3,
                            ),
                          ),
                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: primaryBlue,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'أدخل الميزانية';
                          }

                          final budget =
                              double.tryParse(
                            value.trim(),
                          );

                          if (budget == null ||
                              budget <= 0) {
                            return 'أدخل ميزانية صحيحة';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 22),

                      // =========================
                      // عدد الأشخاص
                      // =========================

                      _fieldLabel(
                        icon: Icons.calendar_month_outlined,
                        title: 'عدد الأشخاص فوق 10 سنوات',
                      ),

                      const SizedBox(height: 9),

                      TextFormField(
                        controller: peopleController,
                        keyboardType:
                            TextInputType.number,
                        textDirection: TextDirection.ltr,
                        style: const TextStyle(
                          fontSize: 17,
                          color: darkBlue,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'مثال: 2',
                          hintStyle: const TextStyle(
                            color: Color(0xFF8295AD),
                          ),
                          suffixIcon: const Icon(
                            Icons.people_alt_outlined,
                            color: Color(0xFF7188A5),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          contentPadding:
                              const EdgeInsets.symmetric(
                            horizontal: 18,
                            vertical: 18,
                          ),
                          enabledBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: borderBlue,
                              width: 1.3,
                            ),
                          ),
                          focusedBorder:
                              OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: primaryBlue,
                              width: 2,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null ||
                              value.trim().isEmpty) {
                            return 'أدخل عدد الأشخاص';
                          }

                          final people =
                              int.tryParse(
                            value.trim(),
                          );

                          if (people == null ||
                              people <= 0) {
                            return 'أدخل عددًا صحيحًا';
                          }

                          return null;
                        },
                      ),

                      const SizedBox(height: 30),

                      // =========================
                      // زر التوصيات
                      // =========================

                      SizedBox(
                        width: double.infinity,
                        height: 62,
                        child: ElevatedButton(
                          onPressed: loading
                              ? null
                              : continueToResults,
                          style:
                              ElevatedButton.styleFrom(
                            backgroundColor:
                                primaryBlue,
                            disabledBackgroundColor:
                                const Color(0xFF9FC9ED),
                            elevation: 5,
                            shadowColor: primaryBlue
                                .withOpacity(0.3),
                            shape:
                                RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.circular(32),
                            ),
                          ),
                          child: loading
                              ? const SizedBox(
                                  width: 25,
                                  height: 25,
                                  child:
                                      CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 3,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                  children: const [

                                    Icon(
                                      Icons.auto_awesome,
                                      color: Colors.white,
                                      size: 22,
                                    ),

                                    SizedBox(width: 10),

                                    Text(
                                      'احصل على التوصيات',
                                      style: TextStyle(
                                        fontSize: 19,
                                        fontWeight:
                                            FontWeight.bold,
                                        color:
                                            Colors.white,
                                      ),
                                    ),

                                    SizedBox(width: 12),

                                    Icon(
                                      Icons
                                          .arrow_back_rounded,
                                      color: Colors.white,
                                      size: 25,
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 25),

                      // =========================
                      // Footer
                      // =========================

                      Center(
                        child: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.center,
                          children: const [

                            Icon(
                              Icons.travel_explore,
                              color: primaryBlue,
                              size: 20,
                            ),

                            SizedBox(width: 7),

                            Text(
                              'اكتشف فلسطين بطريقتك',
                              style: TextStyle(
                                color:
                                    Color(0xFF7188A5),
                                fontSize: 14,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =========================
  // عنوان القسم
  // =========================

  Widget _sectionTitle({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Row(
      children: [

        Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            color: color.withOpacity(0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 25,
          ),
        ),

        const SizedBox(width: 12),

        Text(
          title,
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: darkBlue,
          ),
        ),
      ],
    );
  }

  // =========================
  // عنوان الحقل
  // =========================

  Widget _fieldLabel({
    required IconData icon,
    required String title,
  }) {
    return Row(
      children: [

        Icon(
          icon,
          color: primaryBlue,
          size: 24,
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

  // =========================
  // المدن
  // =========================

  Widget _buildCities() {
    return Wrap(
      spacing: 9,
      runSpacing: 10,
      children: cities.map((city) {

        final bool selected =
            selectedCities.contains(city);

        return _customChip(
          text: city,
          selected: selected,
          icon: _cityIcon(city),
          onTap: () {
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

  // =========================
  // أنواع الرحلات
  // =========================

  Widget _buildTripTypes() {
    return Wrap(
      spacing: 9,
      runSpacing: 10,
      children: tripTypes.map((type) {

        final bool selected =
            selectedTripTypes.contains(type);

        return _customChip(
          text: type,
          selected: selected,
          icon: _tripIcon(type),
          onTap: () {
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

  // =========================
  // تصميم الـ Chip
  // =========================

  Widget _customChip({
    required String text,
    required bool selected,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: selected
              ? primaryBlue
              : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? primaryBlue
                : borderBlue,
            width: selected ? 1.5 : 1.2,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color:
                        primaryBlue.withOpacity(0.18),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            Icon(
              icon,
              size: 19,
              color: selected
                  ? Colors.white
                  : const Color(0xFF7188A5),
            ),

            const SizedBox(width: 7),

            Text(
              text,
              style: TextStyle(
                fontSize: 16,
                fontWeight: selected
                    ? FontWeight.bold
                    : FontWeight.w500,
                color: selected
                    ? Colors.white
                    : darkBlue,
              ),
            ),

            if (selected) ...[
              const SizedBox(width: 6),
              const Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 18,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // =========================
  // أيقونات المدن
  // =========================

  IconData _cityIcon(String city) {
    switch (city) {
      case 'القدس':
        return Icons.mosque;
      case 'بيت لحم':
        return Icons.church;
      case 'أريحا':
        return Icons.park;
      case 'نابلس':
        return Icons.location_city;
      case 'الخليل':
        return Icons.account_balance;
      case 'رام الله':
        return Icons.location_city;
      case 'جنين':
        return Icons.nature;
      case 'طوباس':
        return Icons.landscape;
      case 'طولكرم':
        return Icons.park;
      case 'قلقيلية':
        return Icons.location_city;
      default:
        return Icons.location_on;
    }
  }

  // =========================
  // أيقونات أنواع الرحلات
  // =========================

  IconData _tripIcon(String type) {
    switch (type) {
      case 'ديني':
        return Icons.mosque;
      case 'ثقافي':
        return Icons.museum;
      case 'مغامرة':
        return Icons.terrain;
      case 'عائلي':
        return Icons.groups;
      case 'استرخاء':
        return Icons.spa;
      case 'تعليمي':
        return Icons.school;
      default:
        return Icons.luggage;
    }
  }
}