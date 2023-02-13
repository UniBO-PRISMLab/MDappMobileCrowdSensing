import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/create_campaign_model.dart';
import '../models/search_places_model.dart';
import '../utils/styles.dart';
import '../views/search_places_view.dart';

class CreateCampaignFormController extends StatefulWidget {
  const CreateCampaignFormController({Key? key}) : super(key: key);

  @override
  State<CreateCampaignFormController> createState() =>
      _CreateCampaignFormControllerState();
}

class _CreateCampaignFormControllerState
    extends State<CreateCampaignFormController> {
  final _formKey = GlobalKey<FormState>();
  String selectedValue = 'photo';
  double _howMuch = 0;
  int _howFar = 100;
  final titleController = TextEditingController();
  String? address;
  double? lat;
  double? lng;

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Text(
                    'Title?',
                    style: CustomTextStyle.spaceMono(context),
                  ),
                  SizedBox(
                      width: DeviceDimension.deviceWidth(context) * 0.8,
                      child: TextFormField(
                        controller: titleController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the title';
                          }
                          return null;
                        },
                      )),
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
                  SizedBox(
                      width: DeviceDimension.deviceWidth(context) * 0.8,
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        controller: TextEditingController()
                          ..text = (address != null) ? address! : '',
                        readOnly: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select a location';
                          }
                          return null;
                        },
                      )),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              CustomColors.blue900(context))),
                      onPressed: () async {
                        if (!mounted) return;
                        SearchPlacesModel? res = await Navigator.of(context)
                            .push(MaterialPageRoute(
                                builder: (context) =>
                                    const SearchPlacesView()));

                        if (res != null) {
                          address = res.address;
                          lat = res.lat;
                          lng = res.lng;
                          if (kDebugMode) {
                            print(
                                " info gotten: $address LATITUDE: ${(lat! / 10000000).round()} LONGITUDE: ${(lng! / 10000000).round()}");
                          }
                        }
                        setState(() {});
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
                          min: 0,
                          max:  1000000000000000000,
                          divisions: 100,
                          label: "${_howMuch.toInt()/1000000000000000000} MCScoin",
                          activeColor: CustomColors.blue900(context),
                          value: _howMuch,
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
                      if (_formKey.currentState!.validate() &&
                          lat != null &&
                          lng != null) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          'Processing Data',
                          style: CustomTextStyle.spaceMonoWhite(context),
                        )));
                        String res = await CreateCampaignModel.createCampaign(
                            context,
                            titleController.text,
                            BigInt.from((10000000 * lat!)),
                            BigInt.from((10000000 * lng!)),
                            BigInt.from(_howFar),
                            selectedValue,
                            BigInt.from(_howMuch));

                        if (res == 'Campaign Created') {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              'Campaign Created',
                              style: CustomTextStyle.spaceMonoWhite(context),
                            )));
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/home', (Route<dynamic> route) => false);
                          });
                        } else {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content: Text(
                              res,
                              style: CustomTextStyle.spaceMonoWhite(context),
                            )));
                          });
                        }
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                          'An error with position data',
                          style: CustomTextStyle.spaceMonoWhite(context),
                        )));
                      }
                    },
                    child: const Text('GO!'),
                  ),
                ],
              ))
        ]));
  }
}
