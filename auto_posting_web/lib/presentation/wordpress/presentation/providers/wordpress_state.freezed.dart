// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wordpress_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$WordpressState {
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isRunning => throw _privateConstructorUsedError; // 작업 실행 여부
  List<String> get logs => throw _privateConstructorUsedError; // SSE 로그 리스트
  String get siteUrl => throw _privateConstructorUsedError;
  String get adminId => throw _privateConstructorUsedError;
  String get adminPassword => throw _privateConstructorUsedError;
  String get adSenseCode => throw _privateConstructorUsedError;
  bool get buttonPage => throw _privateConstructorUsedError;
  String get buttonPageUrl => throw _privateConstructorUsedError;
  String get buttonPageId => throw _privateConstructorUsedError;
  String get buttonPagePw => throw _privateConstructorUsedError;
  List<Content> get contents => throw _privateConstructorUsedError;
  String? get errorMessage => throw _privateConstructorUsedError;

  /// Create a copy of WordpressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WordpressStateCopyWith<WordpressState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WordpressStateCopyWith<$Res> {
  factory $WordpressStateCopyWith(
    WordpressState value,
    $Res Function(WordpressState) then,
  ) = _$WordpressStateCopyWithImpl<$Res, WordpressState>;
  @useResult
  $Res call({
    bool isLoading,
    bool isRunning,
    List<String> logs,
    String siteUrl,
    String adminId,
    String adminPassword,
    String adSenseCode,
    bool buttonPage,
    String buttonPageUrl,
    String buttonPageId,
    String buttonPagePw,
    List<Content> contents,
    String? errorMessage,
  });
}

/// @nodoc
class _$WordpressStateCopyWithImpl<$Res, $Val extends WordpressState>
    implements $WordpressStateCopyWith<$Res> {
  _$WordpressStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WordpressState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isRunning = null,
    Object? logs = null,
    Object? siteUrl = null,
    Object? adminId = null,
    Object? adminPassword = null,
    Object? adSenseCode = null,
    Object? buttonPage = null,
    Object? buttonPageUrl = null,
    Object? buttonPageId = null,
    Object? buttonPagePw = null,
    Object? contents = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _value.copyWith(
            isLoading: null == isLoading
                ? _value.isLoading
                : isLoading // ignore: cast_nullable_to_non_nullable
                      as bool,
            isRunning: null == isRunning
                ? _value.isRunning
                : isRunning // ignore: cast_nullable_to_non_nullable
                      as bool,
            logs: null == logs
                ? _value.logs
                : logs // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            siteUrl: null == siteUrl
                ? _value.siteUrl
                : siteUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            adminId: null == adminId
                ? _value.adminId
                : adminId // ignore: cast_nullable_to_non_nullable
                      as String,
            adminPassword: null == adminPassword
                ? _value.adminPassword
                : adminPassword // ignore: cast_nullable_to_non_nullable
                      as String,
            adSenseCode: null == adSenseCode
                ? _value.adSenseCode
                : adSenseCode // ignore: cast_nullable_to_non_nullable
                      as String,
            buttonPage: null == buttonPage
                ? _value.buttonPage
                : buttonPage // ignore: cast_nullable_to_non_nullable
                      as bool,
            buttonPageUrl: null == buttonPageUrl
                ? _value.buttonPageUrl
                : buttonPageUrl // ignore: cast_nullable_to_non_nullable
                      as String,
            buttonPageId: null == buttonPageId
                ? _value.buttonPageId
                : buttonPageId // ignore: cast_nullable_to_non_nullable
                      as String,
            buttonPagePw: null == buttonPagePw
                ? _value.buttonPagePw
                : buttonPagePw // ignore: cast_nullable_to_non_nullable
                      as String,
            contents: null == contents
                ? _value.contents
                : contents // ignore: cast_nullable_to_non_nullable
                      as List<Content>,
            errorMessage: freezed == errorMessage
                ? _value.errorMessage
                : errorMessage // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$WordpressStateImplCopyWith<$Res>
    implements $WordpressStateCopyWith<$Res> {
  factory _$$WordpressStateImplCopyWith(
    _$WordpressStateImpl value,
    $Res Function(_$WordpressStateImpl) then,
  ) = __$$WordpressStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool isLoading,
    bool isRunning,
    List<String> logs,
    String siteUrl,
    String adminId,
    String adminPassword,
    String adSenseCode,
    bool buttonPage,
    String buttonPageUrl,
    String buttonPageId,
    String buttonPagePw,
    List<Content> contents,
    String? errorMessage,
  });
}

/// @nodoc
class __$$WordpressStateImplCopyWithImpl<$Res>
    extends _$WordpressStateCopyWithImpl<$Res, _$WordpressStateImpl>
    implements _$$WordpressStateImplCopyWith<$Res> {
  __$$WordpressStateImplCopyWithImpl(
    _$WordpressStateImpl _value,
    $Res Function(_$WordpressStateImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WordpressState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isLoading = null,
    Object? isRunning = null,
    Object? logs = null,
    Object? siteUrl = null,
    Object? adminId = null,
    Object? adminPassword = null,
    Object? adSenseCode = null,
    Object? buttonPage = null,
    Object? buttonPageUrl = null,
    Object? buttonPageId = null,
    Object? buttonPagePw = null,
    Object? contents = null,
    Object? errorMessage = freezed,
  }) {
    return _then(
      _$WordpressStateImpl(
        isLoading: null == isLoading
            ? _value.isLoading
            : isLoading // ignore: cast_nullable_to_non_nullable
                  as bool,
        isRunning: null == isRunning
            ? _value.isRunning
            : isRunning // ignore: cast_nullable_to_non_nullable
                  as bool,
        logs: null == logs
            ? _value._logs
            : logs // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        siteUrl: null == siteUrl
            ? _value.siteUrl
            : siteUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        adminId: null == adminId
            ? _value.adminId
            : adminId // ignore: cast_nullable_to_non_nullable
                  as String,
        adminPassword: null == adminPassword
            ? _value.adminPassword
            : adminPassword // ignore: cast_nullable_to_non_nullable
                  as String,
        adSenseCode: null == adSenseCode
            ? _value.adSenseCode
            : adSenseCode // ignore: cast_nullable_to_non_nullable
                  as String,
        buttonPage: null == buttonPage
            ? _value.buttonPage
            : buttonPage // ignore: cast_nullable_to_non_nullable
                  as bool,
        buttonPageUrl: null == buttonPageUrl
            ? _value.buttonPageUrl
            : buttonPageUrl // ignore: cast_nullable_to_non_nullable
                  as String,
        buttonPageId: null == buttonPageId
            ? _value.buttonPageId
            : buttonPageId // ignore: cast_nullable_to_non_nullable
                  as String,
        buttonPagePw: null == buttonPagePw
            ? _value.buttonPagePw
            : buttonPagePw // ignore: cast_nullable_to_non_nullable
                  as String,
        contents: null == contents
            ? _value._contents
            : contents // ignore: cast_nullable_to_non_nullable
                  as List<Content>,
        errorMessage: freezed == errorMessage
            ? _value.errorMessage
            : errorMessage // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc

class _$WordpressStateImpl implements _WordpressState {
  const _$WordpressStateImpl({
    this.isLoading = false,
    this.isRunning = false,
    final List<String> logs = const [],
    this.siteUrl = '',
    this.adminId = '',
    this.adminPassword = '',
    this.adSenseCode = '',
    this.buttonPage = false,
    this.buttonPageUrl = '',
    this.buttonPageId = '',
    this.buttonPagePw = '',
    final List<Content> contents = const [],
    this.errorMessage,
  }) : _logs = logs,
       _contents = contents;

  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isRunning;
  // 작업 실행 여부
  final List<String> _logs;
  // 작업 실행 여부
  @override
  @JsonKey()
  List<String> get logs {
    if (_logs is EqualUnmodifiableListView) return _logs;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_logs);
  }

  // SSE 로그 리스트
  @override
  @JsonKey()
  final String siteUrl;
  @override
  @JsonKey()
  final String adminId;
  @override
  @JsonKey()
  final String adminPassword;
  @override
  @JsonKey()
  final String adSenseCode;
  @override
  @JsonKey()
  final bool buttonPage;
  @override
  @JsonKey()
  final String buttonPageUrl;
  @override
  @JsonKey()
  final String buttonPageId;
  @override
  @JsonKey()
  final String buttonPagePw;
  final List<Content> _contents;
  @override
  @JsonKey()
  List<Content> get contents {
    if (_contents is EqualUnmodifiableListView) return _contents;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_contents);
  }

  @override
  final String? errorMessage;

  @override
  String toString() {
    return 'WordpressState(isLoading: $isLoading, isRunning: $isRunning, logs: $logs, siteUrl: $siteUrl, adminId: $adminId, adminPassword: $adminPassword, adSenseCode: $adSenseCode, buttonPage: $buttonPage, buttonPageUrl: $buttonPageUrl, buttonPageId: $buttonPageId, buttonPagePw: $buttonPagePw, contents: $contents, errorMessage: $errorMessage)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WordpressStateImpl &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isRunning, isRunning) ||
                other.isRunning == isRunning) &&
            const DeepCollectionEquality().equals(other._logs, _logs) &&
            (identical(other.siteUrl, siteUrl) || other.siteUrl == siteUrl) &&
            (identical(other.adminId, adminId) || other.adminId == adminId) &&
            (identical(other.adminPassword, adminPassword) ||
                other.adminPassword == adminPassword) &&
            (identical(other.adSenseCode, adSenseCode) ||
                other.adSenseCode == adSenseCode) &&
            (identical(other.buttonPage, buttonPage) ||
                other.buttonPage == buttonPage) &&
            (identical(other.buttonPageUrl, buttonPageUrl) ||
                other.buttonPageUrl == buttonPageUrl) &&
            (identical(other.buttonPageId, buttonPageId) ||
                other.buttonPageId == buttonPageId) &&
            (identical(other.buttonPagePw, buttonPagePw) ||
                other.buttonPagePw == buttonPagePw) &&
            const DeepCollectionEquality().equals(other._contents, _contents) &&
            (identical(other.errorMessage, errorMessage) ||
                other.errorMessage == errorMessage));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isLoading,
    isRunning,
    const DeepCollectionEquality().hash(_logs),
    siteUrl,
    adminId,
    adminPassword,
    adSenseCode,
    buttonPage,
    buttonPageUrl,
    buttonPageId,
    buttonPagePw,
    const DeepCollectionEquality().hash(_contents),
    errorMessage,
  );

  /// Create a copy of WordpressState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WordpressStateImplCopyWith<_$WordpressStateImpl> get copyWith =>
      __$$WordpressStateImplCopyWithImpl<_$WordpressStateImpl>(
        this,
        _$identity,
      );
}

abstract class _WordpressState implements WordpressState {
  const factory _WordpressState({
    final bool isLoading,
    final bool isRunning,
    final List<String> logs,
    final String siteUrl,
    final String adminId,
    final String adminPassword,
    final String adSenseCode,
    final bool buttonPage,
    final String buttonPageUrl,
    final String buttonPageId,
    final String buttonPagePw,
    final List<Content> contents,
    final String? errorMessage,
  }) = _$WordpressStateImpl;

  @override
  bool get isLoading;
  @override
  bool get isRunning; // 작업 실행 여부
  @override
  List<String> get logs; // SSE 로그 리스트
  @override
  String get siteUrl;
  @override
  String get adminId;
  @override
  String get adminPassword;
  @override
  String get adSenseCode;
  @override
  bool get buttonPage;
  @override
  String get buttonPageUrl;
  @override
  String get buttonPageId;
  @override
  String get buttonPagePw;
  @override
  List<Content> get contents;
  @override
  String? get errorMessage;

  /// Create a copy of WordpressState
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WordpressStateImplCopyWith<_$WordpressStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
mixin _$Content {
  String get title => throw _privateConstructorUsedError;
  String get buttonUrl => throw _privateConstructorUsedError;

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ContentCopyWith<Content> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ContentCopyWith<$Res> {
  factory $ContentCopyWith(Content value, $Res Function(Content) then) =
      _$ContentCopyWithImpl<$Res, Content>;
  @useResult
  $Res call({String title, String buttonUrl});
}

/// @nodoc
class _$ContentCopyWithImpl<$Res, $Val extends Content>
    implements $ContentCopyWith<$Res> {
  _$ContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? buttonUrl = null}) {
    return _then(
      _value.copyWith(
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            buttonUrl: null == buttonUrl
                ? _value.buttonUrl
                : buttonUrl // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ContentImplCopyWith<$Res> implements $ContentCopyWith<$Res> {
  factory _$$ContentImplCopyWith(
    _$ContentImpl value,
    $Res Function(_$ContentImpl) then,
  ) = __$$ContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String title, String buttonUrl});
}

/// @nodoc
class __$$ContentImplCopyWithImpl<$Res>
    extends _$ContentCopyWithImpl<$Res, _$ContentImpl>
    implements _$$ContentImplCopyWith<$Res> {
  __$$ContentImplCopyWithImpl(
    _$ContentImpl _value,
    $Res Function(_$ContentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? title = null, Object? buttonUrl = null}) {
    return _then(
      _$ContentImpl(
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        buttonUrl: null == buttonUrl
            ? _value.buttonUrl
            : buttonUrl // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc

class _$ContentImpl implements _Content {
  const _$ContentImpl({required this.title, this.buttonUrl = ''});

  @override
  final String title;
  @override
  @JsonKey()
  final String buttonUrl;

  @override
  String toString() {
    return 'Content(title: $title, buttonUrl: $buttonUrl)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ContentImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.buttonUrl, buttonUrl) ||
                other.buttonUrl == buttonUrl));
  }

  @override
  int get hashCode => Object.hash(runtimeType, title, buttonUrl);

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ContentImplCopyWith<_$ContentImpl> get copyWith =>
      __$$ContentImplCopyWithImpl<_$ContentImpl>(this, _$identity);
}

abstract class _Content implements Content {
  const factory _Content({
    required final String title,
    final String buttonUrl,
  }) = _$ContentImpl;

  @override
  String get title;
  @override
  String get buttonUrl;

  /// Create a copy of Content
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ContentImplCopyWith<_$ContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
