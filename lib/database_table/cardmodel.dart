class CardModel {
  final String image;
  final int id; // Unique identifier for matching
  bool isFlipped; // To track if the card is flipped

  CardModel({
    required this.image,
    required this.id,
    this.isFlipped = false,
  });
}

