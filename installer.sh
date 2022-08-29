#!/bin/bash

dart pub global activate melos
melos bs
dart pub global activate --source path packages/masamune_cli/.
