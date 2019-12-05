#! /bin/sh

if [ ! -s /alexa/config/AlexaClientSDKConfig.json ]; then
  cd /alexa/source/avs-device-sdk/tools/Install
  bash genConfig.sh config.json 00001 /alexa/database /alexa/source/avs-device-sdk /alexa/config/AlexaClientSDKConfig.json
fi

if [ ! -s /alexa/GUI/main.bundle.js ]; then
  cp /alexa/source/ss-build/modules/GUI/*.html /alexa/source/ss-build/modules/GUI/*.js /alexa/source/ss-build/modules/GUI/*.png /alexa/GUI
fi

/alexa/source/ss-build/modules/Alexa/SampleApp/src/SampleApp \
  -C /alexa/config/AlexaClientSDKConfig.json \
  -C /alexa/config/AlexaScreenConfig.json \
  -K /alexa/third-party/snowboy/resources \

exit 0

  -L DEBUG9
