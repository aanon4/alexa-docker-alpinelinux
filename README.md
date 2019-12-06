# Alexa Smart Screen build for Docker (AlpineLinux)

The Alexa Smart Screen SDK (by Amazon) provides a simple way to build screen based Alexa devices (Echo Show like things).
As the build steps are tricky and tedious, this Docker wraps it all up with Alpine Linux to make it much easier for
someone to try.

## Usage

The repository contains a RUN script which will run the Docker image correctly configured. The essential docker run command is as follows:

> docker run --name alexa
>		--mount type=bind,source=$PWD/run/database,target=/alexa/database
>		--mount type=bind,source=$PWD/run/config,target=/alexa/config
>		--mount type=bind,source=$PWD/run/GUI,target=/alexa/GUI
>		--mount type=bind,source=/dev/snd,target=/dev/snd
>		--network host \
>		--privileged \
>		alexa /alexa/run.sh

There are various bind which are important for successful operation:

* **/alexa/database** binds to an empty directory where various Sqlite databases are created. Without this, evertime
the application is restarted, it will have to reauthenticate with the Alexa Voice Service.
* /alexa/source/avs-device-sdk/tools/Install/config.json
* **/alexa/config/** binds to a directory holding your configuation. If these files don't exists, they will be
created on first-run.
* **/alexa/GUI** binds to an empty directy where the application will place HTML and JS files. These files are used
to display the smart screen in a browser.
* **/dev/snd** binds to the sound device on the host, provides microphone and speaker access for Alexa.

## See Also

* https://developer.amazon.com/en-US/alexa/alexa-voice-service/alexa-smart-screen-sdk
* https://github.com/alexa/alexa-smart-screen-sdk
