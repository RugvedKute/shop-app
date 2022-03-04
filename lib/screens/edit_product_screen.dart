import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../providers/products.dart';

class EditProductScreen extends StatefulWidget {
  static const routeName = '/EditProductScreen';
  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  // final _imageUrl = TextEditingController();
  var imageUrl = '';
  final _forms = GlobalKey<FormState>();
  var _editedproducts =
      Product(id: null, title: '', description: '', price: 0, imageUrl: '');
  var _isInIt = true;
  var initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': ''
  };
  var isLoading = false;

  @override
  void dispose() {
    // TODO: implement dispose
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  Future<void> saveForm() async {
    final isvalid = _forms.currentState.validate();
    if (!isvalid) {
      return null;
    } 

    _forms.currentState.save();
    setState(() {
      isLoading = true;
    });

    if (_editedproducts.id != null) {
      await Provider.of<ProductsProvider>(context, listen: false)
          .updateProducts(_editedproducts.id, _editedproducts);
      setState(() {
        isLoading = false;
      });
      Navigator.of(context).pop();
    } else {
      try {
        await Provider.of<ProductsProvider>(context, listen: false)
            .addProducts(_editedproducts);
      } catch (error) {
        await showDialog<Null>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('An error occurred!'),
            content: Text('Something went wrong'),
            actions: [
              FlatButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                },
                child: Text('OKAY'),
              )
            ],
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
        Navigator.of(context).pop();
      }
      ;
    }
  }

  @override
  void didChangeDependencies() {
    if (_isInIt) {
      final _productId = ModalRoute.of(context).settings.arguments as String;
      if (_productId != null) {
        _editedproducts = Provider.of<ProductsProvider>(context, listen: false)
            .items
            .firstWhere((prod) => prod.id == _productId);
        initValues = {
          'title': _editedproducts.title,
          'description': _editedproducts.description,
          'price': _editedproducts.price.toString(),
          'imageUrl': _editedproducts.imageUrl,
        };
      }
    }

    _isInIt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit products'),
        actions: [
          IconButton(
            onPressed: saveForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _forms,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: initValues['title'],
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_priceFocusNode);
                      },
                      decoration: InputDecoration(
                        label: Text('Title'),
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Enter a valid input.';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _editedproducts = Product(
                            id: _editedproducts.id,
                            title: value,
                            description: _editedproducts.description,
                            price: _editedproducts.price,
                            imageUrl: _editedproducts.imageUrl,
                            );
                      },
                    ),
                    TextFormField(
                        initialValue: initValues['price'],
                        decoration: InputDecoration(
                          label: Text('Price'),
                        ),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _priceFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a valid input.';
                          }
                          if (double.tryParse(value) == null) {
                            return 'Enter a valid number.';
                          }
                          if (double.parse(value) <= 0) {
                            return 'Enter no greater than zero.';
                          }
                        },
                        onSaved: (value) {
                          _editedproducts = Product(
                              id: _editedproducts.id,
                              title: _editedproducts.title,
                              description: _editedproducts.description,
                              price: double.parse(value),
                              imageUrl: _editedproducts.imageUrl,
                          );
                        },
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        }),
                    TextFormField(
                        initialValue: initValues['description'],
                        decoration: InputDecoration(
                          label: Text('Description'),
                        ),
                        maxLines: 3,
                        textInputAction: TextInputAction.next,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Enter a valid description.';
                          }
                          if (value.length < 10) {
                            return 'Enter atleast 10 character long description.';
                          }
                        },
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onSaved: (value) {
                          _editedproducts = Product(
                              id: _editedproducts.id,
                              title: _editedproducts.title,
                              description: value,
                              price: _editedproducts.price,
                              imageUrl: _editedproducts.imageUrl,
                              );
                        }),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          width: 100,
                          height: 100,
                          margin: EdgeInsets.only(top: 8, right: 5),
                          child: imageUrl.isEmpty
                              ? Text('Enter a URL')
                              : FittedBox(
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                        ),
                        Expanded(
                          child: TextFormField(
                              initialValue: initValues['imageUrl'],
                              keyboardType: TextInputType.url,
                              decoration:
                                  InputDecoration(label: Text('Image URL')),
                              textInputAction: TextInputAction.done,
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Enter an Image url.';
                                }
                                if (!value.startsWith('http') &&
                                    !value.startsWith('https')) {
                                  return 'Enter a valid url';
                                }
                              },
                              onSaved: (value) {
                                _editedproducts = Product(
                                    id: _editedproducts.id,
                                    title: _editedproducts.title,
                                    description: _editedproducts.description,
                                    price: _editedproducts.price,
                                    imageUrl: value,
                                    );
                              },
                              onFieldSubmitted: (value) {
                                setState(() {
                                  imageUrl = value;
                                });
                              }),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      onPressed: saveForm,
                      child: Container(
                        height: 50,
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        child: Text(
                          'Save',
                          textAlign: TextAlign.center,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.purple),
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
