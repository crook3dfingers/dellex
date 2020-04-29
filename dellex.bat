@echo off

if "%~1"=="" (
	powershell -executionpolicy remotesigned -File .\get-dllexe-versions.ps1
) else (
	if "%~2"=="" (
		powershell -executionpolicy remotesigned -File .\get-dllexe-versions.ps1 -path %1
	) else (
		powershell -executionpolicy remotesigned -File .\get-dllexe-versions.ps1 -path %1 -output %2
	)
)