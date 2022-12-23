import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobile_crowd_sensing/utils/styles.dart';
import 'package:mobile_crowd_sensing/models/session_model.dart';
import '../models/smart_contract_model.dart';
import '../models/search_places_model.dart';

class SourcerCampaignView extends StatefulWidget {
  final List<dynamic>? contractAddress;

  const SourcerCampaignView({Key? key, required this.contractAddress})
      : super(key: key);

  @override
  State<SourcerCampaignView> createState() => _SourcerCampaignViewState();
}

class _SourcerCampaignViewState extends State<SourcerCampaignView> {

  SessionModel sessionData = SessionModel();
  String name = '';
  String latitude = '';
  String longitude = '';
  String range = '';
  String type = '';
  String addressCrowdSourcer = '';
  String? readebleLocation = '';

  String fileCount = '0';
  String fileChecked = '0';
  String workersCount = '0';

  late SmartContractModel smartContractViewModel;
  SearchPlacesModel searchPlacesViewModel = SearchPlacesModel();


  _getFilesCountes() async {
    List<dynamic>? fileCountRaw = await smartContractViewModel.queryCall('fileCount', [], null);
    List<dynamic>? fileCheckedRaw = await smartContractViewModel.queryCall('checkedFiles', [], null);
    if(mounted) {
      setState(() {
        if (fileCheckedRaw != null) {
          fileChecked = fileCheckedRaw[0].toString();
        }
        if (fileCountRaw != null) {
          fileCount = fileCountRaw[0].toString();
        }

        //to implement in the contract
        workersCount = 'NaN';
      });
    }
  }

  @override
  initState() {
    if (widget.contractAddress![0].toString() != "0x0000000000000000000000000000000000000000") {
        smartContractViewModel = SmartContractModel(widget.contractAddress![0].toString(), 'Campaign', 'assets/abi_campaign.json', provider: sessionData.getProvider());
        String? readebleLocationQuery;

    smartContractViewModel.queryCall('getInfo', [], null).then((value) async => {
        if (value != null) {
          readebleLocationQuery =
          await searchPlacesViewModel.getReadebleLocationFromLatLng(
              (double.parse(value[1].toString())) / 10000000,
              (double.parse(value[2].toString())) / 10000000),

    setState(() {
            name = value[0];
            latitude = value[1].toString();
            longitude = value[2].toString();
            range = value[3].toString();
            type = value[4];
            addressCrowdSourcer = value[5].toString();
            readebleLocation = readebleLocationQuery;
          })
        }
        });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _getFilesCountes();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomColors.blue900(context),
          title: const Text('Your Campaign'),
          centerTitle: true,
        ),
        body: (widget.contractAddress![0].toString() != "0x0000000000000000000000000000000000000000") ?
        Container(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                width: double.maxFinite,
                child:
                Column (
                    children: [
                      Padding(padding: const EdgeInsets.all(20), child:
                      Column (
                        children: [
                      Text(
                        'Account',
                        style: CustomTextStyle.merriweatherBold(context),
                      ),
                      Text(
                        '${sessionData.getAccountAddress()}',
                        style: GoogleFonts.inconsolata(fontSize: 16),
                      ),])
                      ),
                      Text("Swipe right to close the campaign",style: CustomTextStyle.spaceMono(context)),
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: widget.contractAddress!.length,
                      itemBuilder: (context, index) {
                      return Dismissible(
                        direction: DismissDirection.startToEnd,
                        confirmDismiss: (direction) {
                          return showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('Are you sure?'),
                            content: const Text('Do you want to close this campaign?'),
                            actions: <Widget>[
                              TextButton(child: const Text('No'),onPressed: () {
                                Navigator.of(ctx).pop(false);
                              }),
                              TextButton(child: const Text('Yes'),onPressed: () {
                                Navigator.of(ctx).pop(true);
                                Navigator.pushReplacementNamed(context, "/sourcer_close_campaign_service_provider",arguments: {
                                  'address' : widget.contractAddress![0].toString(),
                                });
                              }),
                              ],
                          ),);
                        },
                        background: Container(
                          color: Colors.redAccent,
                          child: Row(

                            children: [
                              Text(
                              'CLOSE\nCAMPAIGN',
                              style: CustomTextStyle.spaceMonoH40Bold(context),
                            ),
                            ]),
                        ),
                        key: Key(index.toString()),
                        onDismissed: (direction) {
                          setState(() {
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Campaign closed')));
                          });
                        },
                        child: Card(
                          shadowColor: Colors.blue[600],
                        color: Colors.white54,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Stack(
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topLeft,

                                      child: Column(children: <Widget>[
                                        Row(children: <Widget>[
                                          //loop
                                          (name.isEmpty) ? GlobalText.loadingText(context) :
                                           Expanded(
                                             flex: 5,
                                               child: Text(
                                                  "Name: $name",
                                                  style: CustomTextStyle.spaceMono(context)
                                                )
                                           ),
                                        ]),
                                        Row(children: <Widget>[
                                          (latitude.isEmpty) ? GlobalText.loadingText(context)
                                              : Text(
                                                  "Latitude: $latitude",
                                                  style: GoogleFonts.spaceMono(
                                                      textStyle:
                                                          const TextStyle(
                                                              color: Colors
                                                                  .black87,
                                                              letterSpacing:
                                                                  .5),
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 16),
                                                ),
                                        ]),
                                        Row(children: <Widget>[
                                          (longitude.isEmpty) ? GlobalText.loadingText(context)
                                              : Text(
                                                  "Longitude: $longitude",
                                                  style: CustomTextStyle.spaceMono(context)
                                                ),
                                        ]),

                                        Column(children: <Widget>[
                                          (readebleLocation == null)
                                              ? GlobalText.loadingText(context)
                                              : Text("Location: $readebleLocation",
                                            style: CustomTextStyle.spaceMono(context),
                                          ),
                                        ]),

                                        Row(children: <Widget>[
                                          (range.isEmpty) ? GlobalText.loadingText(context)
                                              : Text(
                                                  "Range: $range",
                                                  style: CustomTextStyle.spaceMono(context),
                                                ),
                                        ]),

                                        Row(children: <Widget>[
                                          (type.isEmpty) ? GlobalText.loadingText(context)
                                              : Text(
                                            "Type: $type",
                                            style: CustomTextStyle.spaceMono(context),
                                          ),
                                        ]),
                                      ])
                                  ),

                            ],
                          ),
                        ),
                      ),
                      );
                    }),
                      Flexible(
                        flex: 5,
                        child: Text("Sourcing Status:\nuploaded $fileCount files\nchecked $fileChecked of $fileCount\nwhit the contribution of $workersCount workers", style: CustomTextStyle.spaceMono(context),))
                    ]),
              ) :  Center(
                child:
                  Text('No active campaign at the moment...',
                    style: CustomTextStyle.spaceMono(context),
                  )
        )
    );
  }
}
