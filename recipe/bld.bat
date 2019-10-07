:: QtNfc fails so we disable it for now.
:: Qt5Nfc.lib(Qt5Nfc.dll) : error LNK2005: "public: __thiscall QList<class QNdefRecord>::QList<class QNdefRecord>(class QList<class QNdefRecord> const &)" (??0?$QList@VQNdefRecord@@@@QAE@ABV0@@Z) already defined in sipQtNfcQList0100QNdefRecord.obj
:: Qt5Nfc.lib(Qt5Nfc.dll) : error LNK2005: "public: __thiscall QList<class QNdefRecord>::~QList<class QNdefRecord>(void)" (??1?$QList@VQNdefRecord@@@@QAE@XZ) already defined in sipQtNfcQList0100QNdefRecord.obj
:: Qt5Nfc.lib(Qt5Nfc.dll) : error LNK2005: "public: class QList<class QNdefRecord> & __thiscall QList<class QNdefRecord>::operator=(class QList<class QNdefRecord> const &)" (??4?$QList@VQNdefRecord@@@@QAEAAV0@ABV0@@Z) already defined in sipQtNfcQList0100QNdefRecord.obj
::    Creating library release\QtNfc.lib and object release\QtNfc.exp
:: release\QtNfc.dll : fatal error LNK1169: one or more multiply defined symbols found


setlocal EnableDelayedExpansion
set "INCLUDE=%LIBRARY_INC%;%INCLUDE%"
set "LIB=%LIBRARY_LIB%;%LIB%"


:: need to build a private copy of sip to avoid "module PyQt5.sip not found" error
echo.
echo ************** start building a private sip module **************
echo.
cd sip

%PYTHON% configure.py --sysroot=%PREFIX% --bindir=%LIBRARY_BIN% --sip-module PyQt5.sip
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1

cd ..
echo.
echo ************************ built sip module ***********************
echo.


:: build PyQt5
echo.
echo ************** start building PyQt5 **************
echo.
cd pyqt5

%PYTHON% configure.py ^
        --verbose ^
        --confirm-license ^
        --assume-shared ^
        --qmake="%LIBRARY_BIN%\qmake.exe" ^
        --bindir="%LIBRARY_BIN%" ^
        --spec=win32-msvc ^
        --enable QtWidgets ^
        --enable QtGui ^
        --enable QtCore ^
        --enable QtHelp ^
        --enable QtMultimedia ^
        --enable QtMultimediaWidgets ^
        --enable QtNetwork ^
        --enable QtXml ^
        --enable QtXmlPatterns ^
        --enable QtDBus ^
        --enable QtWebSockets ^
        --enable QtWebChannel ^
        --disable QtNfc ^
        --enable QtOpenGL ^
        --enable QtQml ^
        --enable QtQuick ^
        --enable QtQuickWidgets ^
        --enable QtSql ^
        --enable QtSvg ^
        --enable QtDesigner ^
        --enable QtPrintSupport ^
        --enable QtSensors ^
        --enable QtTest ^
        --enable QtBluetooth ^
        --enable QtLocation ^
        --enable QtPositioning ^
        --enable QtSerialPort
if errorlevel 1 exit 1

jom
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1

cd ..
echo.
echo ******************* built PyQt5 ******************
echo.


:: install PyQtWebEngine
echo.
echo ************** start building PyQtWebEngine **************
echo.
cd pyqtwebengine

%PYTHON% configure.py
if errorlevel 1 exit 1

nmake
if errorlevel 1 exit 1

nmake install
if errorlevel 1 exit 1

cd ..
echo.
echo ****************** built PyQtWebEngine *******************
echo.
