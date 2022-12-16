import 'package:database/sqlhelper.dart';
import 'package:flutter/material.dart';

class home extends StatefulWidget {
  const home({Key? key}) : super(key: key);

  @override
  State<home> createState() => _homeState();
}
class _homeState extends State<home> {
  List<Map<String, dynamic>> database = [];
  bool _isLoading = true;

  void _refreshJournals() async {
    final data = await SQLHelper.getItems();
    setState(() {
      database = data;
      _isLoading = false;
    });
  }

  void initState() {
    super.initState();
    _refreshJournals();
  }

  final TextEditingController _titlecontroller = TextEditingController();
  final TextEditingController _descrcontroller = TextEditingController();

  void _showForm(int? id) async {
    if (id != null) {
      final existingJournal =
      database.firstWhere((element) => element['id'] == id);
      _titlecontroller.text = existingJournal['title'];
      _descrcontroller.text = existingJournal['description'];
    }
    showModalBottomSheet(context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) =>
          Container(
            padding: EdgeInsets.only(
                top: 15,
                left: 15,
                right: 15,
                bottom: MediaQuery
                    .of(context)
                    .viewInsets
                    .bottom + 200
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: _titlecontroller,
                  decoration: InputDecoration(
                      hintText: 'title'
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextField(
                  controller: _descrcontroller,
                  decoration: InputDecoration(hintText: 'description'),
                ),
                SizedBox(
                  height: 10,
                ),
                ElevatedButton(onPressed: () async {
                  if (id == null) {
                    await addItem();
                  }
                  if (id != null) {
                    await updateItem(id);
                  }
                  _titlecontroller.text = '';
                  _descrcontroller.text = '';

                  // Close the bottom sheet
                  Navigator.of(context).pop();
                }, child: Text(id == null ? 'creat new' : 'update'))
              ],
            ),
          ),
    );
  }
  Future<void> addItem()async{
    SQLHelper.createitem(_titlecontroller.text, _descrcontroller.text);
    _refreshJournals();
  }
  Future<void> updateItem(int id)async{
    SQLHelper.updateItem(_titlecontroller.text, id, _descrcontroller.text);
    _refreshJournals();
  }
Future<void>deleteItem(int id)async{
  await SQLHelper.deleteitem(id);
  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
    content: Text('Successfully deleted a journal!'),
  ));
  _refreshJournals();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('SQflite'),
      ),
      body: _isLoading ? Center(
        child: CircularProgressIndicator(),
      ) : ListView.builder(itemCount: database.length,
          itemBuilder: (context, index) =>
              Card(
                color: Colors.orange[200],
                margin: EdgeInsets.all(20),
                child: ListTile(
                  title: Text(database[index]['title']),
                  subtitle: Text(database[index]['description']),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                            onPressed: () => _showForm(database[index]['id']),
                            icon: Icon(Icons.edit)),
                        IconButton(onPressed: ()=>deleteItem(database[index]['id'])
                            ,icon: Icon(Icons.delete))
                      ],
                    ),
                  ),
                ),
              )
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(null),
        child: Icon(Icons.add),
      ),
    );
  }

}
