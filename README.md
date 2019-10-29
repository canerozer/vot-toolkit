The VOT evaluation kit
======================

This repository contains the official evaluation kit for the [Visual Object Tracking (VOT) challenge](http://votchallenge.net/). The repository contains the actual evaluation toolkit as a set of Matlab (Octave compatible) scripts, a documentation and a set of integration examples for different programming languages.

For more detailed informations consult the documentation available in the source or a compiled version of the documentation [here](http://www.votchallenge.net/howto/). You can also subscribe to the VOT [mailing list](https://service.ait.ac.at/mailman/listinfo/votchallenge) to receive news about challenges and important software updates or join our [support form](https://groups.google.com/forum/?hl=en#!forum/votchallenge-help) to ask questions.

Click [here](http://toolkit.votchallenge.net) to browse and download the latest official releases of the toolkit.

Developers
----------

* Luka Čehovin (lead developer)
* Tomáš Vojíř
* Alan Lukežič

Contributors
------------

* Georg Nebehay
* Heng Cherkeng
* Stefan Duffner
* Mario Maresca
* Klaus Haag
* Alessio Dore
* Alan Torres
* Rok Mandeljc

License
-------

The evaluation toolkit code and the documentation is available under GPL 3 license. The tracker examples are available under various licenses.

Enquiries, Question and Comments
--------------------------------

If you have any further enquiries, question, or comments, please refer to the contact infromation link on the [VOT homepage](http://votchallenge.net/). If you would like to file a bug report or a feature request, use the  [Github issue tracker](https://github.com/vicoslab/vot-toolkit/issues). **The issue tracker is for toolkit issues only**, if you have a problem with tracker integration or any other questions, please use our [support forum](https://groups.google.com/forum/?hl=en#!forum/votchallenge-help).

Things to do after opening Octave
--------
1) Enter to the workspace directory inside vot-toolkit and try to run the script: run_test.m even without specifying the tracker settings.
2) Use these two commands for loading some MATLAB commands that exist in different packages of Octave:
    * pkg load image
    * pkg load statistics
3) If you encounter ... error when analyzing the trackers due to experiment argument, convert experiment to mat format by adding the following line to the top of the function:
    experiment = cell2mat(experiment); 
#TODO: @analyze_failures used in report_failures.m creating some sort of a problem, will be examined later. 
