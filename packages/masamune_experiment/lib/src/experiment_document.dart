part of "/masamune_experiment.dart";

/// Document that holds the values loaded by [ExperimentMasamuneAdapter.modelAdapter].
///
/// [ExperimentMasamuneAdapter.modelAdapter]で読み込んだ値を保持するドキュメント。
class _ExperimentDocument extends DocumentBase<DynamicMap> {
  _ExperimentDocument(super.modelQuery);

  @override
  DynamicMap fromMap(DynamicMap map) => map;

  @override
  DynamicMap toMap(DynamicMap value) => value;
}
