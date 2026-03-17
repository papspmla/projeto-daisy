#!/bin/bash

echo ""
echo "Daisy build system"
echo "=============================="
echo ""

ROOT=~/projeto_daisy
SRC=$ROOT/go
BIN=$ROOT/bin

echo "Project root: $ROOT"
echo "Go source dir: $SRC"
echo "Binary output: $BIN"
echo ""

mkdir -p "$BIN"

cd "$SRC" || exit 1

build() {
    name=$1
    echo ""
    echo "Building $name..."
    go build -o "$BIN/$name" "$name.go"
}

build detect_clinical_phases
build trend_analyzer
build clinical_alerts
build clinical_flags_engine
build clinical_summary
build renal_function_model
build renal_interpreter
build hepatic_interpreter
build clinical_consistency_engine
build metabolic_interpreter
build weight_interpreter
build clinical_dashboard
build daisy_clinical_report

echo ""
echo "Build complete"
echo ""
