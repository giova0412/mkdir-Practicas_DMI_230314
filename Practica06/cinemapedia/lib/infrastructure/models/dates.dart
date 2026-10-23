class Dates {
    Dates({
        required this.maximum,
        required this.minimum,
    });

    final String maximum;
    final String minimum;

    factory Dates.fromJson(Map<String, dynamic> json) => Dates(
        maximum: json["maximum"] ?? "",
        minimum: json["minimum"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "maximum": maximum,
        "minimum": minimum,
    };
}
