cd ../DatasetCreation/CORPUS
del evaluationPROLEG.txt
cd ../../PROLEGreasoner
echo off
echo FILE: prolegABox_Size100_Probability50.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size100_Probability50.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo FILE: prolegABox_Size10_Probability50.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size10_Probability50.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo FILE: prolegABox_Size20_Probability50.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size20_Probability50.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo FILE: prolegABox_Size30_Probability50.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size30_Probability50.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo FILE: prolegABox_Size40_Probability50.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size40_Probability50.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo FILE: prolegABox_Size50_Probability50.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size50_Probability50.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo FILE: prolegABox_Size60_Probability50.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size60_Probability50.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo FILE: prolegABox_Size70_Probability50.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size70_Probability50.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo FILE: prolegABox_Size80_Probability50.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size80_Probability50.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo FILE: prolegABox_Size90_Probability50.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size90_Probability50.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
