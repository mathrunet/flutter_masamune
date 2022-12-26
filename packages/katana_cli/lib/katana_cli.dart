// Copyright 2023 mathru. All rights reserved.

/// Command line tool for Masamune/Katana Framework. It initializes the project and initializes the services.
///
/// To use, import `package:katana_cli/katana_cli.dart`.
///
/// [mathru.net]: https://mathru.net
/// [YouTube]: https://www.youtube.com/c/mathrunetchannel
library katana_cli;

import 'src/framework.dart';

export 'package:katana/katana.dart';

export 'command/app/app.dart';
export 'command/code/code.dart';
export 'command/create.dart';
export 'command/pub/pub.dart';
export 'command/submodule.dart';
export 'src/framework.dart';

part 'code/collection_model.dart';
part 'code/controller.dart';
part 'code/controller_group.dart';
part 'code/document_model.dart';
part 'code/launch.dart';
part 'code/main.dart';
part 'code/katana.dart';
part 'code/page.dart';
part 'code/redirect_query.dart';
part 'code/tmp/basic.dart';
part 'code/tmp/form.dart';
part 'code/value.dart';
