#!/bin/bash
# 신형 워치 (3.35.0) 환경으로 전환.
set -e 

echo "Switching to MODERN (3.35.0) environment..."

# 1. pubspec.yaml 교체
cp pubspec.modern.yaml pubspec.yaml

# 2. FVM 버전 변경
fvm use 3.35.0

# 3. 패키지 설치
fvm flutter pub get

echo "✅ MODERN environment is ready!"