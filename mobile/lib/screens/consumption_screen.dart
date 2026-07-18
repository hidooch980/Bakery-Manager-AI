import 'package:flutter/material.dart';
import '../services/consumption_service.dart';

class ConsumptionScreen extends StatefulWidget {
  const ConsumptionScreen({super.key});

  @override
  State<ConsumptionScreen> createState() => _ConsumptionScreenState();
}

class _ConsumptionScreenState extends State<ConsumptionScreen> {

  final itemController = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();

  void saveConsumption() {

    ConsumptionService.add(
      item: itemController.text,
      quantity: double.tryParse(quantityController.text) ?? 0,
      unit: unitController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('مصرف مواد ثبت شد'),
      ),
    );
cd ~/projects/Bakery-Manager-AI && cat > mobile/lib/screens/consumption_screen.dart <<'EOF'
import 'package:flutter/material.dart';
import '../services/consumption_service.dart';

class ConsumptionScreen extends StatefulWidget {
  const ConsumptionScreen({super.key});

  @override
  State<ConsumptionScreen> createState() => _ConsumptionScreenState();
}

class _ConsumptionScreenState extends State<ConsumptionScreen> {

  final itemController = TextEditingController();
  final quantityController = TextEditingController();
  final unitController = TextEditingController();

  void saveConsumption() {

    ConsumptionService.add(
      item: itemController.text,
      quantity: double.tryParse(quantityController.text) ?? 0,
      unit: unitController.text,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('مصرف مواد ثبت شد'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('مصرف مواد اولیه'),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: itemController,
              decoration: const InputDecoration(
                labelText:'نام ماده',
              ),
            ),

            TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText:'مقدار مصرف',
              ),
            ),

            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText:'واحد',
              ),
            ),

            const SizedBox(height:30),

            ElevatedButton(
              onPressed: saveConsumption,
              child: const Text('ثبت مصرف'),
            )

          ],
        ),
      ),
    );
  }
}
