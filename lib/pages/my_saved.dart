import 'package:flutter/material.dart';
import '/api/api_my_saved.dart';
import 'profile_ui.dart';
import './Home_page.dart';

class MySavedServicesPage extends StatefulWidget {
  const MySavedServicesPage({super.key});

  @override
  State<MySavedServicesPage> createState() => _MySavedServicesPageState();
}

class _MySavedServicesPageState extends State<MySavedServicesPage> {
  final api = SavedServicesApi();
  List<dynamic> services = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() => isLoading = true);
    try {
      services = await api.getSavedServices();
    } catch (e) {
      print(e);
    }
    setState(() => isLoading = false);
  }

  Future<void> removeSaved(int serviceId) async {
    final success = await api.removeFromSaved(serviceId);
    if (success) {
      setState(() {
        services.removeWhere((s) => s["serviceId"] == serviceId);
      });

      // Use ScaffoldMessenger from the nearest Scaffold
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("The service has been removed from saved services."),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(12),
          backgroundColor: Colors.blueAccent,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to remove the service."),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(12),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Image.asset("Image/Logo.png", height: 45),
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: Colors.grey[100],
              child: services.isEmpty
                  ? const Center(child: Text("No saved services 👀"))
                  : ListView.builder(
                      padding: const EdgeInsets.only(
                        top: 20,
                        bottom: 80,
                      ), // ← top and bottom spacing

                      itemCount: services.length,
                      itemBuilder: (context, index) {
                        final item = services[index];

                        // Fallbacks for null values
                        final hospitalName = item["hospitalName"] ?? "";
                        final description = item["description"] ?? "";
                        final imageUrl =
                            item["hospitalImage"] ??
                            "https://www.aha.org/sites/default/files/2023-04/Hospital2_icon.png"; // default image
                        final price = item["price"] != null
                            ? "${item["price"]} EGP"
                            : "Price not available";
                        final availability = item["availability"] ?? "";
                        final workingHours = item["working_Hours"] ?? "";
                        final category = item["categoryName"] ?? "";

                        return Container(
                          margin: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 6,
                                offset: const Offset(0, 3),
                              ),
                            ],
                            border: const Border(
                              left: BorderSide(
                                color: Colors.blue,
                                width: 5, // ← BLUE EDGE LIKE VEZEETA
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // IMAGE
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image.network(
                                    imageUrl,
                                    width: 80,
                                    height: 80,
                                    fit: BoxFit.cover,
                                  ),
                                ),

                                const SizedBox(width: 14),

                                // CONTENT
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // TOP ROW → Title + Price at the right
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              item["name"] ?? "Unnamed Service",
                                              style: const TextStyle(
                                                fontSize: 17,
                                                fontWeight: FontWeight.w700,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),

                                          // PRICE (Top Right Vezeeta Style)
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 10,
                                              vertical: 6,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.blue.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Text(
                                              price,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      // Hospital name blue
                                      if (hospitalName.isNotEmpty)
                                        Text(
                                          hospitalName,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.blue,
                                          ),
                                        ),

                                      const SizedBox(height: 6),

                                      // Description
                                      if (description.isNotEmpty)
                                        Text(
                                          description,
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),

                                      const SizedBox(height: 10),

                                      // Availability + Hours Row
                                      Row(
                                        children: [
                                          if (availability.isNotEmpty)
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.event_available,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  availability,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),

                                          const SizedBox(width: 14),

                                          if (workingHours.isNotEmpty)
                                            Row(
                                              children: [
                                                const Icon(
                                                  Icons.access_time,
                                                  size: 16,
                                                  color: Colors.grey,
                                                ),
                                                const SizedBox(width: 4),
                                                Text(
                                                  workingHours,
                                                  style: const TextStyle(
                                                    fontSize: 13,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),

                                      const SizedBox(height: 10),

                                      // CATEGORY TAG
                                      if (category.isNotEmpty)
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 5,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(
                                              30,
                                            ),
                                          ),
                                          child: Text(
                                            category,
                                            style: const TextStyle(
                                              fontSize: 13,
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),

                                // REMOVE BUTTON (heart)
                                IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    final serviceId = item["serviceId"];
                                    if (serviceId != null) {
                                      removeSaved(serviceId);
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),

      /// --------------- NAVIGATION BAR ---------------
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
                  MaterialPageRoute(
                    builder: (_) => HomePagem(),
                  ), // your home page
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
