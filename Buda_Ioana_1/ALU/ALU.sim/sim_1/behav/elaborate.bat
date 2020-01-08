@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.4\\bin
call %xv_path%/xelab  -wto 9b2cadfcc78d48318bcde68fb74ec12b -m64 --debug typical --relax --mt 2 -L xil_defaultlib -L secureip --snapshot DivisionTest_behav xil_defaultlib.DivisionTest -log elaborate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
