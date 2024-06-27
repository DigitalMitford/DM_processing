# semver.xq

[![CI](https://github.com/eXist-db/semver.xq/workflows/CI/badge.svg)](https://github.com/eXist-db/semver.xq/actions?query=workflow%3ACI)
[![License](https://img.shields.io/badge/license-BSD%203%20Clause-blue.svg)](http://opensource.org/licenses/BSD-3-Clause)

Validate, compare, sort, parse, and serialize Semantic Versioning (SemVer) 2.0.0 version strings, using XQuery.

SemVer rules are applied strictly, raising errors when version strings do not conform to the spec. 

## Building
* Requirements: Java 8, Apache Maven 3.3+, Git.

If you want to create an EXPath Package for the app, you can run:

```bash
$ mvn package
```

There will be a `.xar` file in the `target/` sub-folder.

## Performing a Release

This project is configured to use the [Maven Release Plugin](https://maven.apache.org/maven-release/maven-release-plugin/)
to make creating and subsequently publishing a release easy.

The release plugin will take care of:
1. Testing the project (all tests must pass)
2. Verifying all rules, e.g. license declarations present, etc.
3. Creating a Git Tag and pushing the Tag to GitHub
4. Building and signing the artifacts (e.g. EXPath Pkg `.xar` file).

Before performing the release, in addition to the Build requirements you need an installed and functioning copy of GPG or [GnuPG](https://gnupg.org/) with your private key setup correctly for signing.

To perform the release, from within your local Git cloned repository run:

```bash
mvn release:prepare && mvn release:perform
```

You will be prompted for the answers to a few questions along the way. The default response will be provided for you, and you can simply press "Enter" (or "Return") to accept it. Alternatively you may enter your own value and press "Enter" (or "Return").
```bash
What is the release version for "semver.xq"? (org.exist-db.xquery:semver-xq) 2.3.1: : 2.4.0
What is SCM release tag or label for "semver.xq"? (org.exist-db.xquery:semver-xq) 2.4.0: :
What is the new development version for "semver.xq"? (org.exist-db.xquery:semver-xq) 2.4.1-SNAPSHOT: :
```

* For the `release version`, please sensibly consider using the next appropriate [SemVer 2.0.0](https://semver.org/) version number.
* For the `SCM release tag`, please use the same value as the `release version`.
* For the `new development version`, the default value should always suffice.

Once the release process completes, there will be a `.xar` file in the `target/` sub-folder. This file may be published to:
1. GitHub Releases - https://github.com/eXist-db/semver.xq/releases
2. The eXist-db Public EXPath Repository - https://exist-db.org/exist/apps/public-repo/admin

## Development / Manual Testing

Simply run: `mvn -Pdev docker:start` to start a Docker environment of eXist-db on port 9090
with the semver.xq package already deployed.

As the Docker environment binds the files from the host filesystem, changes to the source code
are reflected immediately in the running eXist-db environment.

You can override the Docker host port for eXist-db from port 9090 to a port of your choosing by
specifying `-Ddev.port=9191`, e.g.: `mvn -Pdev -Ddev.port=9191 docker:start`.

If you also want the Dashboard and eXide to be available from the Docker environment of eXist-db
you can invoke the target `public-xar-repo:resolve` before you call `docker:start`,
e.g. `mvn -Pdev public-xar-repo:resolve docker:start`.

To stop the Docker environment run: `mvn -Pdev docker:stop`.
