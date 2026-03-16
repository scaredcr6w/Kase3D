#!/bin/bash

MOCKOLO=$(which mockolo)
if [ -z "$MOCKOLO" ]; then
    echo "error: mockolo not found. Install with: brew install mockolo"
    exit 1
fi

PROJECT_ROOT="${SRCROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
OUTPUT="${PROJECT_ROOT}/Kase3DTests/GeneratedMocks.swift"

"$MOCKOLO" \
    --sourcedirs "${PROJECT_ROOT}/Kase3D" \
    --destination "$OUTPUT" \
    --testable-imports Kase3D

echo "✅ Mocks generated at $OUTPUT"

PROJECT_ROOT="${SRCROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
OUTPUT="${PROJECT_ROOT}/Kase3DEngineTests/GeneratedMocks.swift"

"$MOCKOLO" \
    --sourcedirs "${PROJECT_ROOT}/Kase3DEngine" \
    --destination "$OUTPUT" \
    --testable-imports Kase3DEngine

echo "✅ Mocks generated at $OUTPUT"

PROJECT_ROOT="${SRCROOT:-$(cd "$(dirname "$0")/.." && pwd)}"
OUTPUT="${PROJECT_ROOT}/Kase3DCoreTests/GeneratedMocks.swift"

"$MOCKOLO" \
    --sourcedirs "${PROJECT_ROOT}/Kase3DCore" \
    --destination "$OUTPUT" \
    --testable-imports Kase3DCore

echo "✅ Mocks generated at $OUTPUT"

