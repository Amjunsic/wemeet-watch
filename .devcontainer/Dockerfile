# 1. 베이스 이미지
FROM ubuntu:22.04

# 2. 고정 인자 설정
ARG DEBIAN_FRONTEND=noninteractive

# 3. 모든 필수 도구 한 번에 설치 (root)
RUN apt-get update && apt-get install -y \
    curl git unzip xz-utils zip sudo wget \
    gpg \
    patch rsync \
    liblzma-dev \
    openjdk-17-jdk \
    rpm gettext libgdiplus \
    clang cmake ninja-build pkg-config libgtk-3-dev \
    apt-transport-https && \
    wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor > /usr/share/keyrings/dart.gpg && \
    echo 'deb [signed-by=/usr/share/keyrings/dart.gpg arch=amd64] https://storage.googleapis.com/download.dartlang.org/linux/debian stable main' > /etc/apt/sources.list.d/dart_stable.list && \
    apt-get update && apt-get install -y dart && \
    nodejs npm && \
    rm -rf /var/lib/apt/lists/*

# 4. 'vscode' 사용자 생성 및 sudo 설정 (root)
ARG USERNAME=vscode
RUN useradd -m -s /bin/bash -G sudo $USERNAME
# 'sudoers' 그룹 대신 사용자에게 직접 NOPASSWD 권한 부여 (더 명확함)
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME

# 5. 'vscode' 사용자로 전환 ---
# (이 시점부터 모든 ENV, RUN은 'vscode' 사용자로 실행됨)
USER ${USERNAME}
WORKDIR /home/${USERNAME}

# 6. 'vscode' 사용자 환경 변수 설정
# [수정] 모든 도구의 설치 경로를 'vscode' 홈 디렉토리로 변경
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV FVM_HOME=/home/${USERNAME}/.fvm
ENV ANDROID_SDK_ROOT=/home/${USERNAME}/.android-sdk
ENV FLUTTER_TIZEN_HOME=/home/${USERNAME}/.flutter-tizen
ENV TIZEN_SDK_HOME=/home/${USERNAME}/tizen-studio

ENV PATH="/home/${USERNAME}/.pub-cache/bin:${FVM_HOME}/default/bin:${PATH}"
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"
ENV PATH="${PATH}:${FLUTTER_TIZEN_HOME}/bin"
ENV PATH="${PATH}:${TIZEN_SDK_HOME}/tools:${TIZEN_SDK_HOME}/tools/ide/bin"

# 7. Flutter SDK 설치 ('vscode' 사용자 권한)
RUN dart pub global activate fvm
RUN fvm install 3.16.2
RUN fvm install 3.35.0
RUN fvm global 3.16.2

# 8. Android SDK 설치 ('vscode' 사용자 권한)
ARG CMDLINE_TOOLS_VERSION=11076708
RUN mkdir -p ${ANDROID_SDK_ROOT} && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip
RUN yes | sdkmanager --licenses
RUN sdkmanager --install "platform-tools" "platforms;android-33" "build-tools;34.0.0"

# 9. flutter-tizen 설치 ('vscode' 사용자 권한)
RUN git config --global --add safe.directory ${FVM_HOME}/versions/3.16.2
RUN git config --global --add safe.directory ${FVM_HOME}/versions/3.35.0
# [수정] 이제 '/home/vscode/.flutter-tizen'에 설치됩니다.
RUN git clone https://github.com/flutter-tizen/flutter-tizen.git -b 3.16.2 --depth 1 ${FLUTTER_TIZEN_HOME}

# 10. Tizen Studio (CLI) 설치 ('vscode' 사용자 권한)
RUN wget -q https://download.tizen.org/sdk/Installer/tizen-studio_6.1/web-cli_Tizen_Studio_6.1_ubuntu-64.bin -O /tmp/tizen-installer.bin && \
    chmod +x /tmp/tizen-installer.bin && \
    /tmp/tizen-installer.bin --accept-license --no-java-check ${TIZEN_SDK_HOME} && \
    rm /tmp/tizen-installer.bin && \
    ${TIZEN_SDK_HOME}/package-manager/package-manager-cli.bin install --no-ask --accept-license Wearable-7.0-NativeAppDev-CLI

# --- 최종 설정 ---
# WORKDIR을 /workspace로 변경 (VSCode Dev Container의 기본값)
WORKDIR /workspace
CMD ["sleep", "infinity"]