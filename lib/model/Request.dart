class RequestModel {
  int id;
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
  String created_date = '';
  String close_date = '';
  String last_updated_date = '';
  String status = '';
  int status_id;

  RequestModel(
      {this.id,
      this.subject,
      this.description,
      this.service,
      this.subservice,
      this.status,
      this.files,
      this.location_id,
      this.mobile,
      this.requester,
      this.serviceDesc,
      this.subserviceDesc,
      this.created_date,
      this.close_date,
      this.last_updated_date,
      this.status_id});
}
