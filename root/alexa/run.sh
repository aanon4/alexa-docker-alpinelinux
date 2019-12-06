#! /bin/sh

if [ ! -s /alexa/config/AlexaClientSDKConfig.json ]; then
  cd /alexa/source/avs-device-sdk/tools/Install
  ID=$(head -200 /dev/urandom | cksum | cut -f1 -d ' ')
  bash genConfig.sh /alexa/config.json ${ID} /alexa/database /alexa/source/avs-device-sdk /alexa/config/AlexaClientSDKConfig.json
fi
if [ ! -s /alexa/config/AlexaScreenConfig.json ]; then
  cp /alexa/sources/alexa-smart-screen-sdk/modules/GUI/config/guiConfigSamples/GuiConfigSample_SmartScreenLargeLandscape.json /alexa/config/AlexaScreenConfig.json
fi

if [ ! -s /alexa/GUI/main.bundle.js ]; then
  cp /alexa/source/ss-build/modules/GUI/*.html /alexa/source/ss-build/modules/GUI/*.js /alexa/source/ss-build/modules/GUI/*.png /alexa/GUI
fi

/alexa/source/ss-build/modules/Alexa/SampleApp/src/SampleApp \
  -C /alexa/config/AlexaClientSDKConfig.json \
  -C /alexa/config/AlexaScreenConfig.json \
  -K /alexa/third-party/snowboy/resources
