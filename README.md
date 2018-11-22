jPickerV2
author: JIANG Yiran  Email:2320140745@qq.com
a program to automaticlly detect earthquakes and determine the arrival times of its P S phases it mainly based on supoort vector machine and can be applied on array data.

our method are designed for 50HZ sac files. You may have to convert the format and resample to this type or we would do resample automatically in our program. the whole program is mainly designed to process the full-day record but we also provide a function to picking phase on a short record for specific events. 

install step:

  1 compile files
    cd tool/SLR;mex SLRC.cpp; : we provide a way to calculate SLR(Allen, 1978) in 'C' using mex in MATLAB. it doesn't matter if you don't want to mex this file, as we provide an alternative option to do this without mexing which only costs a little longer time than the 'C' one.

  fortCompiler -O3 velest.f : cd tool/VELSVM/ and compile the main file. We recommend you using ifort compiler which can optimize the speed of locating process obviously

 2 set paths, parameters and other things
   edit setPath.m : 
        workDir: the main folder's path
        dataDir: the path of the folder saving sac files
        matDir:  the path of the folder saving the waveform data in .mat 
                 we provide an option to save the main waveform data in .mat form. You can review it by loading this files. it also contains some other informations. 
   edit setPara.m :
                 you can see the meaning of these detailed parameters in this file and adjust it according to your need.
   edit staLst : 
                 give the station list in this format: net station component(ex. BH HH) longitude(-: W) latitude(-: S)
                 the number of station should be less than 26^2;(recommend: 10~50)
   edit sacFileName.m  :
                 input the net station comp dayNum, output the relative paths of three sac file in dataDir
                 you should adjust the function according to your situation.
   edit setPicker.m    :
                set some parameters using in SVM's picker. you can see details in it

 3 initialize the program:
   initPicker : We have write a script to initialize the environment according to your setting
   genQuake0Sim : the function will generate some simulate quakes in tool/locFunc/quake0Sim.mat to help us locate quakes
                  if you have already found some good quakes, you can overwrite the mat file. the number of quakes should be about 200.
   genNewModelasp : to generate a mat file saving the veloctity model used in mattaup
                    you can chang the velocity structure in tool/mattaup/iasp91.tvel
   loadFile: load some file that we will use in the process

 4 run
   day=dayPick(sDay0,machineIsPhase,machineIsP) : pick on one day's data. as we run loadFile before, the machineIsPhase and machineIsP is alread in the workPlace. you just specific the day sDay0 you want to scan, it will return a day structure witch contains the found quakes.

    pickAIV2 : if you want to do pick-up on all the days, just run it. it will call dayPick to pick on each day. 


data struct：

  time: we use datenum to mark the time. it's a matlab function witch can convert time into a number. this number indicates how many day it is from 0000-00-00-0000. So, 1 secand will be convert into 1/86400 day.

  airrval time: to simplify the expression of arrival time, we introduce a 1-d array to record the arrival time. we would use datnum form. the stations‘ elements are numbered according to the sequence in staLst. if one element is zeros, it means do not find or can't determine the phase and its arrival time in the specific staion.
      pTime/sTime: we use this two kinds of arrays to present two different phases' arrival times in the above form

  quake: {pTime;sTime;PS}. for one quake, we'd use a quake struct to indicate. it has three parts as we show. pTime and sTime are the arrival times in different stations. PS provides more information about the quake [origin time;latitude；longitude；depth；magnitude]. we just simpliy estimate the magnitude according to the waveform data. if you are going to use quakes' magnitudes in your research we strongly recommend you to calculate these by yourself

  latitude/longitude: E/N:+, W/S:-

  depth: km

  day: {n*quake}. a day struct will contain many quakes in quake struct. 


  pick on a single station:
       [pIndex,sIndex]=pPickerSingle(pIndex0,sIndex0,data,toDoLst,machineIsPhase,machineIsP)
       this function proviede a way to do phasePicking on a single station. the waveform data is a N*3 mat which contains three components(E/N/Z). pIndex0/sIndex0 is the phase's estimated arrival time's index. if you cannot give a accurate pIndex0 or sIndex0, just set them all 0 then the function would pick on the whole data and pick the first phase as P.
       toDoLst is a parameter array to determine the way to pick: [svmPickP aicPickP svmPickS]. when one element is set to 1/0, the function will do or not do the corresponding picking. the default setting is [1 1 1]
       machineIsPhase/machineIsP: the already trained machines used in picking. they are stored in the tool/SVM/machineIsPhase.mat and tool/SVM/machineIsP.mat
       the function will return the index of P/S phase's arrival time. if the indexis equal to 0, it means no phase of such type found.