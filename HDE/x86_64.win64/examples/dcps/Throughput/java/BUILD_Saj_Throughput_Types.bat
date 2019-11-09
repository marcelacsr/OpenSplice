@echo off
echo cd %~dp0
cd %~dp0
setlocal

set MAINCLASS=publisher
set JARFILE=Saj_Throughput_Types.jar
set MANIFEST=Saj_Throughput_Types.manifest

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
del /f/s/q .\ThroughputModule\*.java  2>nul
del /f/s/q classes\.\ThroughputModule\*.class classes\ExampleError.class classes\ExampleUtilities.class classes\PubEntities.class classes\publisher.class classes\Publisher_impl.class classes\SubEntities.class classes\subscriber.class classes\Subscriber_impl.class 2>nul

IF /I "%1"=="clean" GOTO end

:build

REM
REM Generate java classes from IDL
REM
echo Processing ..\idl\Throughput.idl....
echo "..\..\..\..\bin\idlpp" -I "..\..\..\..\etc\idl" -l java ..\idl\Throughput.idl
"..\..\..\..\bin\idlpp" -I "..\..\..\..\etc\idl" -l java ..\idl\Throughput.idl
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Compilation of ..\idl\Throughput.idl failed
  ECHO:
  GOTO error
)


REM
REM Compile java code
REM
echo Creating class output dir classes\....
if not exist classes\ echo mkdir classes\
if not exist classes\ mkdir classes\
echo Compiling Java classes....
echo javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ .\ThroughputModule\*.java
javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ .\ThroughputModule\*.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of .\ThroughputModule\*.java failed
  ECHO:
  GOTO error
)
echo javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleError.java
javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleError.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of ExampleError.java failed
  ECHO:
  GOTO error
)
echo javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleUtilities.java
javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleUtilities.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of ExampleUtilities.java failed
  ECHO:
  GOTO error
)
echo javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ PubEntities.java
javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ PubEntities.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of PubEntities.java failed
  ECHO:
  GOTO error
)
echo javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ publisher.java
javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ publisher.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of publisher.java failed
  ECHO:
  GOTO error
)
echo javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ Publisher_impl.java
javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ Publisher_impl.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of Publisher_impl.java failed
  ECHO:
  GOTO error
)
echo javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ SubEntities.java
javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ SubEntities.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of SubEntities.java failed
  ECHO:
  GOTO error
)
echo javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ subscriber.java
javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ subscriber.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of subscriber.java failed
  ECHO:
  GOTO error
)
echo javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ Subscriber_impl.java
javac -cp "classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ Subscriber_impl.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of Subscriber_impl.java failed
  ECHO:
  GOTO error
)

REM
REM Build a jar file
REM
set JARFLAGS=cvfm
echo Building a jar file....
echo echo Class-Path: ..\..\..\..\jar\dcpssaj.jar ^> classes\%MANIFEST%
echo Class-Path: ..\..\..\..\jar\dcpssaj.jar > classes\%MANIFEST%
echo echo Main-Class: %MAINCLASS%^>^> classes\%MANIFEST%
echo Main-Class: %MAINCLASS%>> classes\%MANIFEST%
echo pushd classes\ ^& jar %JARFLAGS% %JARFILE% %MANIFEST%  .\ThroughputModule\*.class ExampleError.class ExampleUtilities.class PubEntities.class publisher.class Publisher_impl.class SubEntities.class subscriber.class Subscriber_impl.class ^& popd
pushd classes\ & jar %JARFLAGS% %JARFILE% %MANIFEST%  .\ThroughputModule\*.class ExampleError.class ExampleUtilities.class PubEntities.class publisher.class Publisher_impl.class SubEntities.class subscriber.class Subscriber_impl.class & popd
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
