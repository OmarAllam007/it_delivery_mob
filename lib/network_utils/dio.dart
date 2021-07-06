import 'package:http/http.dart' as http;

var baseUrl = 'http://192.168.0.8:8080/api/v1/';

Future<http.Response> httpGet({token, String url}) {
  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    if (token != '' && token != null) 'Authorization': "Bearer " + token
  };

  var fullUrl = baseUrl + url;

  return http.get(
      Uri.parse(
        fullUrl,
      ),
      headers: requestHeaders);
}

Future<http.Response> httpPost({token, String url, data}) {
  Map<String, String> requestHeaders = {
    // 'Content-type': 'application/json',
    // 'Accept': 'application/json',
    if (token != '' && token != null) 'Authorization': "Bearer " + token
  };

  // if (token != '' && token != null) {
  //   headers['Authorization'] = "Bearer " + token;
  // }

  var fullUrl = baseUrl + url;

  return http.post(
      Uri.parse(
        fullUrl,
      ),
      headers: requestHeaders,
      body: data);
}

Future<void> httpPostMultipart({token, String url, data}) {
  // headers['accept'] = 'application/json';

  // if (token != '' && token != null) {
  //   headers['Authorization'] = "Bearer " + token;
  // }

  // var fullUrl = baseUrl + url;

  // var request = http.MultipartRequest(
  //   "POST",
  //   Uri.parse(
  //     fullUrl,
  //   ),
  // );

  // request.fields['subject'] = data['subject'];
  // request.fields['service_id'] = data['service'];
  // request.fields['subservice_id'] = data['subservice'];
  // request.fields['description'] = data['description'];
  // request.fields['location_id'] = data['location_id'];
  // request.fields['mobile'] = data['mobile'];

  // request.send().then((response) => print(response));
}
