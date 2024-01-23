# Docker container for Firefox Based of Jlesage Repository, this intended for educational purpose only

This is a Docker container for [Firefox](https://www.mozilla.org/en-US/firefox/).

The GUI of the application is accessed through a modern web browser (no
installation or configuration needed on the client side) or via any VNC client.

---

[![Firefox logo](https://images.weserv.nl/?url=raw.githubusercontent.com/imodstyle/docker-firefox/master/img/firefox-icon.png&w=110)](https://www.mozilla.org/en-US/firefox/)[![Firefox](https://images.placeholders.dev/?width=224&height=110&fontFamily=monospace&fontWeight=400&fontSize=52&text=Firefox&bgColor=rgba(0,0,0,0.0)&textColor=rgba(121,121,121,1))](https://www.mozilla.org/en-US/firefox/)

Mozilla Firefox is a free and open-source web browser developed by Mozilla
Foundation and its subsidiary, Mozilla Corporation.

---

## Quick Start

**NOTE**:
    The Docker command provided in this quick start is given as an example
    and parameters should be adjusted to your need.

Launch the Firefox docker container with the following command:
```shell
docker run -d \
    --name=firefox \
    -p 5800:5800 \
    -v /docker/appdata/firefox:/config:rw \
    imodstyle/firefox
```

Where:

  - `/docker/appdata/firefox`: This is where the application stores its configuration, states, log and any files needing persistency.

Browse to `http://your-host-ip:5800` to access the Firefox GUI.

## Documentation

Full documentation is available at https://github.com/imodstyle/docker-firefox.

## Support or Contact

Having troubles with the container or have questions?  Please
[create a new issue].

[create a new issue]: https://github.com/imodstyle/docker-firefox/issues
