# Eiffel Orient DB interface


## Overview

The Eiffel Orient DB interface (eODB) provides Eiffel users with an interface towards the Orient DB graph database http://www.orientechnologies.com/orientdb/

This layer is multi-platform: it can be used on Windows, Linux operating systems ( TBD)

Main features

* Create a graph databse in Orient DB, class GRAPHDATABASE
* Create and manage Vertexes in Orient DB, class VERTEX
* Create and manage Edges in Orient DB, class EDGE


## Project

Official project site:

* https://github.com/andersoxie/eODB/

For more information please have a look at the related wiki:

* https://github.com/andersoxie/eODB/wiki

## Requirements
* Compiling from EiffelStudio 13.11 and more recent version of the compiler.
* Developped using EiffelStudio 13.11 (on Windows)
* Tested using EiffelStudio 13.11 with auto test cases included in this repository
* The code have to use void-safe compilation (see [more about void-safety](http://docs.eiffel.com/book/method/void-safe-programming-eiffel) )

* It was developed with Orient DB version 1.3.0. That version of Orient DB includes an error when deleting vertexes/edges that was reported and
  verified corrected in a beta version of 1.4.0.
  This version is now migrated to support version 1.7 RC2 which is a major change due to change of API.

## How to get the source code?

Using git 
* git clone https://github.com/andersoxie/eODB.git

## How to build

* Install and configure Orient DB.

* To build the java source, update the file buildjavaclasses.bat with the correct paths and then execute it.

* Build your Eiffel project

# To execute a program that use Orient DB.

* Start an Orient DB server by executing server.bat in the bin folder of the installation

* Start your Eiffel program


## Test cases for eODB

* Build the Eiffel project eODB-safe-test and execute the AutoTest test cases

## Examples
TBD, but see test cases for some help

## Contributing to this project

Anyone and everyone is welcome to contribute. Please take a moment to
review the [guidelines for contributing](CONTRIBUTING.md).

* [Bug reports](CONTRIBUTING.md#bugs)
* [Feature requests](CONTRIBUTING.md#features)
* [Pull requests](CONTRIBUTING.md#pull-requests)

## Community

For more information please have a look at the related wiki:
* https://github.com/andersoxie/eODB/wiki
