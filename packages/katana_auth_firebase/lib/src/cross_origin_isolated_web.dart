// Copyright (c) 2025 mathru. All rights reserved.

// Dart imports:
import "dart:js_interop";

@JS("crossOriginIsolated")
external JSBoolean? get _crossOriginIsolated;

/// Whether the current execution context is cross-origin isolated.
///
/// Reflects the value of `globalThis.crossOriginIsolated`. When cross-origin
/// isolation is enabled (e.g. Wasm builds served with `Cross-Origin-Opener-Policy`
/// and `Cross-Origin-Embedder-Policy` headers), popup-based sign-in is broken by
/// COOP and a redirect-based flow must be used instead.
///
/// 現在の実行コンテキストがクロスオリジン分離されているかどうか。
///
/// `globalThis.crossOriginIsolated`の値を反映します。クロスオリジン分離が有効な場合
/// （`Cross-Origin-Opener-Policy`・`Cross-Origin-Embedder-Policy`ヘッダー付きで配信される
/// Wasmビルド等）、ポップアップによるサインインはCOOPにより機能しないため、
/// リダイレクト方式を利用する必要があります。
bool get isCrossOriginIsolated => _crossOriginIsolated?.toDart ?? false;
