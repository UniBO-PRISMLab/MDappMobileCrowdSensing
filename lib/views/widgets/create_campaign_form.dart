import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../view_models/create_campaign_fom_view_model.dart';

class CreateCampaignForm extends StatefulWidget {
  const CreateCampaignForm({super.key});

  @override
  CreateCampaignFormState createState() {
    return CreateCampaignFormState();
  }
}

// Create a corresponding State class.
// This class holds data related to the form.
class CreateCampaignFormState extends State<CreateCampaignForm> {

  dynamic positionSelectedData = {};
  Object? parameters;
  final _formKey = GlobalKey<FormState>();
  int? selectedValue = 1;
  CreateCampaignFormViewModel createCampaignFormData = CreateCampaignFormViewModel();
  double _howMuch = 5;

  @override
  Widget build(BuildContext context) {

    parameters = ModalRoute.of(context)!.settings.arguments;
    positionSelectedData = jsonDecode(jsonEncode(parameters));

    String address = '';

    (positionSelectedData.runtimeType != Null)? address = positionSelectedData['address'] : address='';

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
                  padding: const EdgeInsets.all(30),
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
                  padding: const EdgeInsets.all(30),
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
                          onPressed: () {
                            createCampaignFormData
                                .goToSearchPlacesView(context);
                          },
                          child: const Text('Get a place!')),
                      Padding(
                        padding: const EdgeInsets.all(30),
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
                        padding: const EdgeInsets.all(30),
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
                          ],
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: FloatingActionButton(
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
                            }
                          },
                          child: const Text('GO!'),
                        ),
                      ),
                    ],
                  ))
            ])));
  }
}
