@echo off
setlocal ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

set "SOURCE_FILE=.project_rel"
set "TARGET_FILE=.project"
set "TMP_FILE=%TARGET_FILE%.tmp"
set "TOKEN=PARENT-2-PROJECT_LOC"

REM === Compute absolute path two levels up ===
pushd "%CD%\..\.."
set "REPLACEMENT=%CD%"
popd

REM === Convert backslashes to forward slashes ===
set "REPLACEMENT=!REPLACEMENT:\=/!"

REM === Copy source to temp ===
copy "%SOURCE_FILE%" "%TMP_FILE%" >nul
if errorlevel 1 (
    echo Failed to copy to temporary file.
    exit /b 1
)

REM === Replace token in temp file ===
set "TMP2_FILE=%TMP_FILE%.2"

(
  for /f "usebackq delims=" %%L in ("%TMP_FILE%") do (
    set "LINE=%%L"
    set "LINE=!LINE:%TOKEN%=%REPLACEMENT%!"
    echo(!LINE!
  )
) > "%TMP2_FILE%"

move /Y "%TMP2_FILE%" "%TMP_FILE%" >nul

REM === Replace target ===
move /Y "%TMP_FILE%" "%TARGET_FILE%" >nul
if errorlevel 1 (
    echo Failed to replace target file.
    exit /b 1
)

echo File replaced su
