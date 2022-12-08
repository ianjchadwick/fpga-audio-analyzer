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

### Component 3:


