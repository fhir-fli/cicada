#!/bin/bash
set -e

echo "=== Step 1: XML to JSON ==="
dart cicada_generator/lib/xml_to_json.dart

echo "=== Step 2: Generate supporting data Dart files ==="
dart cicada_generator/lib/main.dart

echo "=== Step 3: Generate test cases + expected results ==="
dart cicada_generator/lib/test_cases/test_case_generator.dart

echo "=== Step 4: Format generated code ==="
dart format cicada/lib/generated_files/

echo "=== Done ==="
