import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const WePackagesApp());
}

class WePackagesApp extends StatelessWidget {
  const WePackagesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'حجز باقات وي',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class Package {
  final String name;
  final String quota;
  final double price;

  Package({required this.name, required this.quota, required this.price});
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isBookingOpen = true;
  String nextBatchDate = "1 أغسطس";

  final List<Package> packages = [
    Package(name: "باقة سوبر 140 جيجا", quota: "140 جيجابايت", price: 160),
    Package(name: "باقة سوبر 200 جيجا", quota: "200 جيجابايت", price: 225),
    Package(name: "باقة مكس 250 جيجا", quota: "250 جيجابايت", price: 280),
    Package(name: "باقة ألترا 600 جيجا", quota: "600 جيجابايت", price: 650),
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('تفعيل باقات وي - Flex Zone'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: isBookingOpen ? Colors.purple.shade50 : Colors.red.shade50,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                  side: BorderSide(color: isBookingOpen ? Colors.deepPurple : Colors.red),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Icon(
                        isBookingOpen ? Icons.check_circle : Icons.cancel,
                        color: isBookingOpen ? Colors.green : Colors.red,
                        size: 36,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isBookingOpen ? "الحجز مفتوح لدفعة ($nextBatchDate)" : "الحجز مغلق حالياً",
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isBookingOpen ? "قم بتأكيد طلبك قبل إغلاق الحجز" : "سيتم فتح الحجز للدفعة القادمة قريباً",
                              style: const TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('اختر الباقة المطلوبة:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: packages.length,
                itemBuilder: (context, index) {
                  final pkg = packages[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    child: ListTile(
                      title: Text(pkg.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text("السعة: ${pkg.quota}"),
                      trailing: Text("${pkg.price} ج.م", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
                      onTap: isBookingOpen ? () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => OrderScreen(package: pkg)));
                      } : null,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrderScreen extends StatefulWidget {
  final Package package;
  const OrderScreen({super.key, required this.package});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final _phoneController = TextEditingController();
  final String walletNumber = "01000000000";

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('حجز ${widget.package.name}'),
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: 'رقم خط النت الأرضي / الموبايل',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  color: Colors.grey.shade100,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('طريقة الدفع (فودافون كاش / إنستا باي):', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAlignment.spaceBetween,
                          children: [
                            Text('حول المبلغ ($walletNumber)', style: const TextStyle(fontSize: 15)),
                            IconButton(
                              icon: const Icon(Icons.copy, color: Colors.deepPurple),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: walletNumber));
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نسخ الرقم بنجاح')));
                              },
                            )
                          ],
                        ),
                        Text('المبلغ المطلوب: ${widget.package.price} ج.م', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    if (_phoneController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('برجاء كتابة رقم الهاتف أولاً')));
                      return;
                    }
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('تم استلام طلبك بنجاح'),
                        content: const Text('سيتم مراجعة التحويل وتفعيل الباقة في موعد الدفعة المحدد.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: const Text('حسناً'),
                          )
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(50),
                  ),
                  child: const Text('تأكيد وإرسال الطلب', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
