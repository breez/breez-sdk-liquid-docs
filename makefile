export SNIPPETS ?= $(shell pwd)/snippets
export SCRIPTS := $(shell pwd)/scripts
export BREEZ_LOCAL ?= $(shell realpath ../breez-sdk-liquid)
export PACKAGES := ${BREEZ_LOCAL}/packages
export BINDINGS := ${BREEZ_LOCAL}/lib/bindings

setup-local-go:
	cd ${SNIPPETS}/go/ && \
	go work init && \
	go work use .  && \
	mkdir -p breez-sdk-liquid-go && \
	ln -s ${BINDINGS}/ffi/golang/breez_sdk_liquid breez-sdk-liquid-go/breez_sdk_liquid && \
	${SCRIPTS}/setup_local_go.sh && \
	go work use breez-sdk-liquid-go

clean-local-go:
	cd ${SNIPPETS}/go/ && \
	rm -r go.work go.work.sum breez-sdk-liquid-go

setup-local-dart:
	${SCRIPTS}/setup_local_dart.sh

clean-local-dart:
	rm ${SNIPPETS}/dart_snippets/pubspec_overrides.yaml

setup-local-python:
	${SCRIPTS}/setup_local_python.sh
	
clean-local-python:
	rm -r ${SNIPPETS}/python/.venv

setup-local-react-native:
	cd ${SNIPPETS}/react-native && yarn install && \
	rm -rf ${SNIPPETS}/react-native/node_modules/@breeztech/breez-sdk-liquid-react-native && \
	ln -s \
		${PACKAGES}/react-native \
		${SNIPPETS}/react-native/node_modules/@breeztech/breez-sdk-liquid-react-native

clean-local-react-native:
	rm -rf ${SNIPPETS}/react-native/node_modules/@breeztech/breez-sdk-liquid-react-native && \
	cd ${SNIPPETS}/react-native && yarn install

setup-local-wasm:
	cd ${SNIPPETS}/wasm && yarn install && \
	rm -rf ${SNIPPETS}/wasm/node_modules/@breeztech/breez-sdk-liquid && \
	ln -s \
		${PACKAGES}/wasm \
		${SNIPPETS}/wasm/node_modules/@breeztech/breez-sdk-liquid

clean-local-wasm:
	rm -rf ${SNIPPETS}/wasm/node_modules/@breeztech/breez-sdk-liquid && \
	cd ${SNIPPETS}/wasm && yarn install

setup-local-rust:
	cd ${SNIPPETS}/rust && \
	sed -i '' "s/^# \[patch.\'https:\/\/github.com\/breez\/breez-sdk-liquid\'\]/[patch.\'https:\/\/github.com\/breez\/breez-sdk-liquid\'\]/" Cargo.toml && \
	sed -i '' 's/^# breez-sdk-liquid = { path/breez-sdk-liquid = { path/' Cargo.toml && \
	cargo update -p breez-sdk-liquid --quiet

clean-local-rust:
	cd ${SNIPPETS}/rust && \
	sed -i '' "/\[patch.\'https:\/\/github.com\/breez\/breez-sdk-liquid\'\]/ s/^/# /g" Cargo.toml && \
	sed -i '' '/breez-sdk-liquid = { path/ s/^/# /g' Cargo.toml && \
	cargo update -p breez-sdk-liquid --quiet

setup-local: \
	setup-local-go \
  setup-local-dart \
  setup-local-python \
  setup-local-react-native \
  setup-local-wasm \ 
  setup-local-rust

clean-local: \
	clean-local-go \
  clean-local-dart \
  clean-local-python \
  clean-local-react-native \
  clean-local-wasm \
  clean-local-rust
