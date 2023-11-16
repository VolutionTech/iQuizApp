class QuestionService {


  fetchQuestions(String quizId) async {
    print(baseURL+questionsEndPoint+quizId);
    final response = await http.get(Uri.parse(baseURL+questionsEndPoint+quizId));
    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body)['data'];
      var data = jsonData.map((question) => QuizQuestion.fromJson(question)).toList();
      quizData.value = data;
    } else {
      throw Exception('Failed to load questions ' + response.body.toString());
    }
  }

}