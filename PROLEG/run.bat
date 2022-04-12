cd ../DatasetCreation/CORPUS
del evaluationPROLEG.txt
cd ../../PROLEGreasoner
echo off
echo FILE: prolegABox_Size10_Probability50_num0.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size10_Probability50_num0.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo FILE: prolegABox_Size30_Probability50_num0.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size30_Probability50_num0.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo FILE: prolegABox_Size50_Probability50_num0.pl >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p BEFORE=<time.txt
del time.txt
swipl -q -f ../DatasetCreation/CORPUS/PROLEG/prolegABox_Size50_Probability50_num0.pl -t goal >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
java time>time.txt
set /p AFTER=<time.txt
del time.txt
set /a "c=%AFTER%-%BEFORE%"
echo Time: %c%ms >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt
echo ----------------------------------------------------------- >> ../DatasetCreation/CORPUS/evaluationPROLEG.txt