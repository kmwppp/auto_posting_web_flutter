class BlogTitleInfoModel {
  final String main_keyword;
  final String posting_title;

  const BlogTitleInfoModel({
    required this.main_keyword,
    required this.posting_title,
  });

  BlogTitleInfoModel copyWith({bool? isPostingCheck, String? userId}) {
    return BlogTitleInfoModel(
      main_keyword: userId ?? this.main_keyword,
      posting_title: posting_title ?? this.posting_title,
    );
  }

  Map<String, dynamic> toJson() => {
    "main_keyword": main_keyword,
    "posting_title": posting_title,
  };
}
