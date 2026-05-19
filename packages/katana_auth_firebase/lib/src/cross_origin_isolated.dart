// Copyright (c) 2025 mathru. All rights reserved.

/// Whether the current execution context is cross-origin isolated.
///
/// Always returns `false` on non-web platforms.
///
/// 現在の実行コンテキストがクロスオリジン分離されているかどうか。
///
/// Web以外のプラットフォームでは常に`false`を返します。
bool get isCrossOriginIsolated => false;
