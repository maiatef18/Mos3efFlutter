import 'package:flutter/material.dart';
import 'api_service.dart';

class ServicesPage extends StatefulWidget {
  final ApiService api;

  const ServicesPage({required this.api, super.key});

  @override
  _ServicesPageState createState() => _ServicesPageState();
}

class _ServicesPageState extends State<ServicesPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _services = [];
  bool _loading = false;
  String? _selectedCategory;

  // Fetch services from API
  Future<void> fetchServices({String? keyword, String? category}) async {
    setState(() {
      _loading = true;
      _selectedCategory = category;
    });

    try {
      final result = await widget.api.searchServices(
        keyword: keyword?.trim(),
        category: category,
      );

      setState(() {
        _services = result;
      });
    } catch (e) {
      print('Error fetching services: $e');
      setState(() {
        _services = [];
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget buildServiceItem(dynamic service) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(service['name'] ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (service['averageRating'] != null)
              Text('التقييم: ${service['averageRating']}'),
            if (service['distanceKm'] != null)
              Text('المسافة: ${service['distanceKm'].toStringAsFixed(2)} كم'),
            if (service['availability'] != null)
              Text('التوافر: ${service['availability']}'),
          ],
        ),
      ),
    );
  }

  Widget buildCategoryButton(String label, String categoryValue) {
    final isSelected = _selectedCategory == categoryValue;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected ? Colors.blueAccent : Colors.grey[300],
        foregroundColor: isSelected ? Colors.white : Colors.black,
      ),
      onPressed: () {
        fetchServices(
          category: categoryValue,
          keyword: _searchController.text.isEmpty
              ? null
              : _searchController.text,
        );
      },
      child: Text(label),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('بحث عن الخدمات'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      hintText: 'ابحث عن الخدمة',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    fetchServices(
                      keyword: _searchController.text.isEmpty
                          ? null
                          : _searchController.text,
                    );
                  },
                  child: Text('بحث'),
                ),
              ],
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                buildCategoryButton('طواريء', 'EmergencyRoom'),
                buildCategoryButton('عناية مركزة', 'ICU'),
                buildCategoryButton('حضانة اطفال', 'NICU'),
                buildCategoryButton('بنك الدم', 'BloodBank'),
              ],
            ),
            SizedBox(height: 12),
            Expanded(
              child: _loading
                  ? Center(child: CircularProgressIndicator())
                  : _services.isEmpty
                  ? Center(child: Text('لا توجد خدمات'))
                  : ListView.builder(
                      itemCount: _services.length,
                      itemBuilder: (context, index) {
                        return buildServiceItem(_services[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
