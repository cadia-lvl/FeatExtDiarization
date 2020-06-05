# Authour: Eydis Huld Magnusdottir
# RLS 05/2020
# This script extracts Pitch, Harmonicity and Intensity information from a audio file and adds speaker 
# information from a corresponding rttm diarization infromation file.
#######################################################################################

i_directory$ = shellDirectory$
strings = Create Strings as file list: "list", i_directory$ + "/*.wav"
numberOfFiles = Get number of strings

for ifile to numberOfFiles
    selectObject: strings
    wavfileName$ = Get string: ifile
    Read from file: i_directory$ + "/" + wavfileName$

	fileName$ = wavfileName$-".wav"
	rttmfileName$ = fileName$+".rttm"
	txtfileName$ = fileName$+"Features.txt"

	deleteFile: txtfileName$

	header_row$ =  "Time" + tab$ + "Pitch" + tab$ + "HarmAC" + tab$ + "Intensity" + tab$ + "Speaker" + newline$ 
	appendFile: txtfileName$, header_row$

	# Read information from rttm file
	Read Strings from raw text file: rttmfileName$
	numberOfStrings = Get number of strings

	for stringNumber from 1 to numberOfStrings
		string$ = Get string: stringNumber 

	# removing 5 columns of the rttm file containing <NA>, WARNING this is not reliable might need to review for strings with some <NA> and some not that we need
		stringNA$=replace$( string$," <NA>", "",5)
	# Removing all strings before the actual numbers appear
		lengthAll=length(stringNA$)
		timeStartIndex = index(stringNA$,fileName$ )
		lengthIndex= length (fileName$ )
		stringTimeNA$ = right$ (stringNA$, lengthAll-timeStartIndex-lengthIndex)
	# Extracting the start of period of speech timing
		start [stringNumber]=number(stringTimeNA$)
	# Removing the start of period of speech timing
		lengthS=index(stringTimeNA$," ")
		lengthA=length(stringTimeNA$)
		stringTimeNA$ = right$ (stringTimeNA$, lengthA-lengthS)
	# Extracting duration of speehc period
		dur[stringNumber] =number(stringTimeNA$)
	# Removing the duration period of speech leaving speaker information 	
		lengthS=index(stringTimeNA$," ")
		lengthA=length(stringTimeNA$)
		stringSpeaker$ [stringNumber] = right$ (stringTimeNA$, lengthA-lengthS)
	endfor

	# Read audio file
	Read from file: wavfileName$

	# Extract features
	sound = selected ("Sound")
	tmin= Get start time
	tmax = Get end time

	To Pitch: 0, 75, 600 
	Rename: "pitch"

	selectObject: sound
	To Harmonicity (ac):  0.01, 75, 0.1, 4.5
	Rename: "harmac"

	selectObject: sound
	To Intensity:  75, 0.001
	Rename: "intensity"

	# Extract all information into .txt file
	start[numberOfStrings+1]=tmax
	i=1
	time=tmin

	for k from 1 to numberOfStrings
		repeat 
			selectObject:  "Pitch pitch"
			pitch = Get value at time:  time, "Hertz", "Linear"
			selectObject: "Harmonicity harmac"
			harmac = Get value at time: time, "Cubic"
			selectObject: "Intensity intensity"
			intensity=Get value at time: time, "Cubic"

		if time <start[k] + dur[k] 
			speaker$ = stringSpeaker$ [k]
			appendFile: txtfileName$,  fixed$ (time,3), tab$ , fixed$ (pitch,3), tab$, fixed$ (harmac,3), tab$, fixed$ (intensity,3), tab$,  speaker$, newline$
			time = tmin + i* 0.01
			i=i+1
		else
			appendFile: txtfileName$, fixed$ (time,3), tab$ , fixed$ (pitch,3), tab$, fixed$ (harmac,3), tab$, fixed$ (intensity,3), tab$,  "Sil",  newline$
			time = tmin + i* 0.01
			i=i+1
		endif
	until  start[k+1]< time
	endfor
endfor

