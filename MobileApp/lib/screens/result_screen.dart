
import 'package:flutter/material.dart';
import 'package:travelai/models/reco.dart';
import 'package:travelai/screens/recommendation_services.dart';

class ResultsScreen extends StatefulWidget {
  final List<String> cities;
  final List<String> tripTypes;
  final double totalBudget;
  final int peopleOver10;

  const ResultsScreen({
    super.key,
    required this.cities,
    required this.tripTypes,
    required this.totalBudget,
    required this.peopleOver10, required String ageGroup,
  });

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  late Future<List<RecommendationModel>> recommendationsFuture;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  

  void _loadRecommendations() {
    recommendationsFuture =
        RecommendationService.getRecommendations(
      cities: widget.cities,
      tripTypes: widget.tripTypes,
      totalBudget: widget.totalBudget,
      peopleOver10: widget.peopleOver10, ageGroup: '',
    );
  }

 
  void retry() {
    setState(() {
      _loadRecommendations();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recommended Places',
        ),
        centerTitle: true,
      ),

      body: FutureBuilder<List<RecommendationModel>>(
        future: recommendationsFuture,

        builder: (context, snapshot) {
       
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return _buildLoadingState();
          }

       
          if (snapshot.hasError) {
            return _buildErrorState(
              snapshot.error.toString(),
            );
          }

   
          final recommendations =
              snapshot.data ?? [];

          if (recommendations.isEmpty) {
            return _buildEmptyState();
          }

          return _buildResults(
            recommendations,
          );
        },
      ),
    );
  }


  Widget _buildLoadingState() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 80),

            const SizedBox(
              width: 70,
              height: 70,
              child: CircularProgressIndicator(
                strokeWidth: 5,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'جاري الحصول على التوصيات...',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 14),

            const Text(
              'يتم الآن إرسال اختياراتك إلى نموذج الذكاء الاصطناعي وتحليلها لاختيار الأماكن المناسبة لك.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.cloud_sync,
                    color: Colors.blue.shade600,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'قد يستغرق التحليل عدة ثوانٍ',
                    style: TextStyle(
                      color: Colors.blue.shade700,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }


  Widget _buildErrorState(String error) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 45),

            Icon(
              Icons.cloud_off,
              size: 80,
              color: Colors.red.shade400,
            ),

            const SizedBox(height: 25),

            const Text(
              'تعذر الاتصال بالمودل',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'حدثت مشكلة أثناء الحصول على التوصيات. '
              'تحققي من اتصال الإنترنت ثم حاولي مرة أخرى.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.08),
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.red.withOpacity(0.2),
                ),
              ),
              child: SelectableText(
                error,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),

            const SizedBox(height: 25),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: retry,
                icon: const Icon(
                  Icons.refresh,
                ),
                label: const Text(
                  'إعادة المحاولة',
                ),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.edit,
                ),
                label: const Text(
                  'تعديل التفضيلات',
                ),
              ),
            ),

            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }


  Widget _buildResults(
    List<RecommendationModel> recommendations,
  ) {
    return Column(
      children: [
        _buildTripSummary(
          recommendations.length,
        ),

        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(
              16,
              10,
              16,
              30,
            ),
            itemCount: recommendations.length,
            itemBuilder: (context, index) {
              final place =
                  recommendations[index];

              return _buildPlaceCard(place);
            },
          ),
        ),
      ],
    );
  }


  Widget _buildTripSummary(
    int resultCount,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(
        16,
        16,
        16,
        6,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        color: Colors.blue.withOpacity(0.08),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            'ملخص رحلتك',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 12),

          _summaryRow(
            Icons.location_on,
            'المدن',
            widget.cities.join('، '),
          ),

          const SizedBox(height: 7),

          _summaryRow(
            Icons.explore,
            'نوع الرحلة',
            widget.tripTypes.join('، '),
          ),

          const SizedBox(height: 7),

          _summaryRow(
            Icons.account_balance_wallet,
            'الميزانية',
            '${widget.totalBudget.toStringAsFixed(0)} ₪',
          ),

          const SizedBox(height: 7),

          _summaryRow(
            Icons.people,
            'الأشخاص فوق 10 سنوات',
            '${widget.peopleOver10}',
          ),

          const SizedBox(height: 12),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius:
                  BorderRadius.circular(10),
            ),
            child: Text(
              'عدد الأماكن المقترحة: $resultCount',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          size: 19,
          color: Colors.blue,
        ),

        const SizedBox(width: 8),

        Expanded(
          child: Text(
            '$title: $value',
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildPlaceCard(
    RecommendationModel place,
  ) {
    double score =
        place.recommendationScore;

  
    if (score <= 1) {
      score = score * 100;
    }

    return Card(
      margin: const EdgeInsets.only(
        bottom: 16,
      ),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
   
            Row(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    place.placeName,
                    maxLines: 3,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                _buildScore(score),
              ],
            ),

            const SizedBox(height: 14),

        
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 18,
                  color: Colors.blue,
                ),

                const SizedBox(width: 6),

                Expanded(
                  child: Text(
                    place.city,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight:
                          FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

       
            Chip(
              avatar: const Icon(
                Icons.category,
                size: 17,
              ),
              label: Text(
                place.tripType,
                maxLines: 1,
                overflow:
                    TextOverflow.ellipsis,
              ),
            ),

            const SizedBox(height: 8),

           
            Text(
              place.description,
              maxLines: 5,
              overflow:
                  TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const Divider(
              height: 28,
            ),

          
            Row(
              children: [
                Expanded(
                  child: _costInfo(
                    'تكلفة الشخص',
                    '${place.estimatedCost.toStringAsFixed(0)} ₪',
                    Icons.person,
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: _costInfo(
                    'التكلفة الإجمالية',
                    '${place.totalCost.toStringAsFixed(0)} ₪',
                    Icons.payments,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

 
  Widget _buildScore(
    double score,
  ) {
    return Container(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 7,
      ),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(20),
        color:
            Colors.green.withOpacity(0.1),
      ),
      child: Text(
        '${score.toStringAsFixed(0)}%',
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }


  Widget _costInfo(
    String title,
    String value,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(12),
        color:
            Colors.grey.withOpacity(0.08),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 20,
            color: Colors.blue,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 11,
                    color:
                        Colors.grey.shade600,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildEmptyState() {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 60),

            Icon(
              Icons.location_off,
              size: 80,
              color: Colors.grey.shade500,
            ),

            const SizedBox(height: 25),

            const Text(
              'لا توجد أماكن مناسبة',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'لم يجد النظام أماكن تطابق اختياراتك والميزانية المحددة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 15),

            const Text(
              'جرّبي زيادة الميزانية أو اختيار مدينة ونوع رحلة مختلف.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
                height: 1.5,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.edit,
              ),
              label: const Text(
                'تعديل التفضيلات',
              ),
            ),

            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }
}
