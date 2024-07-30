import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/main.dart';
import 'package:course_correct/models/tutor_model.dart';
import 'package:course_correct/pages/tutor_matching_algorithm.dart';
import 'package:flutter/material.dart';


class TutorSorting extends StatelessWidget {
const TutorSorting({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Title'),
      ),
      body: FutureBuilder(
        future:appState.fetchTutors(), 
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          ///print(snapshot.data);
          //final TutorModel tutor = snapshot.data as TutorModel;
          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context,index){
              final Map tutor = snapshot.data![index];
              return ListTile(
                title: Text(tutor['name']!),
                subtitle: Text('Availability: ${tutor['availability']}'),
              );
            },
            ); 
          //Card(
          //   child: Column(
          //     children: [
                
          //     ],
          //   ),
          // );
        }
          
          )
        
          // return ListView.builder(
          //   itemCount: tutors.length,
          //   itemBuilder: (context,index){
          //     return ListTile(
          //       title: Text(tutors[index].name!),
          //       subtitle: Text('Availability: ${tutors[index].availability}'),
          //     );
          //   },
          // );
          
    );

  }
  }