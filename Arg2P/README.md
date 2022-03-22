<p align="justify">
This folder contains the implementation of the use case as <a href="https://apice.unibo.it/xwiki/bin/view/Arg2p/WebHome">Arg2P rules</a>. The use case has been implemented within the file <b> regulative+compliance_rules.arg2p </b>. This file must be included within the folder "<a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DatasetGenerator/CORPUS/SPINdle">CORPUS/SPINdle</a>" (<u>you can find it <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DatasetGenerator/CORPUS/SPINdle">there</a>) because the dataset generator will (externally) ground the rules before invoking the reasoner. This is a mandatory step because SPINdle's input format is propositional.
</p>

<p align="justify">
The file <b>regulative+compliance_rules.dfl</b> contains both the regulative rules, able to infer which actions of the state of affairs are prohibited, obligatory, or permitted, and the rules for checking compliance of the derived prohibitions and obligations.
</p>

<p align="justify">The file <b>regulative+compliance_rules.dfl</b> derives a violation for either all prohibitions that took place in the state of affairs and were not compensated <i>and</i> for all obligations that did not take place in the state of affairs and were not compensated.</p>

<p align="justify">
The state of affairs is described in one of the synthetic datasets (ABox) created by the <a href="https://github.com/liviorobaldo/compliancecheckers/tree/main/DatasetGenerator">dataset generator available on this GitHub</a>. Each ABox contains both the (indexed) SPINdle rules and the (indexed) input propositional symbols.
</p>

<p align="justify">
In order to execute SPINdle rules, you need the file <b>spindle_2.2.4.jar</b> that you may download from <a href="https://sourceforge.net/projects/spindlereasoner/">this link</a>. Then, on Windows you just write the following instruction on a shell:
</p>

<p align="center">
<i>java -cp .;./* -Dfile.encoding=utf-8 DetectViolationsOnCorpus .\CORPUS\SPINdle >> .\CORPUS\evaluationSPIndle.txt</i>
</p>

<p align="justify">
The execution of the above instruction will <i>append</i> (>>) the evaluation of each ABox in the CORPUS folder within the file <b>evaluationSPINdle.txt</b>. If this file does not yet exist, it will be created. Similar scripts can be used to compile and run the files on other operating systems. 
</p>
