@echo off
setlocal

set "PROJECT_ROOT=%~dp0.."
if exist "%PROJECT_ROOT%\.venv-epub\Scripts\python.exe" (
  "%PROJECT_ROOT%\.venv-epub\Scripts\python.exe" "%PROJECT_ROOT%\tools\epub_import.py" %*
) else (
  where py >nul 2>nul
  if not errorlevel 1 (
    py -3 "%PROJECT_ROOT%\tools\epub_import.py" %*
  ) else (
    python "%PROJECT_ROOT%\tools\epub_import.py" %*
  )
)
exit /b %errorlevel%
