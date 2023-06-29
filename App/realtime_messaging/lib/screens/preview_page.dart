import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:realtime_messaging/Widgets/progress-indicator.dart';
import 'dart:io';

class PreviewPage extends StatefulWidget {
  final FilePickerResult result;
  const PreviewPage( {Key? key,required this.result}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  List<firebase_storage.UploadTask> uploadTask=[];
  bool isuploading=false;
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
                child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            (isuploading)? const Expanded(child: BackButton()):const SizedBox(width: 0,),
            ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.result.paths.length,
              itemBuilder: (context,index){
              return
               Stack(
                 children:[ Container(
                   color: Colors.deepPurpleAccent,
                   height: 500,
                  width: 300,
                  padding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        CupertinoIcons.doc,size: 35,
                       
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('${ widget.result.names[index]}'),
                      ),
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text('${widget.result.files[index].size}.${widget.result.files[index].extension}'),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text('${widget.result.files[index].bytes}'),
                      )
                      
                    ],
                    
                  ),
              ),
                   Center(child: progressIndicator(uploadTask[index]))
                 
                 ]
               );},
              
            ),
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle
              ),
              child: IconButton(onPressed: () async {


                  for (int i = 0; i < widget.result.files.length; i++) {
                    firebase_storage.Reference ref =
                    firebase_storage.FirebaseStorage.instance.ref(
                        '/documents/${DateTime.fromMicrosecondsSinceEpoch}');
                    uploadTask.add(ref.putFile(File(widget.result.files[i]
                        .path!)));
                    await Future.value(uploadTask);

                    final docUrl=await ref.getDownloadURL();

                  }

                Navigator.pop(context,true);
                
              }, icon: const Icon(Icons.send_rounded)),
            )
            
          ],
        ),
      ),
    );
  }
}
