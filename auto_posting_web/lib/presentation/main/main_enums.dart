enum DistributionType { auto, manual }

enum PostType { commercial, informative }

enum CreatePostType { title, url }

enum BlogInsertType { single, multi }

enum AIPhotoType {
  photoRealistic,
  digitalArt,
  minimalist,
  oilPainting,
  pixelArt,
  anime,
}

extension AIPhotoTypeExtension on AIPhotoType {
  String get label {
    switch (this) {
      case AIPhotoType.photoRealistic:
        return 'Photorealistic: 실제 사진 스타일';
      case AIPhotoType.digitalArt:
        return 'Digital Art: 일러스트/그래픽';
      case AIPhotoType.minimalist:
        return 'Minimalist: 현대적 디자인';
      case AIPhotoType.oilPainting:
        return 'Oil Painting: 유화 느낌';
      case AIPhotoType.pixelArt:
        return 'Pixel Art: 도트 그래픽';
      case AIPhotoType.anime:
        return 'Anime/Manga: 만화 스타일';
    }
  }
}

enum PostingType { immediately, reservation }
