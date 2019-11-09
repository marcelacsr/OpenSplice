@echo off
echo call BUILD_Saj_RoundTrip_Types.bat %*
call BUILD_Saj_RoundTrip_Types.bat %*
IF NOT %ERRORLEVEL% == 0 (
ECHO:
ECHO *** Error building BUILD_Saj_RoundTrip_Types.bat
ECHO:
GOTO error
)
cd %~dp0
echo call BUILD_Saj_RoundTrip_Ping.bat %*
call BUILD_Saj_RoundTrip_Ping.bat %*
IF NOT %ERRORLEVEL% == 0 (
ECHO:
ECHO *** Error building BUILD_Saj_RoundTrip_Ping.bat
ECHO:
GOTO error
)
cd %~dp0
echo call BUILD_Saj_RoundTrip_Pong.bat %*
call BUILD_Saj_RoundTrip_Pong.bat %*
IF NOT %ERRORLEVEL% == 0 (
ECHO:
ECHO *** Error building BUILD_Saj_RoundTrip_Pong.bat
ECHO:
GOTO error
)
cd %~dp0
GOTO end
:error
ECHO An error occurred, exiting now
:end
