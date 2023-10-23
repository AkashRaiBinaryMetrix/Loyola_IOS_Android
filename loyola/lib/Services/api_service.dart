import 'dart:convert';
import 'package:http/http.dart' as http;
import 'api_constant.dart';

class ApiService {
  Future getLogin(body) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.userLogin));
    request.fields.addAll(body);
    print("login body : $body");
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getSignup(body) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.userSignup));
    request.fields.addAll(body);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getForgetPassword(body) async {
    var request = http.MultipartRequest('POST',
        Uri.parse(ApiConstants.baseUrl + ApiConstants.userForgetPassword));
    request.fields.addAll(body);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getLogout(body) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.userLogout));
    request.fields.addAll(body);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future changePasswordApi(body) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.changePassword));
    request.fields.addAll(body);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getProfile(int userID) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.getProfile));
    request.fields.addAll({
      "user_id": userID.toString(),
    });
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future updateProfile(body) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.updateProfile));
    request.fields.addAll(body);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getDashboard(body) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.dashboard));
    request.fields.addAll(body);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getUpcomingSurvey(body) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.upcomingSurvey));
    request.fields.addAll(body);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getNewSurvey(body) async {
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.newSurvey));
    request.fields.addAll(body);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getCategory() async {
    var request = http.Request(
        'GET', Uri.parse(ApiConstants.baseUrl + ApiConstants.surveyCategory));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getSurveyList(body) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'GET', Uri.parse(ApiConstants.baseUrl + ApiConstants.surveyLists));
    request.body = json.encode(body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }

    //  var headers = {'Content-Type': 'text/plain'};
    //  var request = http.Request(
    //      'GET', Uri.parse(ApiConstants.baseUrl + ApiConstants.surveyLists));
    //  request.body = json.encode({"category_id":"1",
    //  "type":"new"});
    //  // request.body = json.encode({
    //  //   "category_id":"1",
    //  //   "type":"new"
    //  // });
    // //
    //  // request.fields.addAll(body);
    //  print("survey body $body");
    //  request.headers.addAll(headers);
    //  http.StreamedResponse response = await request.send();
    //  if (response.statusCode == 200) {
    //    return json.decode(await response.stream.bytesToString());
    //  } else {
    //    print(response.reasonPhrase);
    //  }
  }

  Future getSurveyQuestionsList(int serveyId, String userId) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('GET',
        Uri.parse(ApiConstants.baseUrl + ApiConstants.surveyQuestionList));
    request.body = json.encode(
        {"survey_id": serveyId.toString(), "user_id": userId.toString()});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getNotificationList(int userId) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'GET', Uri.parse(ApiConstants.baseUrl + ApiConstants.notification));
    request.body = json.encode({"user_id": userId.toString()});
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getSetting() async {
    var request = http.Request(
        'GET', Uri.parse(ApiConstants.baseUrl + ApiConstants.setting));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future submitFeedback(body) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.submitFeedback));
    request.body = json.encode(body);
    print("Save Feedback body $body");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //  print(response.stream.bytesToString());
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getFeedback(body) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.getFeedback));
    request.body = json.encode(body);
    print("get Feedback body $body");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
       // print(response.stream.bytesToString());
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future getSurveyHistoryList(body) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request('GET',
        Uri.parse(ApiConstants.baseUrl + ApiConstants.surveyHistoryList));
    request.body = json.encode(body);
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }

  Future saveSurvey(body) async {
    var headers = {'Content-Type': 'application/json'};
    var request = http.Request(
        'POST', Uri.parse(ApiConstants.baseUrl + ApiConstants.saveSurvey));
    request.body = json.encode(body);
    print("Save Survey body $body");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      //  print(response.stream.bytesToString());
      return json.decode(await response.stream.bytesToString());
    } else {
      print(response.reasonPhrase);
    }
  }
}
