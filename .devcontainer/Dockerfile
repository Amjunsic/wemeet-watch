# 1. 베이스 이미지
FROM ubuntu:22.04

# 2. 고정 인자 설정
ARG DEBIAN_FRONTEND=noninteractive

# 3. 모든 필수 도구 한 번에 설치
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
    rm -rf /var/lib/apt/lists/*

# 4. Flutter SDK 설치 (root)
ENV FVM_HOME=/opt/fvm
ENV PATH="/root/.pub-cache/bin:${FVM_HOME}/default/bin:${PATH}"
RUN dart pub global activate fvm
RUN fvm install 3.16.2
RUN fvm install 3.35.0
RUN fvm global 3.16.2

# 6. Android SDK 설치
ENV ANDROID_SDK_ROOT=/opt/android-sdk
ENV JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
ENV PATH="$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"
ARG CMDLINE_TOOLS_VERSION=11076708
RUN mkdir -p ${ANDROID_SDK_ROOT} && \
    wget -q https://dl.google.com/android/repository/commandlinetools-linux-${CMDLINE_TOOLS_VERSION}_latest.zip -O /tmp/cmdline-tools.zip && \
    unzip -q /tmp/cmdline-tools.zip -d ${ANDROID_SDK_ROOT}/cmdline-tools && \
    mv ${ANDROID_SDK_ROOT}/cmdline-tools/cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest && \
    rm /tmp/cmdline-tools.zip
RUN yes | sdkmanager --licenses
RUN sdkmanager --install "platform-tools" "platforms;android-33" "build-tools;34.0.0"

# --- Tizen 설치를 위한 사전 작업 (root) ---
ARG USERNAME=vscode
RUN useradd -m -s /bin/bash -G sudo $USERNAME

# 5. flutter-tizen '3.16.2' 릴리즈 설치 및 Flutter '3.16.2' 버전에 연동 (root)
RUN git config --global --add safe.directory /root/fvm/versions/3.16.2
RUN git config --global --add safe.directory /root/fvm/versions/3.35.0

ENV FLUTTER_TIZEN_HOME=/opt/flutter-tizen
ENV PATH="${FLUTTER_TIZEN_HOME}/bin:${PATH}"
RUN git clone https://github.com/flutter-tizen/flutter-tizen.git -b 3.16.2 --depth 1 ${FLUTTER_TIZEN_HOME}

# 7. Tizen Studio (CLI) 설치
ENV TIZEN_SDK_HOME=/home/${USERNAME}/tizen-studio
ENV PATH="$PATH:${TIZEN_SDK_HOME}/tools:${TIZEN_SDK_HOME}/tools/ide/bin"
RUN wget -q https://download.tizen.org/sdk/Installer/tizen-studio_6.1/web-cli_Tizen_Studio_6.1_ubuntu-64.bin -O /tmp/tizen-installer.bin && \
    chmod +x /tmp/tizen-installer.bin && \
    chown ${USERNAME}:${USERNAME} /tmp/tizen-installer.bin
USER ${USERNAME}
RUN /tmp/tizen-installer.bin --accept-license --no-java-check ${TIZEN_SDK_HOME} && \
    rm /tmp/tizen-installer.bin && \
    ${TIZEN_SDK_HOME}/package-manager/package-manager-cli.bin install --no-ask --accept-license Wearable-7.0-NativeAppDev-CLI
USER root

# --- 최종 설정 ---
RUN echo "$USERNAME ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/$USERNAME
USER ${USERNAME}
WORKDIR /workspace
CMD ["sleep", "infinity"]