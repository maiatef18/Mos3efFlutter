import 'api_Alaa.dart';
import 'package:flutter/material.dart';

class ServiceDetailsPage extends StatefulWidget {
  final int id;
  const ServiceDetailsPage({super.key, required this.id});

  @override
  _ServiceDetailsPageState createState() => _ServiceDetailsPageState();
}

class _ServiceDetailsPageState extends State<ServiceDetailsPage> {
  Map<String, dynamic>? service;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    service = await fetchServiceById(widget.id);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: const Text("تفاصيل الخدمة"),
          backgroundColor: const Color(0xFF89CFF0),
        ),
        body: service == null
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: service!['hospitalImage'] != null
                              ? Image.network(
                                  service!['hospitalImage'],
                                  height: 250,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  'Image/hospital.jpg',
                                  height: 250,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                ),
                        ),
                        Positioned(
                          top: 16,
                          right: 16,
                          child: IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.white,
                              size: 30,
                            ),
                            onPressed: () {
                              setState(() {
                                isFavorite = !isFavorite;
                              });
                            },
                          ),
                        ),
                        Positioned(
                          bottom: 16,
                          right: 16,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              service!['name'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.lightBlue[100]!.withOpacity(0.3),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow(
                            icon: Icons.location_city,
                            title: 'المستشفى',
                            value: service!['hospitalName'],
                          ),
                          _buildInfoRow(
                            icon: Icons.description,
                            title: 'الوصف',
                            value: service!['description'],
                          ),
                          _buildInfoRow(
                            icon: Icons.price_check,
                            title: 'السعر',
                            value: '${service!['price'] ?? ''} جنيه',
                          ),
                          _buildInfoRow(
                            icon: Icons.access_time,
                            title: 'ساعات العمل',
                            value: service!['working_Hours'],
                          ),
                          _buildInfoRow(
                            icon: Icons.calendar_today,
                            title: 'التوافر',
                            value: service!['availability'],
                          ),
                          _buildInfoRow(
                            icon: Icons.category,
                            title: 'التصنيف',
                            value: service!['categoryName'],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    String? value,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.withOpacity(0.3), width: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF89CFF0)),
          const SizedBox(width: 12),
          Expanded(
            flex: 2,
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value ?? '',
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
