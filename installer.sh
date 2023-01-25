#!/bin/bash

flutter pub global activate melos
melos bs
flutter pub global activate --source path packages/katana_cli/.
