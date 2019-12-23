FROM alpine:edge

WORKDIR /alexa

COPY root/ /

# Need edge/testing for bluez-alsa
# Need v3.9 for the specific version of asio
RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories ; echo "http://dl-cdn.alpinelinux.org/alpine/v3.9/community" >> /etc/apk/repositories
RUN apk add bash git build-base cmake make openssl gstreamer-dev gst-plugins-base-dev gst-plugins-good gst-plugins-bad gst-plugins-ugly sqlite-dev alsa-lib-dev curl-dev python perl portaudio-dev bluez-alsa nodejs npm asio-dev=1.12.2-r0

# Use some forked version of official packages which container minor tweaks to compile on Alpine Linux
RUN cd source ; git clone --depth 1 https://github.com/aanon4/avs-device-sdk.git ; git clone --depth 1 https://github.com/aanon4/alexa-smart-screen-sdk.git ; git clone --depth 1 https://github.com/alexa/apl-core-library.git
RUN cd third-party ; git clone --depth 1 https://github.com/xianyi/OpenBLAS.git ; git clone --depth 1 https://github.com/Kitt-AI/snowboy.git

# Need to compile this locally - official package segvs
RUN cd third-party/OpenBLAS ; make -j4 ONLY_CBLAS=1 NOFORTRAN=1 NO_LAPACK=1 NUM_THREADS=4 ; ls -al ; make NUM_THREADS=4 install

RUN cd source/sdk-build ; cmake ../avs-device-sdk \
	-DGSTREAMER_MEDIA_PLAYER=ON \
	-DPORTAUDIO=ON \
	-DPORTAUDIO_LIB_PATH=/usr/lib/libportaudio.so \
	-DPORTAUDIO_INCLUDE_DIR=/usr/include \
	-DKITTAI_KEY_WORD_DETECTOR=ON \
	-DKITTAI_KEY_WORD_DETECTOR_LIB_PATH=/alexa/third-party/snowboy/lib/ubuntu64/libsnowboy-detect.a \
	-DKITTAI_KEY_WORD_DETECTOR_INCLUDE_DIR=/alexa/third-party/snowboy/include \
	-DBUILD_TESTING=NO -DBUILD_GMOCK=NO \
	-DACSDK_EMIT_SENSITIVE_LOGS=ON \
	-DCMAKE_BUILD_TYPE=DEBUG \
	-DCMAKE_INSTALL_PREFIX=/alexa/install ; make -j4 ; make install

RUN cd source/apl-build ; cmake ../apl-core-library ; make -j4

RUN cd source/ss-build; cmake ../alexa-smart-screen-sdk \
	-DCMAKE_PREFIX_PATH=/alexa/install \
	-DWEBSOCKETPP_INCLUDE_DIR=/alexa/third-party/websocketpp-0.8.1 \
	-DDISABLE_WEBSOCKET_SSL=ON \
	-DGSTREAMER_MEDIA_PLAYER=ON \
	-DPORTAUDIO=ON -DPORTAUDIO_LIB_PATH=/usr/lib/libportaudio.so \
	-DPORTAUDIO_INCLUDE_DIR=/usr/include \
	-DAPL_CORE=ON \
	-DAPLCORE_INCLUDE_DIR=/alexa/source/apl-core-library/aplcore/include \
	-DAPLCORE_LIB_DIR=/alexa/source/apl-build/aplcore \
	-DYOGA_INCLUDE_DIR=/alexa/source/apl-build/yoga-prefix/src/yoga \
	-DYOGA_LIB_DIR=/alexa/source/apl-build/lib \
	-DKITTAI_KEY_WORD_DETECTOR=ON \
	-DKITTAI_KEY_WORD_DETECTOR_LIB_PATH=/alexa/third-party/snowboy/lib/ubuntu64/libsnowboy-detect.a \
	-DKITTAI_KEY_WORD_DETECTOR_INCLUDE_DIR=/alexa/third-party/snowboy/include \
	-DACSDK_EMIT_SENSITIVE_LOGS=ON \
	-DBUILD_TESTING=NO -DBUILD_GMOCK=NO \
	-DCMAKE_BUILD_TYPE=DEBUG ; make -j4

RUN cp third-party/snowboy/resources/alexa/alexa_02092017.umdl third-party/snowboy/resources/alexa.umdl

# Websocket
EXPOSE 8933/tcp

VOLUME /alexa/database
VOLUME /alexa/GUI
VOLUME /alexa/config
VOLUME /dev/snd

ENTRYPOINT ["/alexa/run.sh"]
