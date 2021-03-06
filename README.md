# Prosody feature extraction with speaker information
This Praat script is designed as a module based on the output of the diarization annotation tool dscore. The script takes as input a audio file and a corresponding .rttm file with speaker annotations. The script calculates the prosodic features Pitch, Harmioncity both with the auto-correlation function (AC)method and Intensity from the audio input. The features extracted are collected in time steps of 0.01 seconds, paired with the corresponding speaker information from the .rttm file. The output is stored in a \<filename>Features.txt file. Features are extracted for the entire audio file and recorded for voiced as well as unvoiced sections.

## Requirements
* Praat non GUI version is sufficient

	see e.g. http://www.fon.hum.uva.nl/praat/download_linux.html for Linux based OS

* Data output from the dscore diarization tool 
 	
 	https://github.com/cadia-lvl/dscore


## Parameter settings
The features extracted and their parameter settings are 

* Pitch: Time steps=0.01 s, Pitch floor=75 Hz, Pitch ceiling=600 Hz
* Harmonicitiy: Time steps=0.01 s, Pitch floor=75 Hz, Silence threshold = 0.1, Number of periods per window=4.5
* Intensity: Minimum pitch=75 Hz, Time step=0.01 s


## Speaker information
Speaker information is retrieved from an rttm file, assumptions are that the format of the files does not change form the following:

			SPEAKER Fréttirkl1900-5004310T0 <NA> 0.10 0.12 <NA> <NA> SpeakerTag <NA> <NA>

Assumptions are that the timing information is aligned from the beginning between the audio and .rttm files.

Output is a .txt file containing information 

			Time[s]	Pitch [Hz]	Harmac	Intensity	Speaker nr.		
			6.520	132.410		6.091	80.373		SpeakerTag1

For unvoiced sections the output 

			Time[s]	Pitch [Hz]		Harmac		Intensity	Speaker nr.	
			0.500	--undefined--	-135.415	75.025		Sil
			0.510	--undefined--	-208.007	75.829		Sil
			
## Running the script

For Linux terminal, first the path to Praat and then the command --run followed by the script name in double quotation marks finally the input directorry in double quotation marks.

		/home/eydis/bin/praat --run "FED.praat" "/home/eydis/inputFiles"

For more information e.g. for Mac or Windows see the Praat manual.  https://www.fon.hum.uva.nl/praat/manual/Scripting_6_9__Calling_from_the_command_line.html 



### Credits

Developer

	Eydis Huld Magnusdottir - eydishm@ru.is

	Language and voice lab https://lvl.ru.is/

	Reykjavik University

This is part of the Language Technology Program by The Icelandic Government through Almannaromur

### Licence
Apache 2.0
