import 'dart:convert';

ReportResponse welcomeFromJson(String str) => ReportResponse.fromJson(json.decode(str));

String welcomeToJson(ReportResponse data) => json.encode(data.toJson());

class ReportResponse {
    bool status;
    List<Datum> data;

    ReportResponse({
        required this.status,
        required this.data,
    });

    factory ReportResponse.fromJson(Map<String, dynamic> json) => ReportResponse(
        status: json["status"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
    };
}

class Datum {
    String model;
    int pk;
    Report fields;

    Datum({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        model: json["model"],
        pk: json["pk"],
        fields: Report.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Report {
    String food;
    int reportedBy;
    String issueType;
    String description;
    DateTime createdAt;
    String status;

    Report({
        required this.food,
        required this.reportedBy,
        required this.issueType,
        required this.description,
        required this.createdAt,
        required this.status,
    });

    factory Report.fromJson(Map<String, dynamic> json) => Report(
        food: json["food"],
        reportedBy: json["reported_by"],
        issueType: json["issue_type"],
        description: json["description"],
        createdAt: DateTime.parse(json["created_at"]),
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "food": food,
        "reported_by": reportedBy,
        "issue_type": issueType,
        "description": description,
        "created_at": createdAt.toIso8601String(),
        "status": status,
    };
}