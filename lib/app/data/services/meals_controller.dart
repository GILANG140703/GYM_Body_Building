import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article_meals.dart';

class MealsController extends GetxController {
  var meals = <Welcome>[].obs; // Observable list of Meals objects
  var isLoading = true.obs; // Observable loading state

  Future<void> fetchMeals(String query) async {
    const String url = 'https://nutritional-data.p.rapidapi.com/';
    final Map<String, String> headers = {
      'X-RapidAPI-Key': '6b032a413bmsh622e2133d47e849p10aa3ajsn77649961ce77',
      'X-RapidAPI-Host': 'nutritional-data.p.rapidapi.com', // Fixed host
      'Content-Type': 'application/json',
    };

    try {
      isLoading(true); // Set loading to true
      final response =
          await http.get(Uri.parse('$url$query'), headers: headers);

      if (response.statusCode == 200) {
        // Check if the response body is not empty or null
        if (response.body.isNotEmpty) {
          final data = json.decode(response.body);

          // Assuming the response is a JSON object with a key 'result'
          meals.value = [Welcome.fromJson(data)];
        } else {
          throw Exception('Empty response body');
        }
      } else {
        throw Exception('Failed to load meals data');
      }
    } catch (e) {
      print('Error: $e');
    } finally {
      isLoading(false); // Set loading to false
    }
  }
}
