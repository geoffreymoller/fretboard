#!/bin/sh

export CLOSURE_PATH='/Users/160950/dev/javascript/closure-library/'
export CLOSURE_BUILDER_PATH='/Users/160950/dev/javascript/closure-library/closure/bin/build/closurebuilder.py'
export CLOSURE_COMPILER_PATH='/Users/160950/dev/javascript/closure-compiler/compiler.jar'

$CLOSURE_BUILDER_PATH \
    --root=/Users/160950/dev/javascript/closure-library/ \
    --root=public/js/ \
    --namespace="goog.array" \
    --namespace="goog.math.Matrix" \
    --namespace="jquery" \
    --namespace="underscore" \
    --namespace="backbone" \
    --namespace="pubsub" \
    --namespace="music" \
    --namespace="paper" \
    --namespace="vexflow" \
    --output_mode=compiled \
    --compiler_jar=$CLOSURE_COMPILER_PATH \
    > public/js/fb-libs-compiled.js


