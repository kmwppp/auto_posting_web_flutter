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

/// 1. 프록시 설정을 정말 안할건지
/// 2. 계정이 추가되지 않았을때
/// 3. 계정이 추가되었고, 수동 분배일 때 갯수가 0개인 userInfo가 있을때
/// 4. 계정이 추가되었고, 프록시가 ON이며, proxyInfo가 비어있을 때,
/// 5. 워드프레스 사이트 URL이 아무것도 적혀 있지 않을 때
/// 6. 블로그 메인 키워드 및 제목 리스트가 0일 때
/// 7. 글쓰기 지침이 비어 있을 때
/// 8. 발행 주기가 비어 있을 때
