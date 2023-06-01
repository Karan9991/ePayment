class Receipt {

  String? finalReceiptPhoto;
  String? originalReceiptPhoto;
  String? refNo;
  DateTime? createdAt;

  Receipt(
      this.finalReceiptPhoto,
      this.originalReceiptPhoto,
      this.refNo,
      this.createdAt,
      );
  Receipt.fromJson(Map<String, dynamic> parsedJSON){
     finalReceiptPhoto = parsedJSON['FinalReceiptPhotoLink'];
     originalReceiptPhoto = parsedJSON['OriginalReceiptPhotoLink'];
     refNo = parsedJSON['refNo'];
     createdAt = parsedJSON['createdAt'].toDate();

  }

}

