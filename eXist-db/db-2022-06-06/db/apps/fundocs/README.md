# eXist-db Function Documentation Browser App
[![Build Status](https://travis-ci.com/eXist-db/function-documentation.svg?branch=master)](https://travis-ci.com/eXist-db/function-documentation)
[![eXist-db version](https://img.shields.io/badge/eXist_db-4.0.0-blue.svg)](http://www.exist-db.org/exist/apps/homepage/index.html)

<img src="src/main/xar-resources/icon.png" align="left" width="15%"/>

This repository contains the function documentation borwser app for the [eXist-db native XML database](http://www.exist-db.org).

## Dependencies
-   [Maven](https://maven.apache.org): 3.5.2
-   [eXist-db](http://exist-db.org): 4.0.0

## Installation
-   Just go to your eXist server's Dashboard and select Function Documentation.
-   Update to the latest release via the eXist-db package manager or via the eXist-db.org public app repository at [http://exist-db.org/exist/apps/public-repo/](http://exist-db.org/exist/apps/public-repo/).

## Building from source
1.  Clone the repository to your system:
    ```bash
    $ git clone https://github.com/exist-db/function-documentation.git
    ```

2.  Build the function documentation application:
    ```bash
    $ cd function-documentation
    $ mvn clean package
    ```
    The compiled `.xar` file is located in the `/target` directory

3.  Install this file via the Dashboard > Package Manager.

## License
LGPLv2.1 [eXist-db.org](http://exist-db.org/exist/apps/homepage/index.html)
