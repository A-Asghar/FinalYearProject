import 'package:fyp/repository/AccessTokenRepository.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../Constants.dart';
import '../Providers/AccessTokenProvider.dart';

class FlightNetwork{

  flightOffersSearch(
      originLocationCode, // KHI
      destinationLocationCode, // DXB
      departureDate, // 2022-09-25
      returnDate, // 2022-09-27
      adults, // 1
      nonStop, // false
      travelClass, // Available values : ECONOMY, PREMIUM_ECONOMY, BUSINESS, FIRST
      maxPrice,
      ) async {
    final AccessTokenProvider controller = Get.put(AccessTokenProvider());
    AccessTokenRepository accessTokenRepository = AccessTokenRepository();

    final url = Uri.parse(
        'https://${Constants.uri}${Constants.flightSearch}?originLocationCode=$originLocationCode&destinationLocationCode=$destinationLocationCode&departureDate=$departureDate&adults=$adults${returnDate == '' ? '' : '&returnDate=$returnDate'}');

    var response = await http.get(
      url,
      headers: {
        "Authorization": 'Bearer ${controller.accessToken?.accessToken}',
        "accept": 'application/vnd.amadeus+json',
      },
    );

    print('Network Response status: ${response.statusCode}');
    // print('Network Response body: ${response.body}');

    if (response.statusCode == 401) {
      // print('Network Error: ');

      await accessTokenRepository.getAccessToken(getNew: true);

      response = await http.get(
        url,
        headers: {
          "Authorization": 'Bearer ${controller.accessToken?.accessToken}',
          "accept": 'application/vnd.amadeus+json',
        },
      );
    }

    return response.body;
  }

  getAccessToken() async {
    var url = Uri.https(Constants.uri, '/v1/security/oauth2/token');
    var response = await http.post(url, body: {
      'grant_type': 'client_credentials',
      'client_id': 'CF9FfomFYGbFUVGG15igLgdiGtapSK1g',
      'client_secret': 'XgukiYQGMPtShAMT',
    });
    return response;
  }
}