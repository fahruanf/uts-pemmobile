import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'send_or_update_data_screen.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SendOrUpdateData()));
          },
          backgroundColor: Colors.red.shade900,
          child: Icon(Icons.add)),
      appBar: AppBar(
        backgroundColor: Colors.red.shade900,
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(fontWeight: FontWeight.w300),
        ),
      ),
            body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('buku').snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot> streamSnapshot) {
          return streamSnapshot.hasData
              ? ListView.builder(
                  padding: EdgeInsets.symmetric(vertical: 41),
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: ((context, index) {
                    return Container(
                        margin: EdgeInsets.symmetric(horizontal: 20)
                            .copyWith(bottom: 10),
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        decoration:
                            BoxDecoration(color: Colors.white, boxShadow: [
                          BoxShadow(
                              color: Colors.grey.shade300,
                              blurRadius: 5,
                              spreadRadius: 1,
                              offset: Offset(2, 2))
                        ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.book,
                                  size: 31,
                                  color: Colors.red.shade300,
                                ),
                                SizedBox(width: 11),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      streamSnapshot.data!.docs[index]['judul'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      streamSnapshot
                                          .data!.docs[index]['tahun_terbit']
                                          .toString(),
                                      style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    Text(
                                      streamSnapshot.data!.docs[index]
                                          ['penulis'],
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                SendOrUpdateData(
                                                  judul: streamSnapshot.data!
                                                      .docs[index]['judul'],
                                                  tahun_terbit: streamSnapshot
                                                      .data!
                                                      .docs[index]
                                                          ['tahun_terbit']
                                                      .toString(),
                                                  penulis: streamSnapshot.data!
                                                      .docs[index]['penulis'],
                                                  id: streamSnapshot
                                                      .data!.docs[index]['id'],
                                                )));
                                  },
                                  child: Icon(
                                    Icons.edit,
                                    color: Colors.green,
                                    size: 21,
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    bool? shouldDelete =
                                        await _showDeleteConfirmationDialog(
                                            context);

                                    if (shouldDelete ?? false) {
                                      final docData = FirebaseFirestore.instance
                                          .collection('buku')
                                          .doc(streamSnapshot.data!.docs[index]
                                              ['id']);
                                      await docData.delete();
                                    }
                                  },
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red.shade900,
                                    size: 21,
                                  ),
                                )
                              ],
                            ),
                          ],
                        ));
                  }))
              : Center(
                  child: SizedBox(
                      height: 100,
                      width: 100,
                      child: CircularProgressIndicator()),
                );
        },
      ),
    );
  }

  Future<bool?> _showDeleteConfirmationDialog(BuildContext context) async {
    return await showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Konfirmasi Hapus'),
          content: Text('Apakah Anda yakin ingin menghapus buku ini?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Tidak menghapus
              },
              child: Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Hapus
              },
              child: Text('Hapus'),
            ),
          ],
        );
      },
    );
  }
}
