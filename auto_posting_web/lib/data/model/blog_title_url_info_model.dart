class BlogTitleUrlInfoModel {
  final String posting_title;
  final String url;

  const BlogTitleUrlInfoModel({required this.posting_title, required this.url});

  BlogTitleUrlInfoModel copyWith({String? posting_title, String? url}) {
    return BlogTitleUrlInfoModel(
      posting_title: posting_title ?? this.posting_title,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toJson() => {"posting_title": posting_title, "url": url};
}
