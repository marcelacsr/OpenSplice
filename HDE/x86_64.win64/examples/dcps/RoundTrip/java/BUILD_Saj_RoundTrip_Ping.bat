@echo off
echo cd %~dp0
cd %~dp0
setlocal

set MAINCLASS=ping
set JARFILE=Saj_RoundTrip_Ping.jar
set MANIFEST=Saj_RoundTrip_Ping.manifest

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
del /f/s/q classes\ping.class classes\Ping_impl.class classes\Entities.class classes\ExampleUtilities.class classes\ExampleError.class 2>nul
del /f/s/q classes\Ping_impl*.class & del /f/s/q classes\ExampleUtilities*.class  2>nul

IF /I "%1"=="clean" GOTO end

:build

REM
REM Compile java code
REM
echo Creating class output dir classes\....
if not exist classes\ echo mkdir classes\
if not exist classes\ mkdir classes\
echo Compiling Java classes....
echo javac -cp "Saj_RoundTrip_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ping.java
javac -cp "Saj_RoundTrip_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ping.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of ping.java failed
  ECHO:
  GOTO error
)
echo javac -cp "Saj_RoundTrip_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ Ping_impl.java
javac -cp "Saj_RoundTrip_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ Ping_impl.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of Ping_impl.java failed
  ECHO:
  GOTO error
)
echo javac -cp "Saj_RoundTrip_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ Entities.java
javac -cp "Saj_RoundTrip_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ Entities.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of Entities.java failed
  ECHO:
  GOTO error
)
echo javac -cp "Saj_RoundTrip_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleUtilities.java
javac -cp "Saj_RoundTrip_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleUtilities.java
IF NOT %ERRORLEVEL% == 0 (
  ECHO:
  ECHO *** Java compilation of ExampleUtilities.java failed
  ECHO:
  GOTO error
)
echo javac -cp "Saj_RoundTrip_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleError.java
javac -cp "Saj_RoundTrip_Types.jar;classes\;..\..\..\..\jar\dcpssaj.jar;" -d classes\ ExampleError.java
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
echo echo Class-Path: Saj_RoundTrip_Types.jar ..\..\..\..\jar\dcpssaj.jar ^> classes\%MANIFEST%
echo Class-Path: Saj_RoundTrip_Types.jar ..\..\..\..\jar\dcpssaj.jar > classes\%MANIFEST%
echo echo Main-Class: %MAINCLASS%^>^> classes\%MANIFEST%
echo Main-Class: %MAINCLASS%>> classes\%MANIFEST%
echo pushd classes\ ^& jar %JARFLAGS% %JARFILE% %MANIFEST%  ping.class Ping_impl.class Entities.class ExampleUtilities.class ExampleError.class Ping_impl*.class ExampleUtilities*.class ^& popd
pushd classes\ & jar %JARFLAGS% %JARFILE% %MANIFEST%  ping.class Ping_impl.class Entities.class ExampleUtilities.class ExampleError.class Ping_impl*.class ExampleUtilities*.class & popd
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
