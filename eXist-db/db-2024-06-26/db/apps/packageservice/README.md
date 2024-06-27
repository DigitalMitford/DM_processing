# eXistdb Package Service

The eXistdb Package Service bundles some common functions to access locally installed and remote packages and provides endpoint to access
those functions.

It allows to:
* list locally installed applications
* list locally installed libs
* list all locally installed packages
* list packages available from remote repository
* install a package
* remove a package
* access the package icon
* read the url of the public eXist-db repository

All available metadata are output as HTML custom elements to provide a 1:1 representation: all 
elements in the metadata are prefixed with 'repo-' to create a valid HTML5 custom element.

It is a headless application to be used by eXistdb-packagemanager and existdb-dashboard.

## Available endpoints

### get local packages 

Outputs a list of locally installed application and libraries.


URL Path: `/packages/local` 

will return a list of HTML elements in the following format:

```
<repo-packages>
    <repo-app url="http://exist-db.org/couchbase" abbrev="couchbase" type="library" version="0.5.5" status="installed" path="/exist/apps/couchbase/">
        <repo-type>library</repo-type>
        <repo-title>Couchbase driver</repo-title>
        <repo-name>http://exist-db.org/couchbase</repo-name>
        <repo-description>The Couchbase Server driver extension for eXist-db provides access to functions and features of the Couchbase Server
            using the original Couchbase java client. This extension has NOT been developed by CouchBase and is therefore NOT an offical
            driver nor is it supported by CouchBase.</repo-description>
        <repo-authors>
            <repo-author>Dannes Wessels</repo-author>
        </repo-authors>
        <repo-abbrev>couchbase</repo-abbrev>
        <repo-website>https://github.com/weXsol/Couchbase</repo-website>
        <repo-license>GNU-LGPL</repo-license>
        <repo-icon src="/exist/apps/existdb-packageservice/package/icon?package=http://exist-db.org/couchbase">&nbsp;</repo-icon>
        <repo-url>/exist/apps/couchbase/</repo-url>
        <repo-version>0.5.5</repo-version>
    </repo-app>
    ...more entries...
```

### get local apps

Outputs a list of locally installed applications.

URL Path: `/packages/apps`

The format is similar to be above. The `type` will be "application":

```
<repo-packages>
    <repo-app url="http://exist-db.org/apps/eXide" abbrev="eXide" type="application" version="2.4.1" status="installed" path="/exist/apps/eXide/">
        <repo-type>application</repo-type>
        <repo-title>eXide - XQuery IDE</repo-title>
        <repo-name>http://exist-db.org/apps/eXide</repo-name>
        <repo-description>eXide - a web based XQuery IDE</repo-description>
        <repo-authors>
            <repo-author>Wolfgang Meier</repo-author>
        </repo-authors>
        <repo-abbrev>eXide</repo-abbrev>
        <repo-website>http://exist-db.org/exist/apps/eXide/docs/doc.html</repo-website>
        <repo-license>GNU-GPLv3</repo-license>
        <repo-icon src="/exist/apps/existdb-packageservice/package/icon?package=http://exist-db.org/apps/eXide">&nbsp;</repo-icon>
        <repo-url>/exist/apps/eXide/</repo-url>
        <repo-version>2.4.1</repo-version>
    </repo-app>
    ...more entries...
```

### get remote packages

Outputs a lists of package available from the public repository 

`packages/remote`

Remote packages may contain additional elements like `<repo-other>`

```
<repo-packages>
    <repo-app url="http://exist-db.org/apps/tei-graphing" abbrev="tei-graphing" type="application" version="0.2" status="available">
        <repo-icon src="/exist/apps/existdb-packageservice/resources/images/package.png"> </repo-icon>
        <repo-type>application</repo-type>
        <repo-title>(TEI) Graphing for eXist-db</repo-title>
        <repo-version>0.2</repo-version>
        <repo-name>http://exist-db.org/apps/tei-graphing</repo-name>
        <repo-description>(TEI) Graphing for eXist-db using libraries for dynamic visualization.</repo-description>
        <repo-authors>
            <repo-author>Leif-Jöran Olsson</repo-author>
        </repo-authors>
        <repo-abbrev>tei-graphing</repo-abbrev>
        <repo-website></repo-website>
        <repo-license>GNU-GPLv3</repo-license>
        <repo-requires processor="http://exist-db.org" semver-min="3.0.2"></repo-requires>
        <repo-changelog></repo-changelog>
        <repo-other>
            <repo-version version="0.2-SNAPSHOT" path="exist-tei-graphing-0.2-SNAPSHOT.xar">
                <repo-requires processor="http://exist-db.org"></repo-requires>
            </repo-version>
            <repo-version version="0.1-SNAPSHOT" path="exist-tei-graphing-0.1-SNAPSHOT.xar"></repo-version>
        </repo-other>
    </repo-app>
```


### install or remove a package

`/packages/action`

Will receive a post request with params from the client application.

For installation of a package the `url`,`abbrev` and `version` must be given.

For removal only the `url` must be given.

### read the url of the public repo

`packages/public-url`

Will return the http Url where the public eXist-db packages are hosted for distribution. This Url
is used by Packagemanager.

## Authorization

All functions accessing packages will test if the user has access to the given package.

## Configuration

#### remote repository server

Can be configured in configuration.xml. Currently only one server is supported but
markup is designed for extending this.

## Notes

***eXistdb Package Service has no login of its own. It is assumed that the using application
will provide a login. If called without valid credentials the service will return 'no service' message.***