
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
      children: [Center(
        child: CircularProgressIndicator(
          value: progress,
          backgroundColor: Colors.grey[300],
          color: Colors.orangeAccent,

        ),
      ),
        Center(child: Text('${(progress*100).toInt()}%',style: const TextStyle(color: Colors.blue),textAlign: TextAlign.center,))
      ]
    );
  }
  else{
    return const SizedBox(width: 0,);
  }
});