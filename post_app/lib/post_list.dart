import 'dart:convert';

import 'package:flutter/material.dart';
import 'comments.dart';
import 'post.dart';
import 'package:http/http.dart' as http;

class PostList extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return new MaterialApp(
      title: 'PostApp',
      theme: new ThemeData(
      primarySwatch: Colors.orange,
        ),
          home: new MyPost (title: 'Post'),
      );
    }
}

class MyPost extends StatefulWidget{
  MyPost({Key key, this.title}) : super (key:key);

    final String title;

  @override
  _MyPostState createState() => new _MyPostState();
}


class _MyPostState extends State<MyPost>{
  List<Post> _post = List<Post>();
  Future<List<Post>> getPost() async {
    var data = await http.get("https://jsonplaceholder.typicode.com/posts");
    var jsonData =json.decode(data.body);

    List<Post> posts = [];
    

    for (var p in jsonData) {
      Post post = Post(p["userId"], p["id"], p["title"], p["body"]);

      posts.add(post);
    }
    print(posts.length);
    return posts;
  }
   void initState() {
    getPost().then((value) => setState(() {
          _post.addAll(value);
        }));

    super.initState();
  }


 @override
  Widget build (BuildContext context){
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: Container(
        child: FutureBuilder(
          future: getPost(),
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if (snapshot.data==null){
              return Container(
                child: Center(
                  child: Text("Cargando..")
                )
              );
            }else{
            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index){
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage("https://concepto.de/wp-content/uploads/2018/08/persona-e1533759204552.jpg"),
                    ),
                    title: Text(snapshot.data[index].title),
                    subtitle: Text(snapshot.data[index].body),
                    onTap: (){
                      Navigator.push(context,
                      new MaterialPageRoute(builder:(context)=> Comments(snapshot.data[index], post: _post[index],)
                                      ,
                                    ));
                    }
                    
                );
              }
            );
            }
          }
        ),
      ),
      );
         
    }
}
 



