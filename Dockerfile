# based on https://registry.hub.docker.com/u/samtstern/android-sdk/dockerfile/ with openjdk-8
FROM openjdk:8

MAINTAINER Noel Mansour

ENV DEBIAN_FRONTEND noninteractive

# Install dependencies
RUN dpkg --add-architecture i386 && \
    apt-get update && \
    apt-get install -yq libc6:i386 libstdc++6:i386 zlib1g:i386 libncurses5:i386 --no-install-recommends && \
    apt-get clean

# Download and untar SDK
ENV ANDROID_SDK_URL http://dl.google.com/android/android-sdk_r24.4.1-linux.tgz
RUN curl -L "${ANDROID_SDK_URL}" | tar --no-same-owner -xz -C /usr/local
ENV ANDROID_HOME /usr/local/android-sdk-linux
ENV ANDROID_SDK /usr/local/android-sdk-linux
ENV PATH ${ANDROID_HOME}/tools:$ANDROID_HOME/platform-tools:$PATH

# Install Android SDK components
ENV ANDROID_COMPONENTS platform-tools,build-tools-25.0.2,android-25
ENV GOOGLE_COMPONENTS extra-android-m2repository,extra-google-m2repository,extra-google-google_play_services

# Required for ConstraintLayout license
# Also requires running gradle task twice - ./gradlew dependencies || true && ./gradlew assembleDebug
# https://code.google.com/p/android/issues/detail?id=212128
RUN mkdir -p "${ANDROID_SDK}/licenses"; \
    echo "\n8933bad161af4178b1185d1a37fbf41ea5269c55" > "${ANDROID_SDK}/licenses/android-sdk-license"; \
    echo "\n84831b9409646a918e30573bab4c9c91346d8abd" > "${ANDROID_SDK}/licenses/android-sdk-preview-license"

RUN echo y | android update sdk --no-ui --filter "${ANDROID_COMPONENTS}" ; \
    echo y | android update sdk --no-ui --filter "${GOOGLE_COMPONENTS}"

