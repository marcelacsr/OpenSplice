@echo off
echo cd %~dp0
cd %~dp0
setlocal

set MAINCLASS=subscriber
set JARFILE=Saj_Throughput_Subscriber.jar
set MANIFEST=Saj_Throughput_Subscriber.manifest

IF [%1]==[] GOTO build
IF /I "%1"=="clean" GOTO clean
IF /I "%1"=="rebuild" GOTO clean
ECHO Error: unrecognised option: %1
GOTO error

:clean
REM
REM Clean any previous output
REM
echo Cleaning...
del /f/s/q classes\%MANIFEST% 2>nul
del /f/s/q classes\subscriber.class classes\Subscriber_impl.class classes\SubEntities.class classes\ExampleUtilities.class classes\ExampleError.class 2>nul
del /f/s/q classes\Subscriber_impl*.class & del /f/s/q classes\ExampleUtilities*.class  2>nul

IF /I "%1"=="clean" GOTO end

:build

REM
REM Compile java code
REM
echo Creating class output dir classes\....
if not exist classes\ echo mkdir classes\
if not exist classes\ mkdir classes\
echo Compiling Java classes....
echo javac -cp "Saj_Throughput_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ subscriber.java
javac -cp "Saj_Throughput_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ subscriber.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of subscriber.java failed
  ECHO:
  GOTO error
)
echo javac -cp "Saj_Throughput_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ Subscriber_impl.java
javac -cp "Saj_Throughput_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ Subscriber_impl.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of Subscriber_impl.java failed
  ECHO:
  GOTO error
)
echo javac -cp "Saj_Throughput_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ SubEntities.java
javac -cp "Saj_Throughput_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ SubEntities.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of SubEntities.java failed
  ECHO:
  GOTO error
)
echo javac -cp "Saj_Throughput_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleUtilities.java
javac -cp "Saj_Throughput_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleUtilities.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of ExampleUtilities.java failed
  ECHO:
  GOTO error
)
echo javac -cp "Saj_Throughput_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleError.java
javac -cp "Saj_Throughput_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleError.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of ExampleError.java failed
  ECHO:
  GOTO error
)

REM
REM Build a jar file
REM
set JARFLAGS=cvfm
echo Building a jar file....
echo echo Class-Path: Saj_Throughput_Types.jar ..\..\..\..\jar\dcpssaj.jar ^> classes\%MANIFEST%
echo Class-Path: Saj_Throughput_Types.jar ..\..\..\..\jar\dcpssaj.jar > classes\%MANIFEST%
echo echo Main-Class: %MAINCLASS%^>^> classes\%MANIFEST%
echo Main-Class: %MAINCLASS%>> classes\%MANIFEST%
echo pushd classes\ ^& jar %JARFLAGS% %JARFILE% %MANIFEST%  subscriber.class Subscriber_impl.class SubEntities.class ExampleUtilities.class ExampleError.class Subscriber_impl*.class ExampleUtilities*.class ^& popd
pushd classes\ & jar %JARFLAGS% %JARFILE% %MANIFEST%  subscriber.class Subscriber_impl.class SubEntities.class ExampleUtilities.class ExampleError.class Subscriber_impl*.class ExampleUtilities*.class & popd
echo move /y classes\%JARFILE% .
move /y classes\%JARFILE% .
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Building jar file %JARFILE% failed
  ECHO:
  GOTO error
)

GOTO end

:error
ECHO An error occurred, exiting now
:end
