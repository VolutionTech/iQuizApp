const url = 'https://quizvolutiontech.000webhostapp.com/_newCategoryID_.json';
const categoryPlaceholder = '_newCategoryID_';
String getCategoryURL(String category) {
  return url.replaceAll(categoryPlaceholder, category);
}

const baseURL = "http://localhost:10000";
// const baseURL = "http://iquiz.eu-north-1.elasticbeanstalk.com";
const quizEndPoint = "/api/v1/quiz";
const categoryEndPoint = "/api/v1/category";
const reportEndPoint = "/api/v1/report";
const questionsEndPoint = "/api/v1/question/";
const historyEndPoint = "/api/v1/history/";
const singleHistoryEndPoint = "/api/v1/history/single/";
const userEndPoint = "/api/v1/user/";
