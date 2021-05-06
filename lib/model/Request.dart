class RequestModel {
  String id;
  String subject;
  String description;
  String service;
  String subservice;
  List<String> files = [];

  RequestModel(
      {this.subject,
      this.description,
      this.service,
      this.subservice,
      this.files});
}
