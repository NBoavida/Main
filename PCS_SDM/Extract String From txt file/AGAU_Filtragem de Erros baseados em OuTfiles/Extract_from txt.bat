@echo off > DOIT.BAT

Echo **********************  Data Nascimento ****************************** > analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
for %%T in (ff_20131231T594000536504.out) do find "is not a valid AllXsd value" < %%T >> analise.TXT
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo **********************  NOME DO CLIENTE INVALIDO****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
for %%T in (ff_20131231T594000536504.out) do find "NOME DO CLIENTE INVALIDO" < %%T >> analise.TXT
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo **********************O codigo postal introduzido nao existe ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
for %%T in (ff_20131231T594000536504.out) do find "O codigo postal introduzido nao existe" < %%T >> analise.TXT
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo **********************Conta associada a Entidade ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
for %%T in (ff_20131231T594000536504.out) do find "Conta associada a Entidade" < %%T >> analise.TXT
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo **********************Entidade Ja existente****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
for %%T in (ff_20131231T594000536504.out) do find "Entidade Ja existente" < %%T >> analise.TXT
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** MORADA INVALIDA****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
for %%T in (ff_20131231T594000536504.out) do find "MORADA INVALIDA" < %%T >> analise.TXT
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** AWAITING CLIENT ADD IN PAXUS****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
for %%T in (ff_20131231T594000536504.out) do find "AWAITING CLIENT ADD IN PAXUS" < %%T >> analise.TXT
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** NOME PARA CARTAO INVALIDO****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
for %%T in (ff_20131231T594000536504.out) do find "NOME PARA CARTAO INVALIDO" < %%T >> analise.TXT
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** Morada associada a Entidade /Referencia Paxus a vazio. Voltar a submeter****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
Echo ********************** ****************************** >> analise.txt
for %%T in (ff_20131231T594000536504.out) do find "Morada associada a Entidade /Referencia Paxus a vazio. Voltar a submeter" < %%T >> analise.TXT
Echo ********************** ****************************** >> analise.txt



