import 'package:flutter/material.dart';
import 'package:BodyBuilding/app/modules/meals/views/meals_web_view.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../../../data/services/meals_controller.dart'; // Adjust the path as necessary

class MealsView extends StatelessWidget {
  final MealsController mealsController = Get.put(MealsController());

  MealsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
        backgroundColor: Colors.blue[800], // Warna AppBar biru
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              mealsController
                  .fetchMeals(''); // Replace '' with your desired query
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3E5FC),
              Color(0xFF1565C0),
            ],
          ),
        ),
        child: Obx(() {
          // Check if it's loading
          if (mealsController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          // If the list is empty, show a message
          if (mealsController.meals.isEmpty) {
            return const Center(child: Text('No meals found.'));
          }

          // Otherwise, show the list of meals
          return ListView.builder(
            itemCount: mealsController.meals.length,
            itemBuilder: (context, index) {
              final meal = mealsController.meals[index];

              // Ensure there is at least one result
              if (meal.result.isEmpty) {
                return const Text('No results available.');
              }

              final firstMeal = meal.result[0];

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: ListTile(
                    title: Text(firstMeal.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Calories: ${firstMeal.calories} kcal'),
                        Text('Carbohydrates: ${firstMeal.carbohidrates} g'),
                        Text('Proteins: ${firstMeal.proteins} g'),
                        Text('Fat: ${firstMeal.fat} g'),
                        Text('Fibres: ${firstMeal.fibres} g'),
                        Text('Salt: ${firstMeal.salt} g'),
                        Text('Sugar: ${firstMeal.sugar} g'),
                        const SizedBox(height: 8),
                        ElevatedButton(
                          child: const Text('LIHAT DETAIL'),
                          onPressed: () {
                            Get.to(() => MealDetailWebView(
                                url:
                                    'https://reps-id.com/beef-steak-blacky-sauce/'));
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}