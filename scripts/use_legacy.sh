#!/bin/bash
# 구형 워치 (3.16.2) 환경으로 전환.
set -e

echo "Switching to LEGACY (3.16.2) environment..."

# 1. pubspec.yaml 교체
cp pubspec.legacy.yaml pubspec.yaml

# 2. FVM 버전 변경 (pub get 건너뛰기)
fvm use 3.16.2 --skip-setup

# 3. 패키지 설치
fvm flutter pub get

echo "✅ LEGACY environment is ready!"