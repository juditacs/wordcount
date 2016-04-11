@echo off
FOR /L %%i IN (1,1,4) DO (
	type .\..\data\test\test%%i.in | php wordcountRevB.php >> test.out
	FC test.out .\..\data\test\test%%i.out
	del test.out
)
@echo on