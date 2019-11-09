@echo off
echo call java/BUILD_Saj_Throughput_Types.bat %*
call java/BUILD_Saj_Throughput_Types.bat %*
IF NOT %ERRORLEVEL% == 0 (
ECHO:
ECHO *** Error building java/BUILD_Saj_Throughput_Types.bat
ECHO:
GOTO error
)
cd %~dp0
echo call java/BUILD_Saj_Throughput_Publisher.bat %*
call java/BUILD_Saj_Throughput_Publisher.bat %*
IF NOT %ERRORLEVEL% == 0 (
ECHO:
ECHO *** Error building java/BUILD_Saj_Throughput_Publisher.bat
ECHO:
GOTO error
)
cd %~dp0
echo call java/BUILD_Saj_Throughput_Subscriber.bat %*
call java/BUILD_Saj_Throughput_Subscriber.bat %*
IF NOT %ERRORLEVEL% == 0 (
ECHO:
ECHO *** Error building java/BUILD_Saj_Throughput_Subscriber.bat
ECHO:
GOTO error
)
cd %~dp0
GOTO end
:error
ECHO An error occurred, exiting now
:end
