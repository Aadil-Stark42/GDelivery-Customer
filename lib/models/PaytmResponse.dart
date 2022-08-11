class PaytmResponse {
  String? cURRENCY;
  String? gATEWAYNAME;
  String? rESPMSG;
  String? pAYMENTMODE;
  String? mID;
  String? rESPCODE;
  String? tXNAMOUNT;
  String? tXNID;
  String? oRDERID;
  String? sTATUS;
  String? bANKTXNID;
  String? tXNDATE;
  String? cHECKSUMHASH;

  PaytmResponse(
      {this.cURRENCY,
      this.gATEWAYNAME,
      this.rESPMSG,
      this.pAYMENTMODE,
      this.mID,
      this.rESPCODE,
      this.tXNAMOUNT,
      this.tXNID,
      this.oRDERID,
      this.sTATUS,
      this.bANKTXNID,
      this.tXNDATE,
      this.cHECKSUMHASH});

  PaytmResponse.fromJson(Map<dynamic, dynamic> json) {
    cURRENCY = json['CURRENCY'];
    gATEWAYNAME = json['GATEWAYNAME'];
    rESPMSG = json['RESPMSG'];
    pAYMENTMODE = json['PAYMENTMODE'];
    mID = json['MID'];
    rESPCODE = json['RESPCODE'];
    tXNAMOUNT = json['TXNAMOUNT'];
    tXNID = json['TXNID'];
    oRDERID = json['ORDERID'];
    sTATUS = json['STATUS'];
    bANKTXNID = json['BANKTXNID'];
    tXNDATE = json['TXNDATE'];
    cHECKSUMHASH = json['CHECKSUMHASH'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CURRENCY'] = this.cURRENCY;
    data['GATEWAYNAME'] = this.gATEWAYNAME;
    data['RESPMSG'] = this.rESPMSG;
    data['PAYMENTMODE'] = this.pAYMENTMODE;
    data['MID'] = this.mID;
    data['RESPCODE'] = this.rESPCODE;
    data['TXNAMOUNT'] = this.tXNAMOUNT;
    data['TXNID'] = this.tXNID;
    data['ORDERID'] = this.oRDERID;
    data['STATUS'] = this.sTATUS;
    data['BANKTXNID'] = this.bANKTXNID;
    data['TXNDATE'] = this.tXNDATE;
    data['CHECKSUMHASH'] = this.cHECKSUMHASH;
    return data;
  }
}
