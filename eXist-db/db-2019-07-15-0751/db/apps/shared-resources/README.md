shared-resources
================

An app package with shared resources used by several eXist-db applications


Building
--------

The latest version of shared-resources is included with eXist-db, though this might not be the newest version.
You can install a newer or second version of shared-resources by deploying it directly into the database.

To build shared-resourcese from scratch,
you should first clone shared-resources into a directory, e.g.:

     git clone git://github.com/eXist-db/shared-resources.git shared-resources
     cd shared-resources
     git submodule update --init --recursive

Next, call ant on the build.xml file in shared-resources:

     ant

You should now find a .xar file in the build directory:
     
     build/shared-resources-0.3.0.xar

The .xar file is an installable package containing shared-resources. You can install this into any eXist-db 
instance using the application repository manager in the dashboard.
