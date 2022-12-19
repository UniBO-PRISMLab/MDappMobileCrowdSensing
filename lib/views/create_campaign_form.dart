import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';

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
  String? selectedValue = 'photo';
  double _howMuch = 5;
  int _howFar = 100;
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    parameters = ModalRoute.of(context)!.settings.arguments;
    positionSelectedData = jsonDecode(jsonEncode(parameters));

    String? _address = '';
    if(positionSelectedData.runtimeType != Null) {
      _address = positionSelectedData['address'];
      titleController.text = positionSelectedData['title'];
    }
      return Scaffold(
        resizeToAvoidBottomInset: false,
          appBar: AppBar(
            title: const Text('Create New Campaign'),
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
                          style: CustomTextStyle.spaceMono(context),
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
                          style: CustomTextStyle.spaceMono(context),
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
                              Navigator.pushNamed(context, '/map', arguments: {
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
                                style: CustomTextStyle.spaceMono(context),
                              ),
                              DropdownButton(
                                  value: selectedValue,
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'photo',
                                      child: Text("Photos"),
                                    ),
                                    DropdownMenuItem(
                                      value: 'light',
                                      child: Text("Ambient Light"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    setState(() {
                                      selectedValue = value as String?;
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
                                style: CustomTextStyle.spaceMono(context),
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
                                style: CustomTextStyle.spaceMono(context),
                              ),
                              Slider(
                                min: 100.0,
                                max: 1000.0,
                                divisions: 10,
                                value: _howFar.toDouble(),
                                label: "${_howFar.toInt()} meters",
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
                                        'Processing Data',
                                      style: CustomTextStyle.spaceMono(context),
                                    )));

                                Navigator.pushReplacementNamed(context, '/create_campaign_provider', arguments: {
                                  'title' : titleController.text,
                                  'lat' : (10000000 * positionSelectedData['lat']).toInt(),
                                  'lng' : (10000000 * positionSelectedData['lng']).toInt(),
                                  'payment' : _howMuch,
                                  'range' : _howFar,
                                  'type' : selectedValue,
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
