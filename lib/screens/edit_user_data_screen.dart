import 'package:flutter/material.dart';
import '../providers/auth.dart';
import 'package:provider/provider.dart';

class EditUserDataScreen extends StatefulWidget {
  static const routeName = 'edit-user-data-screen';

  @override
  _EditUserDataScreenState createState() => _EditUserDataScreenState();
}

class _EditUserDataScreenState extends State<EditUserDataScreen> {
  final _descriptionFocusNode = FocusNode();
  final _imageUrl03Controller = TextEditingController();
  final _descriptionController = TextEditingController();
  final _imageUrl03FocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    _imageUrl03FocusNode.addListener(_updateImageUrl03);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    print('se invoca directamente');
    final authData = Provider.of<Auth>(context, listen: false);
    _imageUrl03Controller.text = authData.photo;
    if (_isInit) {
      if (ModalRoute.of(context)?.settings.arguments != null) {
        final productId = ModalRoute.of(context)!.settings.arguments as String;
      }
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    _descriptionController.dispose();
    _imageUrl03Controller.dispose();
    _imageUrl03FocusNode.dispose();
    _imageUrl03FocusNode.removeListener(_updateImageUrl03);
    super.dispose();
  }

  void _updateImageUrl03() {
    if (!_imageUrl03FocusNode.hasFocus) {
      setState(() {});
    }
  }

  Future<void> _safeForm() async {
    _form.currentState!.save();
    String urlPhoto =
        await Provider.of<Auth>(context, listen: false).getPhotoUrl();

    setState(() {
      _isLoading = true;
    });
    if (_imageUrl03Controller.text != '') {
      final authData = Provider.of<Auth>(context, listen: false);
      print("_imageUrl03Controller.text: " + _imageUrl03Controller.text);
      print("_descriptionController.text: " + _descriptionController.text);
      authData.addDataUser(authData.token, authData.userId,
          _imageUrl03Controller.text, _descriptionController.text);
    } else {
      try {} catch (error) {
        await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text('Ocurrió un error'),
                  content: Text('Algo malo ocurrió'),
                  actions: <Widget>[
                    ElevatedButton(
                      child: Text('ok'),
                      onPressed: () {
                        Navigator.of(ctx).pop();
                      },
                    )
                  ],
                ));
      }
    }
    setState(() {
      _isLoading = false;
    });
    Navigator.of(context).pop();

    //Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context, listen: false);
    _descriptionController.text = authData.description;
    //_imageUrl03Controller.text = authData.photo;
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Data User'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _safeForm,
          )
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(color: Colors.black)),
                        maxLines: 3,
                        style: TextStyle(color: Colors.black),
                        keyboardType: TextInputType.multiline,
                        controller: _descriptionController,
                        focusNode: _descriptionFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_imageUrl03FocusNode);
                        },
                        onSaved: (value) {},
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 100,
                            height: 100,
                            margin: EdgeInsets.only(top: 8, right: 10),
                            decoration: BoxDecoration(
                                border: Border.all(
                              width: 1,
                              color: Colors.deepOrange,
                            )),
                            child: _imageUrl03Controller.text.isEmpty
                                ? Text('Ingrese un Url')
                                : FittedBox(
                                    child: Image.network(
                                      _imageUrl03Controller.text,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                          Expanded(
                              child: TextFormField(
                            decoration:
                                InputDecoration(labelText: 'Image03 Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrl03Controller,
                            focusNode: _imageUrl03FocusNode,
                            onFieldSubmitted: (_) {
                              _safeForm();
                            },
                            onSaved: (value) {},
                          ))
                        ],
                      ),
                    ],
                  )),
            ),
    );
  }
}
