import 'package:flutter/material.dart';
import '/api/api_service.dart';
import 'my_saved.dart';
import 'profile_ui.dart';
import 'Home_page.dart';
import 'service_details.dart';

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

  final Set<int> _favoriteIds = {};

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

  Widget buildCategoryButton(String label, String categoryValue) {
    final isSelected = _selectedCategory == categoryValue;
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected
            ? Colors.blue
            : const Color.fromARGB(255, 255, 255, 255),
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset("Image/Logo.png", height: 45),
      ),
      body: Container(
        color: const Color.fromARGB(248, 255, 255, 255),

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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  buildCategoryButton('طواريء', 'EmergencyRoom'),
                  SizedBox(width: 8),
                  buildCategoryButton('عناية مركزة', 'ICU'),
                  SizedBox(width: 8),
                  buildCategoryButton('حضانة اطفال', 'NICU'),
                  SizedBox(width: 8),
                  buildCategoryButton('بنك الدم', 'BloodBank'),
                ],
              ),
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
                        final service = _services[index];
                        return ServiceCard(
                          data: service,
                          isFavorite: _favoriteIds.contains(
                            service['id'] ?? index,
                          ),
                          onFavorite: () {
                            setState(() {
                              final id = service['id'] ?? index;
                              if (_favoriteIds.contains(id)) {
                                _favoriteIds.remove(id);
                              } else {
                                _favoriteIds.add(id);
                              }
                            });
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.home, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HomePagem()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite_border, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MySavedServicesPage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.person_outline, color: Colors.blue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => PatientProfileScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}



class ServiceCard extends StatelessWidget {
  final Map<String, dynamic> data;
  final VoidCallback? onFavorite;
  final bool isFavorite;

  const ServiceCard({
    super.key,
    required this.data,
    this.onFavorite,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 255, 255, 255),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data['hospitalName'] ?? "",
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              data['name'] ?? "",
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Text(
                  "${data['price']} جنيه",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(width: 15),
                const Icon(Icons.access_time, size: 18, color: Colors.blue),
                Text(
                  data['working_Hours'] ?? "",
                  style: const TextStyle(fontSize: 14),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline, size: 18, color: Colors.blue),
                const SizedBox(width: 5),
                Expanded(
                  child: Text(
                    data['description'] ?? "",
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 13),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ServiceDetailsPage(id: data['serviceId']),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: const Text(
                  "عرض التفاصيل",
                  style: TextStyle(fontSize: 15, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
