import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../view_models/create_campaign_form_view_model.dart';

class CreateCampaignForm extends StatefulWidget {
  const CreateCampaignForm({super.key});

  @override
  CreateCampaignFormState createState() {
    return CreateCampaignFormState();
  }
}

class CreateCampaignFormState extends State<CreateCampaignForm> {

  dynamic positionSelectedData = {};
  Object? parameters;
  final _formKey = GlobalKey<FormState>();
  int? selectedValue = 1;
  CreateCampaignFormViewModel createCampaignFormData = CreateCampaignFormViewModel();
  double _howMuch = 5;
  int _howFar = 10;
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    parameters = ModalRoute.of(context)!.settings.arguments;
    positionSelectedData = jsonDecode(jsonEncode(parameters));

    String? _address = '';
    if(positionSelectedData.runtimeType != Null) {
      selectedValue = positionSelectedData['type'];
      _address = positionSelectedData['address'];
      titleController.text = positionSelectedData['title'];
      print(positionSelectedData);
    }
      return Scaffold(
        resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: Text(createCampaignFormData.appBarTitle),
          ),
          body: Form(
              key: _formKey,
              child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          'Title?',
                          style: GoogleFonts.spaceMono(
                              textStyle: const TextStyle(color: Colors.black87, letterSpacing: .5),
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                        TextFormField(
                          controller: titleController,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter the title';
                            }
                            return null;
                          },
                        ),
                      ],
                    )),
                Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Text(
                          'Where?',
                          style: GoogleFonts.spaceMono(
                              textStyle: const TextStyle(
                                  color: Colors.black87, letterSpacing: .5),
                              fontWeight: FontWeight.normal,
                              fontSize: 16),
                        ),
                        TextFormField(
                          initialValue: _address,
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please select a location';
                            }
                            return null;
                          },
                        ),
                        ElevatedButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/map', arguments: {
                                'title' : titleController.text,
                                'range' : _howFar,
                                'payment' : _howMuch,
                                'type' : selectedValue
                              });
                            },
                            child: const Text('Get a place!')),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                'What?',
                                style: GoogleFonts.spaceMono(
                                    textStyle: const TextStyle(
                                        color: Colors.black87, letterSpacing: .5),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
                              DropdownButton(
                                  value: selectedValue,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 1,
                                      child: Text("Photos"),
                                    ),
                                    DropdownMenuItem(
                                      value: 2,
                                      child: Text("Temperature"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value as int?;
                                    });
                                  }),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            children: [
                              Text(
                                'How much?',
                                style: GoogleFonts.spaceMono(
                                    textStyle: const TextStyle(
                                        color: Colors.black87, letterSpacing: .5),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
                              Slider(
                                min: 1.0,
                                max: 10.0,
                                divisions: 18,
                                value: _howMuch,
                                label: _howMuch.toStringAsFixed(1),
                                onChanged: (newValue) {
                                  setState(() {
                                    _howMuch = newValue;
                                  });
                                },
                              ),
                              Text(
                                'How Far?',
                                style: GoogleFonts.spaceMono(
                                    textStyle: const TextStyle(
                                        color: Colors.black87, letterSpacing: .5),
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16),
                              ),
                              Slider(
                                min: 10.0,
                                max: 50.0,
                                divisions: 7,
                                value: _howFar.toDouble(),
                                label: _howFar.toInt().toString(),
                                onChanged: (newValue) {
                                  setState(() {
                                    _howFar = newValue.toDouble().toInt();
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        FloatingActionButton(
                            onPressed: () {
                              // Validate returns true if the form is valid, or false otherwise.
                              if (_formKey.currentState!.validate()) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text(
                                      createCampaignFormData.snackBarText,
                                      style: GoogleFonts.merriweather(
                                          fontWeight: FontWeight.bold, fontSize: 16),
                                    )));

                                Navigator.pushNamed(context, '/create_campaign_provider', arguments: {
                                  'title' : titleController.text,
                                  'lat' : (100 * positionSelectedData['lat']).toInt(),
                                  'lng' : (100 * positionSelectedData['lng']).toInt(),
                                  'payment' : _howMuch,
                                  'range' : _howFar,
                                });
                              }
                            },
                            child: const Text('GO!'),
                          ),
                      ],
                    ))
              ])));
  }
}
