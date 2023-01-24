del ..\DatasetCreation\CORPUS\evaluationSHACL.txt
java -Xms40G -cp .;./build/classes;./lib/* -Dfile.encoding=utf-8 DetectViolationsOnCorpus "licenceusecaseTBox.owl" "INDEXED_RULES" "compliancerules.ttl" "../DatasetCreation/CORPUS/SHACL"
REM exit