## 3.2.0

 - **FEAT**: record experiment exposures in analytics ([626cbfae](https://github.com/mathrunet/flutter_masamune/commit/626cbfae04beff12262174ce2a335353975920fb))
 - Update dependencies: masamune, masamune_model_firebase_remote_config.

## 3.1.0

 - **CO-AUTHORED-BY**: Claude Opus 5.5 <noreply@anthropic.com> ([aa03281c](https://github.com/mathrunet/flutter_masamune/commit/aa03281cd8c57eb2b1b9d5c86ceb99af752ff3b1))
 - **FEAT**(firebase): upgrade to FlutterFire BoM with firebase_core 5 ([aa03281c](https://github.com/mathrunet/flutter_masamune/commit/aa03281cd8c57eb2b1b9d5c86ceb99af752ff3b1))

### BREAKING CHANGES

 - The Firebase packages now require firebase_core 5, Dart 3.10 / Flutter 3.38, Firebase iOS SDK 13 and Android minSdk 24. Apps must upgrade their FlutterFire dependencies to the same release.
 - Update dependencies: masamune_model_firebase_remote_config.

## 3.0.1


 - Update dependencies: masamune, masamune_model_firebase_remote_config.

# 3.0.0

- Initial release. Define A/B tests and feature switches in a single synchronous `Experiment.run` based on Firebase Remote Config values.
