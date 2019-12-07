# Alexa Smart Screen build for Docker (AlpineLinux)

The Alexa Smart Screen SDK (by Amazon) provides a simple way to build screen based Alexa devices (Echo Show like things).
As the build steps are tricky and tedious, this Docker wraps it all up with Alpine Linux to make it much easier for
someone to try.

## Usage

The repository contains a RUN script which will run the Docker image correctly configured. The essential docker run command is as follows:

~~~~
docker run --name alexa
    --mount type=bind,source=$PWD/run/database,target=/alexa/database
    --mount type=bind,source=$PWD/run/config,target=/alexa/config
    --mount type=bind,source=$PWD/run/GUI,target=/alexa/GUI
    --mount type=bind,source=/dev/snd,target=/dev/snd
    --network host
    --env HOSTIP="..."
    --privileged \
    alexa /alexa/run.sh
~~~~

There are various bind which are important for successful operation:

* **/alexa/database**
> Binds to an empty directory where various SQLite databases are created. Without this, everytime
the application is restarted, it will have to reauthenticate with the Alexa Voice Service.

* **/alexa/config**
> Binds to a directory holding your configuation. If these configuration files don't exists, they will be
created on first-run. You can then edit them.

* **/alexa/GUI**
> Binds to an empty directy where the application will place HTML and JS files. These files are used
to display the smart screen in a browser.

* **/dev/snd**
> Binds to the sound device on the host, provides microphone and speaker access for Alexa.

## See Also

* https://developer.amazon.com/en-US/alexa/alexa-voice-service/alexa-smart-screen-sdk
* https://github.com/alexa/alexa-smart-screen-sdk
