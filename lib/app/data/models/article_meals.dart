// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    String status;
    List<Result> result;

    Welcome({
        required this.status,
        required this.result,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        status: json["status"],
        result: List<Result>.from(json["result"].map((x) => Result.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "result": List<dynamic>.from(result.map((x) => x.toJson())),
    };
}

class Result {
    String name;
    int calories;
    double carbohidrates;
    double proteins;
    double fat;
    int fibres;
    int salt;
    int sugar;

    Result({
        required this.name,
        required this.calories,
        required this.carbohidrates,
        required this.proteins,
        required this.fat,
        required this.fibres,
        required this.salt,
        required this.sugar,
    });

    factory Result.fromJson(Map<String, dynamic> json) => Result(
        name: json["name"],
        calories: json["calories"],
        carbohidrates: json["carbohidrates"]?.toDouble(),
        proteins: json["proteins"]?.toDouble(),
        fat: json["fat"]?.toDouble(),
        fibres: json["fibres"],
        salt: json["salt"],
        sugar: json["sugar"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "calories": calories,
        "carbohidrates": carbohidrates,
        "proteins": proteins,
        "fat": fat,
        "fibres": fibres,
        "salt": salt,
        "sugar": sugar,
    };
}