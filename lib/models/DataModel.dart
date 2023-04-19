class DataModel {
  String? name;
  String? customer_id;
  int? id;
  String? project_name;
  String? project_id;
  String? site_name;
  String? site_id;
  String? proj_start_date;
  String? latitude;
  String? longitude;
  String? site_address;


  DataModel({this.name, this.customer_id, this.id, this.project_name,this.project_id,this.site_name,
    this.site_id,this.proj_start_date,this.latitude,this.longitude,this.site_address
  });

  DataModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    customer_id = json['customer_id'];
    id = json['id'];
    project_name = json['project_name'];
    project_id = json['project_id'];
    site_name = json['site_name'];
    site_id = json['site_id'];
    proj_start_date = json['proj_start_date'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    site_address = json['site_address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['customer_id'] = customer_id;
    data['id'] = id;
    data['project_name'] = project_name;
    data['project_id'] = project_id;
    data['site_name'] = site_name;
    data['site_id'] = site_id;
    data['proj_start_date'] = proj_start_date;
    data['latitude'] = latitude;
    data['longitude'] = longitude;
    data['site_address'] = site_address;
    return data;
  }
}
