import 'package:flutter/material.dart';

void main() {
  runApp(const FlexForceMarketplaceApp());
}

class FlexForceMarketplaceApp extends StatelessWidget {
  const FlexForceMarketplaceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlexForce Marketplace',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const EmployeeJobFeedScreen(),
    );
  }
}

// ==========================================
// EMPLOYEE PANEL: GEO-BASED JOBS & PERFORMANCE
// ==========================================
class EmployeeJobFeedScreen extends StatefulWidget {
  const EmployeeJobFeedScreen({super.key});

  @override
  State<EmployeeJobFeedScreen> createState() => _EmployeeJobFeedScreenState();
}

class _EmployeeJobFeedScreenState extends State<EmployeeJobFeedScreen> {
  // Worker Performance Profile Metrics
  final int totalBookedSlots = 12;
  final int totalCompletedShifts = 10;
  final int noShowCount = 2; // Slot booked but didn't join
  final double punctualityRating = 4.3;

  final List<Map<String, dynamic>> geoJobs = [
    {
      "company": "Amazon Sort Center",
      "role": "Barcode Picker",
      "location": "Bhiwandi Hub (2.5 km away)",
      "shiftHours": 8,
      "minWage": 700.0,
      "seatsLeft": 4,
    },
    {
      "company": "Blinkit Dark Store",
      "role": "Inventory Auditor",
      "location": "Thane Station (4.1 km away)",
      "shiftHours": 8,
      "minWage": 800.0,
      "seatsLeft": 2,
    },
    {
      "company": "Zepto Express Hub",
      "role": "Putaway Packer",
      "location": "Kalyan East (6.0 km away)",
      "shiftHours": 9,
      "minWage": 750.0,
      "seatsLeft": 6,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("FlexForce Job Marketplace"),
        backgroundColor: Colors.indigo.shade800,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // WORKER SCORECARD BANNER
            Container(
              margin: const EdgeInsets.all(12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigo.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.indigo.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Aapka Performance Scorecard",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricItem("Completed Shifts", "$totalCompletedShifts", Colors.green),
                      _buildMetricItem("No-Shows / Missed", "$noShowCount", Colors.red),
                      _buildMetricItem("Rating", "★ $punctualityRating", Colors.orange.shade800),
                    ],
                  ),
                  if (noShowCount > 0) ...[
                    const SizedBox(height: 8),
                    Text(
                      "⚠️ Note: Aapne $noShowCount baar slot book karke join nahi kiya. No-Show score badhne par High-Pay jobs blocked ho sakti hain.",
                      style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ]
                ],
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text("Nearby Geo-Targeted Jobs",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),

            // JOB LISTING CARDS
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: geoJobs.length,
              itemBuilder: (context, index) {
                final job = geoJobs[index];
                double minWage = job["minWage"];
                double empFee1Percent = minWage * 0.01; // 1% Wage Fee

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(job["company"], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            Chip(
                              label: Text("${job['seatsLeft']} Seats Left",
                                  style: const TextStyle(color: Colors.white, fontSize: 11)),
                              backgroundColor: Colors.red.shade700,
                              padding: EdgeInsets.zero,
                            ),
                          ],
                        ),
                        Text("Role: ${job['role']}"),
                        Text("📍 ${job['location']}", style: TextStyle(color: Colors.grey.shade700)),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Wage: ₹${minWage.toStringAsFixed(0)} / Shift",
                                style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 15)),
                            Text("Service Fee (1%): ₹${empFee1Percent.toStringAsFixed(1)}",
                                style: TextStyle(color: Colors.indigo.shade900, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo.shade800),
                            onPressed: () => _showPaymentModal(context, job, minWage, empFee1Percent),
                            child: const Text("Book Shift & Pay 1% Fee", style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricItem(String title, String val, Color col) {
    return Column(
      children: [
        Text(val, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: col)),
        Text(title, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  void _showPaymentModal(BuildContext context, Map<String, dynamic> job, double wage, double fee) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.payment, size: 40, color: Colors.indigo),
              const SizedBox(height: 10),
              Text("Confirm Slot for ${job['company']}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const Divider(),
              ListTile(
                title: const Text("Shift Minimum Wage"),
                trailing: Text("₹${wage.toStringAsFixed(0)}", style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              ListTile(
                title: const Text("Worker Platform Fee (1%)"),
                trailing: Text("₹${fee.toStringAsFixed(2)}", style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade700),
                  onPressed: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Shift Booked! ₹${fee.toStringAsFixed(2)} paid via UPI.")),
                    );
                  },
                  child: const Text("Proceed UPI Payment & Lock Seat", style: TextStyle(color: Colors.white)),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
