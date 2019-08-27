class Match {
  int kod;
  String takim1;
  String takim2;
  String tarih;
  String ulke;
  String saat;
  String spor;
  double oran;
  String tahmin;
  String tur;
  String guven;
  String durum;

  Match(
      {this.kod,
      this.takim1,
      this.takim2,
      this.tarih,
      this.ulke,
      this.saat,
      this.spor,
      this.oran,
      this.tahmin,
      this.tur,
      this.guven,
      this.durum});

  Match.fromJson(Map<String, dynamic> json) {
    kod = json['kod'];
    takim1 = json['takim1'];
    takim2 = json['takim2'];
    tarih = json['tarih'];
    ulke = json['ulke'];
    saat = json['saat'];
    spor = json['spor'];
    oran = double.parse(json['oran']);
    tahmin = json['tahmin'];
    tur = json['tur'];
    guven = json['guven'];
    durum = json['durum'];
  }
  Match.fromJsonLive(Map<String,dynamic> json){
    takim1 = json['takim1'];
    takim2 = json['takim2'];
    ulke = json['ulke'];
    spor = json['spor'];
    tahmin = json['tahmin'];
    tur = json['tur'];
    guven = json['guven'];
    durum = json['durum'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['kod'] = this.kod;
    data['takim1'] = this.takim1;
    data['takim2'] = this.takim2;
    data['tarih'] = this.tarih;
    data['ulke'] = this.ulke;
    data['saat'] = this.saat;
    data['spor'] = this.spor;
    data['oran'] = this.oran;
    data['tahmin'] = this.tahmin;
    data['tur'] = this.tur;
    data['guven'] = this.guven;
    data['durum'] = this.durum;
    return data;
  }
}