const url = 'https://quizvolutiontech.000webhostapp.com/_newCategoryID_.json';
const categoryPlaceholder = '_newCategoryID_';
String getCategoryURL(String category) {
  return url.replaceAll(categoryPlaceholder, category);
}

const baseURL = "https://iquiz.onrender.com";
const fetchCategoryEndPoint = "/api/v1/quiz";