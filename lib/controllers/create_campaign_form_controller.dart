import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/create_campaign_model.dart';
import '../utils/styles.dart';

class CreateCampaignFormController extends StatefulWidget {
  const CreateCampaignFormController({Key? key}) : super(key: key);

  @override
  State<CreateCampaignFormController> createState() => _CreateCampaignFormControllerState();
}

class _CreateCampaignFormControllerState extends State<CreateCampaignFormController> {

  dynamic positionSelectedData = {};
  Object? parameters;
  final _formKey = GlobalKey<FormState>();
  String selectedValue = 'photo';
  double _howMuch = 5;
  int _howFar = 100;
  final titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    parameters = ModalRoute.of(context)!.settings.arguments;
    positionSelectedData = jsonDecode(jsonEncode(parameters));

    String? address = '';
    if(positionSelectedData.runtimeType != Null) {
      address = positionSelectedData['address'];
      titleController.text = positionSelectedData['title'];
    }

    return Form(
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
                    initialValue: address,
                    readOnly: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a location';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStateProperty.all(CustomColors.blue900(context))),
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
                                selectedValue = value as String;
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
                          activeColor: CustomColors.blue900(context),
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
                          divisions: 18,
                          activeColor: CustomColors.blue900(context),
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
                    backgroundColor: CustomColors.blue900(context),
                    onPressed: () async {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (_formKey.currentState!.validate()) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(SnackBar(
                            content: Text(
                              'Processing Data',
                              style: CustomTextStyle.spaceMono(context),
                            )));
                        bool res = await CreateCampaignModel.createCampaign(
                            context,
                            titleController.text,
                            BigInt.from((10000000 * positionSelectedData['lat'])),
                            BigInt.from((10000000 * positionSelectedData['lng'])),
                            BigInt.from(_howFar),
                            selectedValue,
                            BigInt.from(_howMuch)
                        );

                        if(res) {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              content: Text(
                                'Campaign Created',
                                style: CustomTextStyle.spaceMonoWhite(context),
                              )));
                          Navigator.pushReplacementNamed(context, '/home');
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(SnackBar(
                              content: Text(
                                'An Error occurred',
                                style: CustomTextStyle.spaceMonoWhite(context),
                              )));
                        }
                          //'lat' : (10000000 * positionSelectedData['lat']).toInt(),
                          //'lng' : (10000000 * positionSelectedData['lng']).toInt(),

                      }
                    },
                    child: const Text('GO!'),
                  ),
                ],
              ))
        ]));
  }
}
