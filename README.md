# Alexa Smart Screen build for Docker (AlpineLinux)

The Alexa Smart Screen SDK (by Amazon) provides a simple way to build screen based Alexa devices (Echo Show like things).
As the build steps are tricky and tedious, this Docker wraps it all up with Alpine Linux to make it much easier for
someone to try.

## Usage

The repository contains a RUN script which will run the Docker image correctly configured. The essential docker run command is as follows:

> docker run --name alexa 
	--mount type=bind,source=$PWD/run/database,target=/alexa/database \
	--mount type=bind,source=$PWD/run/config.json,target=/alexa/source/avs-device-sdk/tools/Install/config.json \
	--mount type=bind,source=$PWD/run/AlexaClientSDKConfig.json,target=/alexa/config/AlexaClientSDKConfig.json \
	--mount type=bind,source=$PWD/run/AlexaScreenConfig.json,target=/alexa/config/AlexaScreenConfig.json \
	--mount type=bind,source=$PWD/run/GUI,target=/alexa/GUI \
	--mount type=bind,source=/dev/snd,target=/dev/snd \
	--network host \
	--env HOST="..." \
	--privileged \
	alexa /alexa/run.sh
  
There are various bind which are important for successful operation:

* **/alexa/database** binds to an empty directory where various Sqlite databases are created. Without this, evertime
the application is restarted, it will have to reauthenticate with the Alexa Voice Service.
* /alexa/source/avs-device-sdk/tools/Install/config.json
* **/alexa/config/AlexaClientSDKConfig.json** Is created at first-run and contains the default Alexa configuration.
* **/alexa/config/AlexaScreenConfig.json** configures the screen and devices properties
(see <https://github.com/alexa/alexa-smart-screen-sdk/blob/master/modules/GUI/config/SmartScreenSDKConfig.md>)
* **/alexa/GUI** binds to an empty directy where the application will place HTML and JS files. These files are used to display
the smart screen in a browser.
* **/dev/snd** binds to the sound device on the host, provides microphone and speaker access for Alexa.

## See Also

* https://developer.amazon.com/en-US/alexa/alexa-voice-service/alexa-smart-screen-sdk
* https://github.com/alexa/alexa-smart-screen-sdk
