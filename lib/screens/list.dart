import 'package:flutter/material.dart';
import 'package:trabalho_final/daos/WeightDao.dart';
import 'package:trabalho_final/models/Weight.dart';
import 'package:trabalho_final/screens/add.dart';
import 'package:trabalho_final/screens/home.dart';

class WeightListWidget extends StatefulWidget {
  const WeightListWidget({super.key});

  final title = const Text("Weight by Date");

  @override
  State<WeightListWidget> createState() => _WeightListWidgetState();
}

class _WeightListWidgetState extends State<WeightListWidget> {
  List<Weight> weights = [];
  late WeightDao dao;

  @override
  void initState() {
    super.initState();
    dao = WeightDao();
    getAllWeights();
  }

  getAllWeights() async {
    final result = await dao.readAll();
    setState(() {
      weights = result;
    });
  }

  insertWeight(Weight weight) async {
    final id = await dao.insertWeight(weight);
    if (id > 0) {
      setState(() {
        weight.id = id;
        weights.add(weight);
      });
    }
  }

  deleteWeight(int index) async {
    Weight w = weights[index];
    if (w.id != null) {
      await dao.deleteWeight(w.id!);
      setState(() {
        weights.removeAt(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            leading: IconButton(
                icon: const Icon(Icons.arrow_back_rounded),
                onPressed: () {
                  Navigator.pushNamed(context, "/");
                }),
            title: widget.title,
            actions: [
              IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AddWeight()))
                        .then((weight) {
                      setState(() {
                        insertWeight(weight);
                      });
                    });
                  })
            ]),
        body: Container(
            color: Colors.black87,
            child: ListView.separated(
                itemBuilder: ((context, index) => buildListItem(index)),
                separatorBuilder: ((context, index) =>
                    const Divider(height: 1)),
                itemCount: weights.length)));
  }

  Widget buildListItem(index) {
    Weight w = weights[index];
    TextStyle tileTextStyle = const TextStyle(
        color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.black54,
            ),
            child: ListTile(
                leading: Text(w.id != null ? w.id.toString() : "-1"),
                title: Text(
                  w.date,
                  style: tileTextStyle,
                ),
                subtitle: Text("${w.weight} kg", style: tileTextStyle),
                onLongPress: () {
                  deleteWeight(index);
                })));
  }
}
