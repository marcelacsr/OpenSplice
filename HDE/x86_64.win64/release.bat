@echo off
echo "<<< Vortex OpenSplice HDE Release 6.9.181127OSS For x86_64.win64, Date 2018-11-28 >>>"
if "%SPLICE_ORB%"=="" set SPLICE_ORB=DDS_OpenFusion_1_6_1
set OSPL_HOME=%~dp0
set PATH=%OSPL_HOME%\bin;%OSPL_HOME%\lib;%OSPL_HOME%\examples\lib;%PATH%
set OSPL_TMPL_PATH=%OSPL_HOME%\etc\idlpp
if "%OSPL_URI%"=="" set OSPL_URI=file://%OSPL_HOME%\etc\config\ospl.xml
