import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SendOrUpdateData extends StatefulWidget {
  final String judul;
  final String tahun_terbit;
  final String penulis;
  final String id;
  const SendOrUpdateData(
      {this.judul = '',
      this.tahun_terbit = '',
      this.penulis = '',
      this.id = ''});
  @override
  State<SendOrUpdateData> createState() => _SendOrUpdateDataState();
}

class _SendOrUpdateDataState extends State<SendOrUpdateData> {
  TextEditingController judulController = TextEditingController();
  TextEditingController tahun_terbitController = TextEditingController();
  TextEditingController penulisController = TextEditingController();
  bool showProgressIndicator = false;

  @override
  void initState() {
    judulController.text = widget.judul;
    tahun_terbitController.text = widget.tahun_terbit;
    penulisController.text = widget.penulis;
    super.initState();
  }

  @override
  void dispose() {
    judulController.dispose();
    tahun_terbitController.dispose();
    penulisController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        title: Text(
          'Send Data',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
      body: SingleChildScrollView(
        padding:
            EdgeInsets.symmetric(horizontal: 20).copyWith(top: 60, bottom: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            TextField(
              controller: judulController,
              decoration: InputDecoration(hintText: 'e.g. Laskar Pelangi'),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Tahun Terbit',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            TextField(
              controller: tahun_terbitController,
              decoration: InputDecoration(hintText: 'e.g. 2008'),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Penulis',
              style: TextStyle(fontWeight: FontWeight.w500),
            ),
            TextField(
              controller: penulisController,
              decoration: InputDecoration(hintText: 'e.g. Giring Nidji'),
            ),
            SizedBox(
              height: 40,
            ),
            MaterialButton(
              onPressed: () async {
                setState(() {});
                if (judulController.text.isEmpty ||
                    tahun_terbitController.text.isEmpty ||
                    penulisController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Fill in all fields')));
                } else {
                  //reference to document
                  final dUser = FirebaseFirestore.instance
                      .collection('buku')
                      .doc(widget.id.isNotEmpty ? widget.id : null);
                  String docID = '';
                  if (widget.id.isNotEmpty) {
                    docID = widget.id;
                  } else {
                    docID = dUser.id;
                  }
                  final jsonData = {
                    'judul': judulController.text,
                    'tahun_terbit': int.parse(tahun_terbitController.text),
                    'penulis': penulisController.text,
                    'id': docID
                  };
                  showProgressIndicator = true;
                  if (widget.id.isEmpty) {
                    //create document and write data to firebase
                    await dUser.set(jsonData).then((value) {
                      judulController.text = '';
                      tahun_terbitController.text = '';
                      penulisController.text = '';
                      showProgressIndicator = false;
                      setState(() {});
                    });
                  } else {
                    await dUser.update(jsonData).then((value) {
                      judulController.text = '';
                      tahun_terbitController.text = '';
                      penulisController.text = '';
                      showProgressIndicator = false;
                      setState(() {});
                    });
                  }
                }
              },
              minWidth: double.infinity,
              height: 50,
              color: Colors.blue.shade900,
              child: showProgressIndicator
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
