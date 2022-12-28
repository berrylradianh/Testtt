import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/models/biodata.dart';
import 'package:flutter_application_1/sql_helper.dart';
import 'package:flutter_application_1/models/biodata.dart';
import 'package:flutter_application_1/pages/detail_screen.dart';

// Make Form with radio button
class HomePage extends StatefulWidget {
  @override
  _FormData createState() => _FormData();
}

class _FormData extends State<HomePage> {
  String? gender;
  final nim = TextEditingController();
  final nama = TextEditingController();
  final alamat = TextEditingController();

  List<Map<String, dynamic>> _biodata = [];

  // Make Function, clear data when 'Cancel'
  void clearText() {
    nim.clear();
    nama.clear();
    alamat.clear();
    setState(() {
      gender = null;
    });
  }

  //fungsi tambah
  Future<void> _createItem() async {
    print('call');
    Biodata biodata = Biodata(
      nim: int.parse(nim.text),
      nama: nama.text,
      address: alamat.text,
      gender: gender,
    );

    int id = await SQLHelper.createItem(biodata);
    print(id);
  }

  //fungsi update
  Future<int> _updateItem(int id) async {
    final db = await SQLHelper.db();

    final biodata = {
      'nim': int.parse(nim.text),
      'nama': nama.text,
      'address': alamat.text,
      'gender': gender,
    };

    final result =
        await db.update('biodata', biodata, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  //fungsi panggil data
  Future<void> _getBiodata() async {
    final data = await SQLHelper.getItems();
    setState(() {
      _biodata = data;
    });
  }

  //fungsi hapus data
  Future<void> _deleteItem(int id) async {
    print(id);
    await SQLHelper.deleteItem(id);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xffF5591F),
          title: const Text(
            "Mahasiswa",
          ),
          centerTitle: true,
          bottom: TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.account_box),
                text: "INPUT DATA",
              ),
              Tab(
                icon: Icon(Icons.list_alt),
                text: "LIST DATA",
              ),
            ],
          ),
        ),
        body: TabBarView(children: [
          Scaffold(
            body: ListView(
              padding: EdgeInsets.all(16.0),
              children: [
                Container(
                  padding: EdgeInsets.all(15),
                  child: Text(
                    'Biodata Mahasiswa',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'NIM'),
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: nim,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Nama'),
                    controller: nama,
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: TextField(
                    maxLines: 3,
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), labelText: 'Alamat'),
                    controller: alamat,
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(left: 12, top: 10),
                  child: Row(
                    children: [
                      Text(
                        'Jenis Kelamin',
                        style: TextStyle(fontSize: 17),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.only(left: 10, bottom: 30),
                        title: Text(
                          'Laki - Laki',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        value: 'male',
                        groupValue: gender,
                        toggleable: true,
                        dense: true,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5.0,
                    ),
                    Expanded(
                      child: RadioListTile(
                        contentPadding: EdgeInsets.only(bottom: 30),
                        title: Text(
                          'Perempuan',
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        value: 'female',
                        groupValue: gender,
                        toggleable: true,
                        dense: true,
                        onChanged: (value) {
                          setState(() {
                            gender = value.toString();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                    ),
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 2 - 25,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.blue,
                        ),
                        onPressed: () => [
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: const Text("Alert"),
                              content: const Text("Data Berhasil Disimpan"),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                  child: Container(
                                    color: Colors.blue,
                                    padding: const EdgeInsets.all(14),
                                    child: const Text(
                                      "okay",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _createItem(),
                          clearText()
                        ],
                        child: Text('Submit'),
                      ),
                    ),
                    SizedBox(
                      width: 6.0,
                    ),
                    SizedBox(
                      height: 40,
                      width: MediaQuery.of(context).size.width / 2 - 25,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: Colors.red,
                        ),
                        onPressed: clearText,
                        child: Text('Cancel'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getBiodata(),
              builder: (context, snapshot) {
                return ListView.builder(
                  itemCount: _biodata.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      // on tap nya disini
                      onTap: () {
                        // TODO: pergi ke halaman detail
                        // get id and pass it to detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetailScreen(
                              id: _biodata[index]['id'],
                              nim: _biodata[index]['nim'],
                              nama: _biodata[index]['nama'],
                              address: _biodata[index]['address'],
                              gender: _biodata[index]['gender'],
                            ),
                          ),
                        );
                      },
                      child: Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                          trailing: SizedBox(
                            width: 100,
                            child: Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () =>
                                      _showForm(_biodata[index]['id']),
                                ),
                                IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (ctx) => AlertDialog(
                                          title: const Text("Alert"),
                                          content:
                                              const Text("Yakin Hapus Data?"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                _deleteItem(
                                                    _biodata[index]['id']);
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Container(
                                                color: Colors.red,
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: const Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.of(ctx).pop();
                                              },
                                              child: Container(
                                                color: Colors.blue,
                                                padding:
                                                    const EdgeInsets.all(14),
                                                child: const Text(
                                                  "No",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ],
                            ),
                          ),
                          title: Text(_biodata[index]['nama']),
                          subtitle: Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 10.0,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('NIM : ${_biodata[index]['nim']}'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> addItem(Biodata biodata) async {
    int result = await SQLHelper.createItem(biodata);
    if (result > 0) {
      nim.text = '';
      nama.text = '';
      alamat.text = '';
      setState(() {
        gender = null;
      });
    }
  }

  void _showForm(int? id) {
    if (id != null) {
      // id == null -> create new item
      // id != null -> update an existing item
      final currentBiodata =
          _biodata.firstWhere((element) => element['id'] == id);
      nim.text = currentBiodata['nim'].toString();
      nama.text = currentBiodata['nama'];
      alamat.text = currentBiodata['address'];
      gender = currentBiodata['gender'];
    }

    showModalBottomSheet(
      context: context,
      elevation: 5,
      isScrollControlled: true,
      builder: (_) => Scaffold(
        body: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            Container(
              padding: EdgeInsets.all(15),
              child: Text(
                'Update Mahasiswa',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'NIM'),
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                controller: nim,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Nama'),
                controller: nama,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                maxLines: 3,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Alamat'),
                controller: alamat,
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 12, top: 10),
              child: Row(
                children: [
                  Text(
                    'Jenis Kelamin',
                    style: TextStyle(fontSize: 17),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    contentPadding: EdgeInsets.only(left: 10, bottom: 30),
                    title: Text(
                      'Laki - Laki',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    value: 'male',
                    groupValue: gender,
                    toggleable: true,
                    dense: true,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                ),
                SizedBox(
                  width: 5.0,
                ),
                Expanded(
                  child: RadioListTile(
                    contentPadding: EdgeInsets.only(bottom: 30),
                    title: Text(
                      'Perempuan',
                      style: TextStyle(
                        fontSize: 17,
                      ),
                    ),
                    value: 'female',
                    groupValue: gender,
                    toggleable: true,
                    dense: true,
                    onChanged: (value) {
                      setState(() {
                        gender = value.toString();
                      });
                    },
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2 - 25,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () {
                      if (id != null) {
                        _updateItem(id);
                      }
                      clearText();
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Alert"),
                          content: const Text("Data Berhasil Diperbarui"),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Container(
                                color: Colors.blue,
                                padding: const EdgeInsets.all(14),
                                child: const Text(
                                  "okay",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Update'),
                  ),
                ),
                SizedBox(
                  width: 6.0,
                ),
                SizedBox(
                  height: 40,
                  width: MediaQuery.of(context).size.width / 2 - 25,
                  child: TextButton(
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
