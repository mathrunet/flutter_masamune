## 3.9.1


 - Update dependencies: masamune.

## 3.9.0

 - **FEAT**(masamune_model_turso): release version 3.8.0 with worker-based CRUD and group preference. ([1b95c963](https://github.com/mathrunet/flutter_masamune/commit/1b95c963ca1ec6af9f839fe298d16a87fd11463a))

## 3.8.0

- Add Worker-based CRUD with nativeVectors, nearest-neighbor queries, vectorConverter, and ranking preservation in the cached adapter.


- Add an optional group preference for new databases to adapters and FunctionsAction. The Worker selects a group automatically when omitted.
- Support group and primaryRegion in token responses and isolate caches by endpoint and authentication session. Refetch data on the first read instead of reusing old local caches.

## 3.7.9

 - **FIX**(tidb_adapter,turso_adapter): implement retry logic for transient errors. ([7fdd454c](https://github.com/mathrunet/flutter_masamune/commit/7fdd454c78d0ec425f64c9f6e38f1992209f979a))

## 3.7.8

 - **FIX**(masamune_model_tidb,masamune_model_turso): update dependency versions and refactor adapter constructors. ([1643cd70](https://github.com/mathrunet/flutter_masamune/commit/1643cd7091c81e1f3c37965e72148af0590cff6a))

## 3.7.7

 - **FIX**(tidb): migrate to Data Service model and enhance state management. ([773aa5a5](https://github.com/mathrunet/flutter_masamune/commit/773aa5a57efbae84718c95cfefc163b10f07a413))

## 3.7.6

 - **FIX**(masamune_model_turso): update dependency versions and improve disposal logic. ([e533a5a5](https://github.com/mathrunet/flutter_masamune/commit/e533a5a52569f6f362a43ee9d1daec15484a1034))

## 3.7.5

 - Update a dependency to the latest release.

## 3.7.4

 - Update a dependency to the latest release.

## 3.7.3

 - Update a dependency to the latest release.

## 3.7.2

 - Update a dependency to the latest release.

## 3.7.1

 - Update a dependency to the latest release.

## 3.7.0

 - **FEAT**(turso): enhance TursoDB deployment and error handling. ([314a7502](https://github.com/mathrunet/flutter_masamune/commit/314a75021cbd72ece49cb7e8e8b23da6918611b0))

## 3.6.3

 - **REFACTOR**(tests): reorganize import statements for clarity. ([e323ce40](https://github.com/mathrunet/flutter_masamune/commit/e323ce40ff1b62ef136b179ddd7af2880275a9ca))

## 3.6.2

 - **REFACTOR**(masamune_model_turso): update dependencies and enhance documentation. ([bcf5634a](https://github.com/mathrunet/flutter_masamune/commit/bcf5634ab6f588657b438147bb9ac8ab5c3a33e1))
 - **FIX**(masamune_model_turso): fix a crash caused by disposing a Turso client while it is in use. ([f43fed07](https://github.com/mathrunet/flutter_masamune/commit/f43fed07950b1c964873cbdd0cbb00f2eca59c37))

## 3.6.1

 - **FIX**(cloudflare): add smart placement option for Cloudflare Workers. ([9b9b8295](https://github.com/mathrunet/flutter_masamune/commit/9b9b8295eeae64ae0e90d39a9d5bb755a1ab7e0f))

## 3.6.0

 - **FEAT**(tidb): introduce CachedTidbModelAdapter for persistent local caching. ([67f6854e](https://github.com/mathrunet/flutter_masamune/commit/67f6854ebab383d897ddd838db0ea4abf6c48375))

## 3.5.0

 - **FEAT**(tidb): add support for database prefixes in model actions and adapters. ([e06e0f7d](https://github.com/mathrunet/flutter_masamune/commit/e06e0f7d3d8200a55b01023dee35e03a6b9d15ee))

## 3.4.3

 - **FIX**(turso): enhance query handling and data normalization. ([af98f82f](https://github.com/mathrunet/flutter_masamune/commit/af98f82fc61571dcea61df7bfede54928a63ce06))

## 3.4.2

 - **FIX**(turso): enhance TursoModelAdapter with retry logic and fallback handling. ([4f5fb7b5](https://github.com/mathrunet/flutter_masamune/commit/4f5fb7b5b5511e12dcaa88f8b1fb71b1a76a65f5))

## 3.4.1

 - **REFACTOR**(turso): simplify TursoModelAdapter and improve path handling. ([6cd2c61e](https://github.com/mathrunet/flutter_masamune/commit/6cd2c61e540c43a01e201eb1d33fe9b7789b3fe1))

## 3.4.0

 - **FEAT**(turso): implement TursoModelAdapter with direct access and CRUD actions. ([50ffa9b4](https://github.com/mathrunet/flutter_masamune/commit/50ffa9b44072f390f2df8a0c0153533887a86f34))

## 3.3.1

 - **FEAT**: Implement `TursoModelAdapter`, Turso FunctionsActions, direct libSQL access, scoped token requests, additive table migration, and SQL query conversion.

## 3.3.0

 - **FEAT**(masamune_functions_cloudflare): initialize Cloudflare functions package. ([2ea294d2](https://github.com/mathrunet/flutter_masamune/commit/2ea294d21b9ecc7cfc3dc187b485669759e2cb9e))
