@echo off > DOIT.BAT
for %%T in (FF.TXT) do find "SYODASE.DLL" < %%T >> REG_TS.TXT

