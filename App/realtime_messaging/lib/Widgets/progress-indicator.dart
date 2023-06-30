
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

Widget progressIndicator(UploadTask? uploadTask,DownloadTask? downloadTask)=>StreamBuilder<TaskSnapshot>(
    stream:(uploadTask!=null)?uploadTask.snapshotEvents:downloadTask?.snapshotEvents,
    builder: (context,snapshot){
  if(snapshot.hasError){
    return
    Text('error :${snapshot.error}');
  }
  else if(snapshot.hasData){
    final data=snapshot.data;
    double progress=data!.bytesTransferred/data.totalBytes;
    return Stack(
      children: [CircularProgressIndicator(
        value: progress,
        backgroundColor: Colors.grey,
        color: Colors.greenAccent,

      ),
        Center(child: Text('${progress*100}%'))
      ]
    );
  }
  else{
    return const SizedBox(width: 0,);
  }
});