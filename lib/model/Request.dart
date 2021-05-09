class RequestModel {
  String id;
  String subject;
  String description;
  String service;
  String subservice;
  List<String> files = [];
  String location_id;
  String mobile;
  String serviceDesc = '';
  String subserviceDesc = '';
  String requester = '';

  RequestModel(
      {this.subject,
      this.description,
      this.service,
      this.subservice,
      this.files,
      this.location_id,
      this.mobile,
      this.requester,
      this.serviceDesc,
      this.subserviceDesc});
}
