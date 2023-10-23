class ApiConstants {
  static String baseUrl = 'https://binarymetrix-dev.com/loyola/api/';
  static Map header = {'Content-Type': 'application/json'};
  static String userLogin = 'user/login';
  static String userSignup = 'user/signup';
  static String userLogout = 'user/logout';
  static String userForgetPassword = 'user/forgetpassword';
  static String changePassword = 'user/change_password';
  static String getProfile = 'user/profile';
  static String updateProfile = 'user/updateprofile';
  static String dashboard = 'user/dashboard_v1';
  static String upcomingSurvey = 'user/upcoming_survey';
  static String newSurvey = 'user/new_survey';
  static String surveyList = 'user/surveys';
  static String surveyLists = 'survey/list_v2';
  static String submitFeedback = 'user/savefeedback';
  static String surveyHistoryList = 'user/survey_history_v1';
  static String saveSurvey = 'user/save_survey_v1';
  static String surveyCategory = 'survey/category';
  static String surveyQuestionList = 'survey/question_v2';
  static String notification = 'user/notification';
  static String setting = 'setting';
  static String getFeedback='user/userfeedback';
}
