import 'package:flutter/material.dart';
import 'api_my_saved.dart';

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
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Removed from saved services")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Saved Services")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : services.isEmpty
              ? const Center(child: Text("No saved services 👀"))
              : ListView.builder(
                  itemCount: services.length,
                  itemBuilder: (context, index) {
                    final item = services[index];

                    // Fallbacks for null values
                    final hospitalName = item["hospitalName"] ?? "";
                    final description = item["description"] ?? "";
                    final imageUrl = item["hospitalImage"] ??
                        "https://www.aha.org/sites/default/files/2023-04/Hospital2_icon.png"; // default image
                    final price = item["price"] != null
                        ? "${item["price"]} EGP"
                        : "Price not available";
                    final availability = item["availability"] ?? "";
                    final workingHours = item["working_Hours"] ?? "";
                    final category = item["categoryName"] ?? "";

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 3,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            imageUrl,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(item["name"] ?? "Unnamed Service",
                            style: const TextStyle(
                                fontWeight: FontWeight.bold)),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (hospitalName.isNotEmpty)
                              Text(hospitalName, style: const TextStyle(fontSize: 12)),
                            if (description.isNotEmpty)
                              Text(description, style: const TextStyle(fontSize: 12)),
                            if (price.isNotEmpty) Text(price, style: const TextStyle(fontSize: 12)),
                            if (availability.isNotEmpty) Text("Availability: $availability", style: const TextStyle(fontSize: 12)),
                            if (workingHours.isNotEmpty) Text("Hours: $workingHours", style: const TextStyle(fontSize: 12)),
                            if (category.isNotEmpty) Text("Category: $category", style: const TextStyle(fontSize: 12)),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.favorite, color: Colors.red),
                          onPressed: () {
                            removeSaved(item["serviceId"]);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
