@echo off
REM
REM Mapeia drive CONNECT Corporativa (para uso MEDIS Rural)
REM

SET USR=setp06iapl06.bcpcorp.net\BONANCA
SET PWD=99785147


net use g: /DELETE   >nul
net use g: \\setp06iapl06.bcpcorp.net\connect\spensoes\rep %PWD% /USER:%USR% /PERSISTENT:NO

pause
REM
