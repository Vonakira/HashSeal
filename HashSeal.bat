@echo off
chcp 65001 >nul
setlocal EnableDelayedExpansion

set "success=0"
set "fail=0"
set "missing=0"
set "generated=0"
set "mode="

if "%~1"=="" (
    echo 📜 请将待呈卷宗拖至此令执行（多份可一并呈递） 
    echo 拖拽后松手即可开始 
    pause
    exit /b
)

REM 🧼 清屏 + 重绘界面 
cls
echo =========================================
echo        📦 哈希生成 + 校验工具 
echo        by 棉花 · 优雅但不复杂 
echo =========================================

if /I "%~x1"==".sha256" (
    set "mode=verify"
    echo 📜 卷宗已呈 候命查验 
    echo ===== 🔍 封签查验 =====
) else (
    set "mode=generate"
    echo 📜 卷宗已呈 候命封签 
    echo ===== 📦 封签制备 =====
)
echo.

:loop
if "%~1"=="" goto done

call :processOne "%~1"
shift
goto loop

:processOne
set "FILE=%~1"
set "EXT=%~x1"
set "NAME=%~nx1"
set "BASE=%~dp1"

if /I "%EXT%"==".sha256" goto verifyOne
goto generateOne

:generateOne
echo 【正封签】"%NAME%"
set "HASH="
call :gethash "%FILE%" HASH

if not defined HASH (
    echo ⚠ 无法读取卷宗："%NAME%"
    echo.
    call :inc fail
    exit /b
)

set "OUT=%~1.sha256"
> "%OUT%" echo %HASH%  %NAME%
echo ✔ 已封签："%NAME%.sha256"
echo.

call :inc generated
exit /b

:verifyOne
echo 【查验封签】"%NAME%"

for /f "usebackq delims=" %%L in ("%FILE%") do call :parseLine "%%L" "%BASE%"

echo.
exit /b

:parseLine
setlocal DisableDelayedExpansion
set "LINE=%~1"
set "BASE=%~2"
set "EXPECTED="
set "REST="
set "NAME="
set "TARGET="
set "ACTUAL="

for /f "tokens=1* delims= " %%A in ("%LINE%") do (
    set "EXPECTED=%%A"
    set "REST=%%B"
)

set "NAME=%REST%"
if "%NAME:~0,1%"==" " set "NAME=%NAME:~1%"
set "TARGET=%BASE%%NAME%"

if not exist "%TARGET%" (
    echo ⚠ 卷宗缺失："%NAME%"
    endlocal & call :inc missing & exit /b
)

call :gethash "%TARGET%" ACTUAL

if /I "%ACTUAL%"=="%EXPECTED%" (
    echo ✔ 卷宗无误："%NAME%"
    endlocal & call :inc success & exit /b
) else (
    echo ✖ 卷宗异常："%NAME%"
    echo     期望值：%EXPECTED%
    echo     实际值：%ACTUAL%
    endlocal & call :inc fail & exit /b
)

:inc
set /a %~1+=1
exit /b

:gethash
set "result="
for /f "skip=1 tokens=*" %%H in ('certutil -hashfile "%~1" SHA256') do (
    set "result=%%H"
    goto donehash
)
:donehash
set "result=%result: =%"
set "%~2=%result%"
exit /b

:done
echo ===== 🔚 卷宗处理完毕 =====
echo.

if "%mode%"=="generate" (
    echo 📜 本批 %generated% 份封签已制备完毕！微臣告退～ 
    echo 皇上请过目 
    if %fail% gtr 0 (
        echo ⚠ 其中有 %fail% 份封签制备失败
    )
) else (
    echo -------- 封签查验结果 --------
    echo ✔ 卷宗无误：%success%
    echo ✖ 卷宗异常：%fail%
    echo ⚠ 卷宗缺失：%missing%
    echo --------------------------
    echo.

    if %fail%==0 if %missing%==0 (
        echo 📜 卷宗已尽数查验，无一差误。臣告退～ 
        echo 皇上安心便是 
    ) else (
        echo 🤨 于卷宗中发现异常，请准予逐项复核。 
        echo 皇上请留意 
    )
)

pause
exit /b