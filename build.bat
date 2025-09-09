@echo off
setlocal enabledelayedexpansion

echo Narrative Presentation - Standalone HTML Builder
echo ================================================
echo.

REM Check if PowerShell is available
powershell -Command "Write-Host 'PowerShell is available'" >nul 2>&1
if %ERRORLEVEL% NEQ 0 (
    echo Error: PowerShell is not available on this system.
    echo Please install PowerShell or use the .ps1 script directly.
    pause
    exit /b 1
)

REM Ask for markdown file name
set /p INPUT_FILE="Enter the markdown file name (e.g., presentation.md): "

REM Remove quotes if present
set INPUT_FILE=%INPUT_FILE:"=%

REM Check if file exists
if not exist "%INPUT_FILE%" (
    echo Error: File '%INPUT_FILE%' not found.
    echo Please make sure the file exists in the current directory.
    pause
    exit /b 1
)

REM Check file extension
if /i not "%INPUT_FILE:~-3%"==".md" (
    echo Error: File must have .md extension.
    pause
    exit /b 1
)

REM Generate output filename by replacing .md with .html
set OUTPUT_FILE=%INPUT_FILE:.md=.html%

echo.
echo Building standalone HTML...
echo Input:  %INPUT_FILE%
echo Output: %OUTPUT_FILE%
echo.

REM Run the PowerShell script
set "SCRIPT_PATH=%~dp0scripts\build-standalone.ps1"
set INPUT_PARAM=%INPUT_FILE%
set OUTPUT_PARAM=%OUTPUT_FILE%
powershell -ExecutionPolicy Bypass -Command "& '%SCRIPT_PATH%' -InputFile '%INPUT_PARAM%' -Output '%OUTPUT_PARAM%'"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo Success! Standalone HTML file created: %OUTPUT_FILE%
    echo.
    echo You can now open %OUTPUT_FILE% in any browser.
) else (
    echo.
    echo Error: Failed to build standalone HTML file.
)

echo.
pause
