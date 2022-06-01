import 'package:fill_form/data.dart';
import 'package:fill_form/view_page.dart';
import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

class insert_page extends StatefulWidget {

  String? type;
  Map? m;
  insert_page({required this.type,this.m});



  @override
  State<insert_page> createState() => _insert_pageState();
}

class _insert_pageState extends State<insert_page> {
  TextEditingController tname = TextEditingController();
  TextEditingController tnumber = TextEditingController();


  Database? db;

  bool namestatus = false;
  bool numberstatus =false;

  String numbermsg ="";



  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fillDataForUpdate();

    data().createDatabase().then((value) {
      db=value;
    });

  }

  fillDataForUpdate()
  {
    if(widget.type=="update")
      {
        tname.text=widget.m!['name'];
        tnumber.text=widget.m!['number'];
      }

  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: Scaffold(
      appBar: AppBar(),
      body: Container(
        height: 400,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [

            TextField(
              controller: tname,
              textInputAction: TextInputAction.next,
              decoration: InputDecoration(
                errorText: namestatus ? "Please Enter name" : null,
                errorBorder: OutlineInputBorder(),

                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),

                  borderRadius: BorderRadius.circular(20),),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20)
                ),
                label: Text("Enter Name"),
                prefixIcon: Icon(Icons.create_outlined,),



              ),
            ),
            TextField(

              maxLength: 10,
              controller: tnumber,
              decoration: InputDecoration(
                errorText: numberstatus ? "please enter number" : null,
                errorBorder: OutlineInputBorder(),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black12),

                  borderRadius: BorderRadius.circular(20),),
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20)
                ),
                label: Text("Enter Number",style: TextStyle(color: Colors.black),),
                prefixIcon: Icon(Icons.phone_outlined,),
                prefix: Text("+91"),




              ),
            ),

            ElevatedButton(onPressed: () async {

              namestatus = false;
              numberstatus =false;

              String name = tname.text;
              String number = tnumber.text;

              if(name.isEmpty)
              {
                namestatus=true;
                setState(() {});

              }
              else if(number.isEmpty)
              {
                numberstatus=true;
                setState(() {});
              }
              else if(number.length<10)
              {
                numberstatus=true;

                setState(() {});


              }
              else
              {
                if(widget.type=="insert")
                {

                  String qry ="insert into form (name, number ,fav) values ('$name','$number','0')";
                  int a = await db!.rawInsert(qry);
                  print(a);

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return view_page();
                  },));


                }
                else
                {
                  int id = widget.m!['id'];
                  String qry = "update form set name = '$name' ,number = '$number' where id = '$id'";
                  int a = await db!.rawUpdate(qry);

                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                    return view_page();
                  },));
                }



              }



            }, child: widget.type=="insert" ? Text("save") : Text("update"))
          ],
        ),
      ),
    ), onWillPop: goback);
  }
  Future<bool> goback()
  {
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
      return view_page();
    },));

    return Future.value();
  }
}
