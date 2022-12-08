# Krazy Karaoke

## Goals and Motivation
Our aim was to learn about, and utilize some of the features that make FPGAs useful in real world applications in fun and demonstrable way.

We decided to create a Karaoke game because that would let us learn to use:

- ADC
- DSP
- VGA
- Audio Output

We thought Krazy Karaoke would be a fun and interactive way to show these features that could also be played as an actual game.
The project could also be generalized to frequency (pitch) detection hardware

## High-Level Overview of Functionality

To play the game a player would:

1. Press start to record a reference track that they want to sing into the FPGA
2. Switch the recording bank and press start
3. Sing the song, attempting to match the notes and timing of the reference song
4. The average of the scores for each note will be displayed on the VGA as the scoring module produces them.
5. When the song is over the score displayed is the overall average score

## High-Level Specification

In order to accomplish the goal, the design had to:
- Convert raw audio input to digital signal
- Convert digital signal to a frequency
- Compare the frequencies and score
- Display score and output audio

### Krazy Karaoke Diagram
![alt text](https://github.com/ianjchadwick/551_Project/blob/main/supplemental_files/schematics%20and%20diagrams/Final%20Krazy%20Karaoke%20High%20Level%20Diagram.jpeg?raw=true "Krazy Karaoke Diagram")

The design can be broken down into three core components of the overall workflow:
- Component 1: Getting analog sound waves to block RAM
- Component 2: Converting digitized audio into a frequency
- Component 3: Comparing and scoring frequencies

### Component 1:

### Component 2:

### Component 3: Comparing and Scoring
#### The flow of the comparing and scoring algorithm is as follows:
1. The FFT module will output into one of two FIFOs. 
2. First, during the portion of the game where the reference song is being recorded and  then transformed, the resulting frequencies go into the reference FIFO
3. During the portion of the game where the user is singing the song, the frequencies go into the song FIFO
4. The “valid” signals from each FIFO are ANDed together to provide the “start” signal to the Comparison/Scoring state machine.
5. The state machine starts in the IDLE state. Once the start is received, the state machine will pop the next value off of each queue and register the values and proceed to teh OCTAVES state.
6. In the OCTAVES state, the octave of the reference frequency is determined. At the same time all the notes in the octave above and below the reference note are then calculated (using bit shift multiplication). This is completed in one clock cycle.
7. The next state is the CENTER state where the frequencies of the notes from the previous step are then put into the appropriate octave bins.
8. In the final SCORE state, the sung frequency is then compared to each of these bins +/- an accepted range and an output score is calculated. The accepted range for each score bracket depends on the octave. Notes in the lower octaves (0, 1, etc.) are closer in frequency to eachother than notes at higher octaves (8, 7, etc.). So to compensate the allowed range is adjusted according to the note spacing in the spectrum of frequncies. 
- The output score is then captured by a tally module, which keeps the average. This average is then output to the VGA display.
![alt text](https://github.com/ianjchadwick/551_Project/blob/main/supplemental_files/schematics%20and%20diagrams/score_and_fifos.JPG?raw=true "FIFOs, Score Module and Tally Module")

The scoring state machine was designed to try and calculate as many of the values as possible each clock cycle to reduce the total number of cylces required to correctly compare and score two input frequncies. The diagram below is a high level overview of the the state machine and the steps performed in each state/clock cycle.

![alt text](https://github.com/ianjchadwick/551_Project/blob/main/supplemental_files/schematics%20and%20diagrams/Score%20State%20Machine.jpeg?raw=true, "Score Module State Machine Behavior")


### VGA Display and Python Script:

- The VGA code is modified from the VGA code provided for use in lab 1 and some of the characters from the ROM were used for displaying the title and the score. 
- To display the characters, each rectangle (yellow and red below) is divided into 16 rows that correspond to a register with bitwidth = to the number of columns.
- A 1 in the corresponding position of the register causes the square to be in the “on” state and a 0 in the “off” state.
- Adjusting the values of the registers changes the pattern displayed. In this case the ASCII characters from the ROM were used.

![alt text](https://github.com/ianjchadwick/551_Project/blob/main/supplemental_files/presentation%20pictures/game_screen_annotated.jpg?raw=true, "VGA Display")

The VGA code to make the grid for displaying the score was coded manually the first time, which was a very long and tedious process. So we decided to write a python script to write the code for the rest of the grids that we wanted to make. The vga_verilog_grid.py script can be found in the supplemental files folder. It can be modified to produce verilog code for any NxM matrix. Then you would just set the bits in corresponding registers for each cell of the matrix to control the 'pixel'.


