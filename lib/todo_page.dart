import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:fl_chart/fl_chart.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  Box? inventoryBox;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    inventoryBox = Hive.box('todoBox');
  }

  void _addInventoryItem(String name, int quantity, double price) {
    final newItem = {
      'name': name,
      'quantity': quantity,
      'price': price,
    };
    setState(() {
      inventoryBox?.add(newItem);
    });
  }

  List<BarChartGroupData> _generateChartData() {
    final data = <BarChartGroupData>[];
    for (int i = 0; i < inventoryBox!.length; i++) {
      final item = inventoryBox!.getAt(i);
      data.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              fromY: item['quantity'].toDouble(),
              color: Colors.blue,
              width: 20,
              toY: BorderSide.strokeAlignCenter,
            ),
          ],
        ),
      );
    }
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Control de Inventario'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del Artículo',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _quantityController,
              decoration: const InputDecoration(
                labelText: 'Cantidad',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _priceController,
              decoration: const InputDecoration(
                labelText: 'Precio',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              if (_nameController.text.isNotEmpty &&
                  _quantityController.text.isNotEmpty &&
                  _priceController.text.isNotEmpty) {
                _addInventoryItem(
                  _nameController.text,
                  int.parse(_quantityController.text),
                  double.parse(_priceController.text),
                );
                _nameController.clear();
                _quantityController.clear();
                _priceController.clear();
              }
            },
            child: const Text('Agregar Artículo'),
          ),
          const SizedBox(height: 16),
          const Text(
            'Gráfica de Inventario',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: inventoryBox != null && inventoryBox!.isNotEmpty
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: BarChart(
                      BarChartData(
                        barGroups: _generateChartData(),
                        titlesData: FlTitlesData(
                          leftTitles: const AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 30,
                            ),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (double value, TitleMeta meta) {
                                // Asegúrate de verificar que el índice no esté fuera de rango
                                if (value.toInt() < inventoryBox!.length) {
                                  final item =
                                      inventoryBox!.getAt(value.toInt());
                                  return Text(item['name']);
                                } else {
                                  return const Text('');
                                }
                              },
                            ),
                          ),
                        ),
                        borderData: FlBorderData(show: false),
                        barTouchData: BarTouchData(enabled: false),
                      ),
                    ),
                  )
                : const Center(
                    child: Text('No hay artículos en el inventario'),
                  ),
          ),
        ],
      ),
    );
  }
}
