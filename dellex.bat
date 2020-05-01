@echo off

if "%~1"=="" (
	powershell -executionpolicy remotesigned -File .\dellex.ps1
) else (
	if "%~2"=="" (
		powershell -executionpolicy remotesigned -File .\dellex.ps1 -path %1
	) else (
		if "%~3"=="" (
			powershell -executionpolicy remotesigned -File .\dellex.ps1 -path %1 -output %2
		) else (
			powershell -executionpolicy remotesigned -File .\dellex.ps1 -path %1 -output %2 -includeloc
		)
	)
)
