import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/calculator_controller.dart';

class CalculatorView extends StatelessWidget {
  final CalculatorController controller = Get.put(CalculatorController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Sumio'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue.shade400, Colors.white.withOpacity(0.7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.shade100.withOpacity(0.3),
              blurRadius: 24,
              offset: Offset(0, 8),
            ),
          ],
        ),
        margin: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Obx(() => Text(
                  controller.expression.value,
                  style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                )),
            Obx(() => Text(
                  controller.result.value,
                  style: TextStyle(fontSize: 24, color: Colors.blueAccent),
                )),
            SizedBox(height: 16),
            _buildButtons(context),
            SizedBox(height: 16),
            _buildMemoryButtons(),
            SizedBox(height: 16),
            _buildHistory(),
          ],
        ),
      ),
    );
  }

  Widget _buildButtons(BuildContext context) {
    final buttons = [
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['0', '.', '=', '+'],
    ];
    return Column(
      children: buttons.map((row) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: row.map((btn) {
            return _buildCalcButton(btn);
          }).toList(),
        );
      }).toList(),
    );
  }

  Widget _buildCalcButton(String value) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          if (value == '=') {
            controller.calculateResult();
          } else {
            controller.appendInput(value);
          }
        },
        child: AnimatedContainer(
          duration: Duration(milliseconds: 100),
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: value == '=' ? Colors.blueAccent : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: value == '=' ? Colors.white : Colors.blueAccent,
                shadows: [
                  Shadow(
                    color: Colors.blueAccent.withOpacity(0.5),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMemoryButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildMemButton('M+', controller.memoryAdd),
        _buildMemButton('M-', controller.memorySubtract),
        _buildMemButton('MR', controller.memoryRecall),
        _buildMemButton('MC', controller.memoryClear),
      ],
    );
  }

  Widget _buildMemButton(String label, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.blue.shade200,
        foregroundColor: Colors.white,
        elevation: 4,
      ),
      child: Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildHistory() {
    return Obx(() => Container(
          height: 80,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: controller.history
                .map((item) => Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      color: Colors.white,
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Text(item, style: TextStyle(fontSize: 16)),
                      ),
                    ))
                .toList(),
          ),
        ));
  }
}
