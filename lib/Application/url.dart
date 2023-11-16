const url = 'https://quizvolutiontech.000webhostapp.com/_newCategoryID_.json';
const categoryPlaceholder = '_newCategoryID_';
String getCategoryURL(String category) {
  return url.replaceAll(categoryPlaceholder, category);
}

const baseURL = "http://localhost:10000";
const categoryEndPoint = "/api/v1/quiz";
const questionsEndPoint = "/api/v1/question/";
const historyEndPoint = "/api/v1/history/";
const userEndPoint = "/api/v1/user/";