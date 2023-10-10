import "package:flutter/material.dart";
import "package:scoped_model/scoped_model.dart";
import "NotesDBWorker.dart";
import "NotesModel.dart" show NotesModel, notesModel;


class NotesEntry extends StatelessWidget {


  final TextEditingController _titleEditingController = TextEditingController();
  final TextEditingController _contentEditingController = TextEditingController();


  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();


  NotesEntry() {

    print("## NotesEntry.constructor");

    _titleEditingController.addListener(() {
      notesModel.entityBeingEdited.title = _titleEditingController.text;
    });
    _contentEditingController.addListener(() {
      notesModel.entityBeingEdited.content = _contentEditingController.text;
    });

  } 


  
  Widget build(BuildContext inContext) {

    print("## NotesEntry.build()");

   
    if (notesModel.entityBeingEdited != null) {
      _titleEditingController.text = notesModel.entityBeingEdited.title;
      _contentEditingController.text = notesModel.entityBeingEdited.content;
    }


    return ScopedModel(
      model : notesModel,
      child : ScopedModelDescendant<NotesModel>(
        builder : (BuildContext inContext, Widget inChild, NotesModel inModel) {
          return Scaffold(
            bottomNavigationBar : Padding(
              padding : EdgeInsets.symmetric(vertical : 0, horizontal : 10),
              child : Row(
                children : [
                  FlatButton(
                    child : Text("Cancel"),
                    onPressed : () {
                   
                      FocusScope.of(inContext).requestFocus(FocusNode());
                  
                      inModel.setStackIndex(0);
                    }
                  ),
                  Spacer(),
                  FlatButton(
                    child : Text("Save"),
                    onPressed : () { _save(inContext, notesModel); }
                  )
                ]
              )
            ),
            body : Form(
              key : _formKey,
              child : ListView(
                children : [
          
                  ListTile(
                    leading : Icon(Icons.title),
                    title : TextFormField(
                      decoration : InputDecoration(hintText : "Title"),
                      controller : _titleEditingController,
                      validator : (String inValue) {
                        if (inValue.length == 0) { return "Please enter a title"; }
                        return null;
                      }
                    )
                  ),
                 
                  ListTile(
                    leading : Icon(Icons.content_paste),
                    title : TextFormField(
                      keyboardType : TextInputType.multiline, maxLines : 8,
                      decoration : InputDecoration(hintText : "Content"),
                      controller : _contentEditingController,
                      validator : (String inValue) {
                        if (inValue.length == 0) { return "Please enter content"; }
                        return null;
                      }
                    )
                  ),
            
                  ListTile(
                    leading : Icon(Icons.color_lens),
                    title : Row(
                      children : [
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.red, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "red" ? Colors.red : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "red";
                            notesModel.setColor("red");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.green, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "green" ? Colors.green : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "green";
                            notesModel.setColor("green");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.blue, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "blue" ? Colors.blue : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "blue";
                            notesModel.setColor("blue");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.yellow, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "yellow" ? Colors.yellow : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "yellow";
                            notesModel.setColor("yellow");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.grey, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "grey" ? Colors.grey : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "grey";
                            notesModel.setColor("grey");
                          }
                        ),
                        Spacer(),
                        GestureDetector(
                          child : Container(
                            decoration : ShapeDecoration(shape :
                              Border.all(color : Colors.purple, width : 18) +
                              Border.all(
                                width : 6,
                                color : notesModel.color == "purple" ? Colors.purple : Theme.of(inContext).canvasColor
                              )
                            )
                          ),
                          onTap : () {
                            notesModel.entityBeingEdited.color = "purple";
                            notesModel.setColor("purple");
                          }
                        )
                      ]
                    )
                  )
                ] 
              ) 
            ) 
          ); 
        } 
      ) 
    ); 

  } 


 
  void _save(BuildContext inContext, NotesModel inModel) async {

    print("## NotesEntry._save()");

  
    if (!_formKey.currentState.validate()) { return; }

 
    if (inModel.entityBeingEdited.id == null) {

      print("## NotesEntry._save(): Creating: ${inModel.entityBeingEdited}");
      await NotesDBWorker.db.create(notesModel.entityBeingEdited);

   
    } else {

      print("## NotesEntry._save(): Updating: ${inModel.entityBeingEdited}");
      await NotesDBWorker.db.update(notesModel.entityBeingEdited);

    }
    notesModel.loadData("notes", NotesDBWorker.db);


    inModel.setStackIndex(0);

   
    Scaffold.of(inContext).showSnackBar(
      SnackBar(
        backgroundColor : Colors.green,
        duration : Duration(seconds : 2),
        content : Text("Note saved")
      )
    );

  } 


} 