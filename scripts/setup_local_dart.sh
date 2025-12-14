#!/usr/bin/env bash
cat << EOF > ${SNIPPETS}/dart_snippets/pubspec_overrides.yaml
dependency_overrides: 
  flutter_breez_liquid: 
    path: ${PACKAGES}/flutter_breez_liquid/
EOF
