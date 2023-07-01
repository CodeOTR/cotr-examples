#! /bin/zsh

cd ..
flutter build web --dart-define-from-file=assets/config.json
firebase deploy