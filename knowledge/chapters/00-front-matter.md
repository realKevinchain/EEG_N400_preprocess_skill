# Front Matter

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 1-13. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=1 source_page_label="not printed" source_url="" -->

## PDF page 1

- Source page label: not printed
- LibreTexts source: not printed on page

APPLIED EVENT-
RELATED POTENTIAL
DATA ANALYSIS
Steven J Luck
University of California, Davis

<!-- source_pdf=Full.pdf pdf_page=2 source_page_label="not printed" source_url="" -->

## PDF page 2

- Source page label: not printed
- LibreTexts source: not printed on page

Applied Event-Related Potential Data
Analysis
Steven J Luck
University of California, Davis

<!-- source_pdf=Full.pdf pdf_page=3 source_page_label="not printed" source_url="" -->

## PDF page 3

- Source page label: not printed
- LibreTexts source: not printed on page

This text is disseminated via the Open Education Resource (OER) LibreTexts Project
(https://LibreTexts.org) and like the thousands of other texts available within this powerful platform, it is
freely available for reading, printing, and "consuming."
The LibreTexts mission is to bring together students, faculty, and scholars in a collaborative effort to
provide an accessible, and comprehensive platform that empowers our community to develop, curate,
adapt, and adopt openly licensed resources and technologies; through these efforts we can reduce the
financial burden born from traditional educational resource costs, ensuring education is more accessible
for students and communities worldwide.
Most, but not all, pages in the library have licenses that may allow individuals to make changes, save,
and print this book. Carefully consult the applicable license(s) before pursuing such effects. Instructors
can adopt existing LibreTexts texts or Remix them to quickly build course-specific resources to meet the
needs of their students. Unlike traditional textbooks, LibreTexts’ web based origins allow powerful
integration of advanced features and new technologies to support learning.
LibreTexts is the adaptable, user-friendly non-profit open education resource platform that educators
trust for creating, customizing, and sharing accessible, interactive textbooks, adaptive homework, and
ancillary materials. We collaborate with individuals and organizations to champion open education
initiatives, support institutional publishing programs, drive curriculum development projects, and more.
The LibreTexts libraries are Powered by NICE CXone Expert and was supported by the Department of
Education Open Textbook Pilot Project, the California Education Learning Lab, the UC Davis Office of
the Provost, the UC Davis Library, the California State University Affordable Learning Solutions
Program, and Merlot. This material is based upon work supported by the National Science Foundation
under Grant No. 1246120, 1525057, and 1413739.
Any opinions, findings, and conclusions or recommendations expressed in this material are those of the
author(s) and do not necessarily reflect the views of the National Science Foundation nor the US
Department of Education.
Have questions or comments? For information about adoptions or adaptions contact
info@LibreTexts.org or visit our main website at https://LibreTexts.org.
This text was compiled on 04/14/2026

<!-- source_pdf=Full.pdf pdf_page=4 source_page_label="1" source_url="https://socialsci.libretexts.org/@go/page/88072" -->

## PDF page 4

- Source page label: 1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/88072

TABLE OF CONTENTS
Hardware and Software Requirements
Licensing
Preface
Acknowledgments
How to Cite This Book
1: First Steps
1.1: Getting Started
1.2: Installing the Software and Downloading the Data
1.3: Exercise- Loading an EEG File
1.4: Exercise - Viewing Continuous EEG Waveforms
1.5: Exercise - Viewing EEG Spectra
1.6: Exercise- Loading ERPs and Plotting ERP Waveforms
1.7: Exercise- Plotting ERP Scalp Maps
1.8: Finding the Right Routine in EEGLAB and ERPLAB
1.9: Understanding the Matlab Path
1.10: Key Takeaways and References
2: Processing the Data from One Participant in the ERP CORE N400
Experiment
2.1: Data For This Chapter
2.2: Design of the N400 Experiment
2.3: Exercise - Looking at the EEG and the Event Codes
2.4: Exercise- Filtering Out Low-Frequency Drifts from the EEG
2.5: Exercise- Creating an EventList
2.6: Exercise- Assigning Events to Bins with BINLISTER
2.7: Exercise- Epoching and Baseline Correction
2.8: Exercise- Artifact Detection
2.9: Exercise- Averaged ERPs
2.10: Exercise- Data Quality
2.11: Review of Processing Steps
2.12: A Simple Matlab Script
2.13: Key Takeaways and References
3: Processing Multiple Participants in the ERP CORE N400 Experiment
3.1: Data for This Chapter
3.2: Exercise- Preprocessing and Averaging the Data from 10 Participants
3.3: Exercise- Examining the Single-Participant ERPsets
3.4: Exercise- “Bad” Data
3.5: Exercise- Making a Grand Average
3.6: Exercise- Low-Pass Filtering
1 https://socialsci.libretexts.org/@go/page/88072

<!-- source_pdf=Full.pdf pdf_page=5 source_page_label="2" source_url="https://socialsci.libretexts.org/@go/page/88072" -->

## PDF page 5

- Source page label: 2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/88072

3.7: Exercise - Scoring N400 Amplitude
3.8: Exercise- Simple Statistical Analysis of N400 Data
3.9: Exercise- A More Complex Analysis
3.10: Exercise- ERP Channel Operations
3.11: Exercise- ERP Bin Operations
3.12: Review of Processing Steps
3.13: Matlab Scripts For This Chapter
3.14: Key Takeaways and References
4: Filtering the EEG and ERPs
4.1: Data for this Chapter
4.2: Classes of Filters
4.3: Exercise- Assessing the Frequency Content of the Noise
4.4: Exercise- Filtering the Artificial Waveforms
4.5: Exercise- The Impulse Response Function
4.6: Exercise- Applying the Impulse Response Function to a Series of Impulses
4.7: Background- Filtering with a Running Average
4.8: Background- Filtering with a Weighted Running Average
4.9: Exercise- Distortion of Onset and Offset Times by Low-Pass Filters
4.10: Exercise- High-Pass Filtering
4.11: Practical Advice
4.12: Exercise- Creating and Importing Artificial Waveforms
4.13: Matlab Script for this Chapter
4.14: Key Takeaways and References
5: Referencing and Other Channel Operations
5.1: Data for This Chapter
5.2: Background- Understanding Active, Reference, and Ground Electrodes
5.3: Exercise- Working with the Artificial Data
5.4: Exercise- Average Mastoids as the Reference
5.5: Exercise- Re-Referencing the N400 ERP CORE Data
5.6: Exercise- The Average Reference
5.7: What is the Best Reference Site?
5.8: Exercise- Current Density
5.9: Exercise- Global Field Power
5.10: Exercise- Referencing the EEG Data from the ERP CORE N400 Experiment
5.11: Exercise- Other Common Re-Referencing Scenarios
5.12: Matlab Script For This Chapter
5.13: Key Takeaways and References
6: Assigning Events to Bins, Averaging, Baseline Correction, and
Assessing Data Quality
6.1: Data for This Chapter
6.2: Design of the ERP CORE Visual Oddball P3b Experiment
6.3: The Event Code Scheme
6.4: Overview of Bin Descriptor Files
6.5: Exercise - A Basic Assignment of Events to Bins
6.6: Exercise - Looking at the Averaged ERPs
2 https://socialsci.libretexts.org/@go/page/88072

<!-- source_pdf=Full.pdf pdf_page=6 source_page_label="3" source_url="https://socialsci.libretexts.org/@go/page/88072" -->

## PDF page 6

- Source page label: 3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/88072

6.7: Exercise - The Signal-to-Noise Ratio
6.8: Exercise - Response-Locked Averaging
6.9: Exercise - Comparing Correct and Error Trials
6.10: Exercise - Sequential Analysis of the P3b
6.11: Exercise - Combining Bins
6.12: Exercise - Overlap
6.13: Matlab Script For This Chapter
6.14: Key Takeaways and References
7: Inspecting the EEG and Interpolating Bad Channels
7.1: Data for This Chapter
7.2: Design of the Mismatch Negativity (MMN) Experiment
7.3: Video Demonstration- Performing an Initial Inspection of a Participant’s EEG
7.4: The Fundamental Goal of EEG Preprocessing
7.5: Background- Interpolating Bad Channels
7.6: Exercise - Interpolating Bad Channels
7.7: Matlab Script For This Chapter
7.8: Key Takeaways and References
8: Artifact Detection and Rejection
8.1: Data for This Chapter
8.2: Overview
8.3: Background- Why Do We Reject Artifacts?
8.4: Background- The General Approach
8.5: Exercise- Simple Blink Detection
8.6: Exercise- Adjusting the Threshold
8.7: An Iterative Approach to Setting Parameters
8.8: Exercise- Data Quality and Confounds
8.9: Exercise- Better Blink Detection
8.10: Exercise- Detecting Eye Movements
8.11: Exercise- Deciding on a Threshold for Eye Movements
8.12: Exercise- Commonly Recorded Artifactual Potentials (C.R.A.P.)
8.13: Using Artifact Detection to Avoid Changes to Visual Inputs
8.14: The ERP CORE N2pc Experiment
8.15: Exercise- Visualizing the Eye Movements
8.16: Exercise- Using the Averaged HEOG to Visualize Consistent Eye Movements
8.17: Exercise- A Two-Stage Strategy for Eliminating Small But Consistent Eye Movements
8.18: Matlab Script For This Chapter
8.19: Key Takeaways and References
9: Artifact Correction with Independent Component Analysis
9.1: Data for this Chapter
9.2: Exercise- A First Pass at ICA-Based Blink Correction
9.3: Exercise- Evaluating the Impact of Artifact Correction
9.4: Background- A Quick Conceptual Overview of ICA
9.5: Exercise- Making ICA Work Better
9.6: Exercise- Transferring the Weights and Assessing the ICs
9.7: Exercise- Deciding Which ICs to Exclude
3 https://socialsci.libretexts.org/@go/page/88072

<!-- source_pdf=Full.pdf pdf_page=7 source_page_label="4" source_url="https://socialsci.libretexts.org/@go/page/88072" -->

## PDF page 7

- Source page label: 4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/88072

9.8: Exercise- Deleting C.R.A.P. Prior to ICA
9.9: General Recommendations
9.10: Matlab Scripts For This Chapter
9.11: Key Takeaways and References
10: Scoring and Statistical Analysis of ERP Amplitudes and Latencies
10.1: Data for This Chapter
10.2: Design of the Flankers Experiment
10.3: Exercise- Examining the Grand Averages
10.4: Exercise- A First Pass at Scoring and Statistical Analysis
10.5: Exercise- Simplifying the Statistical Analysis
10.6: Exercise- Peak Amplitude
10.7: Exercise- Peak Latency
10.8: Exercise- Fractional Area Latency
10.9: Exercise- Quantifying Onset Latency
10.10: Exercise- Collapsing Across Channels and Correlating Latencies with Response Times
10.11: Matlab Scripts For This Chapter
10.12: Key Takeaways and References
11: EEGLAB and ERPLAB Scripting
11.1: Data for This Chapter
11.2: Expected Background Knowledge
11.3: Bugs as an Opportunity for Growth
11.4: Design of the N170 Experiment
11.5: Exercise- The Matlab Command Line and the EEG Variable
11.6: Exercise- The ALLEEG Variable and Redrawing the GUI
11.7: Exercise- EEG.history and eegh
11.8: Exercise- From the Command Line to a Script
11.9: Exercise- Using a Variable for the Path
11.10: Exercise- Loops
11.11: Exercise- Looping Through Data from Multiple Participants
11.12: Rapid Cycling Between Coding and Testing
11.13: Exercise- Referencing with a Script
11.14: Exercise- Improving the Referencing Script
11.15: Exercise- Preprocessing the EEG and Using a Spreadsheet to Store Subject-Specific Information
11.16: Exercise- Building an Entire EEG Processing Pipeline
11.17: Exercise- Averaging with a Custom aSME Time Window
11.18: Exercise- Scoring Amplitudes and Latencies and Performing Statistical Analyses
11.19: Key Takeaways and References
12: Appendix 1: A Very Brief Introduction to EEG and ERPs
13: Appendix 2: Troubleshooting Guide
13.1: A2.1 The First Step
13.2: A2.2 Some Basic Solutions
13.3: A2.3 Taking a Scientific Approach
13.4: A2.4 Deciphering Matlab’s Error Messages
13.5: A2.5 Debugging Scripts by Performing Experiments and Collecting Data
4 https://socialsci.libretexts.org/@go/page/88072

<!-- source_pdf=Full.pdf pdf_page=8 source_page_label="5" source_url="https://socialsci.libretexts.org/@go/page/88072" -->

## PDF page 8

- Source page label: 5
- LibreTexts source: https://socialsci.libretexts.org/@go/page/88072

13.6: A2.6 Avoiding Bugs in Your Scripts with Good Programming Practices
13.7: A2.7 References
14: Appendix 3: Example Processing Pipeline
Index
Glossary
Detailed Licensing
5 https://socialsci.libretexts.org/@go/page/88072

<!-- source_pdf=Full.pdf pdf_page=9 source_page_label="1" source_url="https://socialsci.libretexts.org/@go/page/88075" -->

## PDF page 9

- Source page label: 1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/88075

Hardware and Software Requirements
The core of this book is a large set of data processing and analysis exercises. They are designed to run on your own computer using
two free, open source Matlab toolboxes, EEGLAB and ERPLAB. However, you will need a Matlab license to run these toolboxes.
Check with your institution’s Information Technology office to see if they provide free or reduced-cost Matlab licenses. It may also
be possible for you to purchase a student license. In particular, you will need:
Matlab version 2017a or higher
The Signal Processing Toolbox is required. If you don't have it, contact your institution's IT support department for
assistance.
The Statistics and Machine Learning Toolbox is recommended.
To see what toolboxes are already installed in Matlab, type ver on the Matlab command line.
Some parts of the software will run under Octave, a free Matlab simulator. However, Octave will not run the graphical user
interface, which is necessary for most of the exercises. You should therefore use Matlab rather than Octave.
EEGLAB version 2022.0 or higher (see Chapter 1 for installation instructions)
ERPLAB version 9.0 or higher (see Chapter 1 for installation instructions)
EEGLAB and ERPLAB will run on any reasonably recent version of Mac OS, Windows, or Linux. These packages are designed
for professional users, and they work best on a computer with a lot of RAM, a large hard drive, and a high-resolution external
monitor. However, they will function adequately on a midrange laptop. Absolute minimum specifications are:
4 MB RAM (but 8 MB will work much better)
A screen height of at least 720 pixels (but 1080p or higher will work much better)
Read and write permission in the folder used to store the EEGLAB and ERPLAB code
1 https://socialsci.libretexts.org/@go/page/88075

<!-- source_pdf=Full.pdf pdf_page=10 source_page_label="1" source_url="https://socialsci.libretexts.org/@go/page/139182" -->

## PDF page 10

- Source page label: 1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/139182

Licensing
A detailed breakdown of this resource's licensing can be found in Back Matter/Detailed Licensing.
1 https://socialsci.libretexts.org/@go/page/139182

<!-- source_pdf=Full.pdf pdf_page=11 source_page_label="1" source_url="https://socialsci.libretexts.org/@go/page/88076" -->

## PDF page 11

- Source page label: 1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/88076

Preface
When I was a new assistant professor, journal editors kept sending me ERP papers to review that were just awful. I think the editors
didn’t want to waste the time of more established researchers with these terrible manuscripts. The papers were generally written by
researchers who were relatively new to the technique and had not “grown up” in an ERP lab. Because they had not received much
ERP training, they made all kinds of errors in the design, the analysis, and the interpretation of the experiments.
That experience made me realize how fortunate I had been to be trained in Steve Hillyard’s lab, which traced its roots to the very
first published ERP experiment (Davis, 1939). I decided to write a book that distilled everything I had learned in the Hillyard lab so
that everyone could benefit from this knowledge (Luck, 2005). I also started running in-person training workshops called ERP Boot
Camps along with Emily Kappenman. Emily and I also put together an edited volume on ERP components (Luck & Kappenman,
2012). To make it easier for researchers to analyze their data using the methods we were promoting, I worked with Javier Lopez-
Calderon to release ERPLAB Toolbox, a free ERP data processing package (Lopez-Calderon & Luck, 2014). And then I wrote a
second edition of my ERP book (Luck, 2014), taking advantage of everything I had learned from the ERP Boot Camp about how to
explain ERP methodology.
Although these efforts have reached thousands of researchers, I always felt that something was missing. The books and workshops
provided a mix of theory and practical advice, but they were necessarily quite broad given the wide range of researchers who use
ERPs. It can be very difficult to take these broad ideas and apply them to the analysis of actual experiments. So, what was missing
from our books and our workshops was the opportunity to solve all the problems that arise when you’re analyzing real data. We
tried having data analysis tutorials in a few of the early ERP Boot Camps, but we found that we spent 98% of our time teaching the
participants how to run the software. Also, we ended up teaching them how to analyze data from just a single experiment, which
was often quite different from their own research interests.
The present book is designed to fill this gap. It includes tons of example data sets and exercises, all of which run on the free
ERPLAB Toolbox package. These examples use data from the ERP CORE (Kappenman et al., 2021), which has data from six
classic ERP paradigms. As a result, the examples in this book cover a broad range of paradigms and components with real data.
I’ve published this book on the free LibreTexts platform so that anyone in the world can learn about ERP data analysis for free. I
was extremely fortunate to have great opportunities to learn about ERPs as a student, and I’m trying to “pay it forward” with this
book. If you teach the ERP technique to other people (either in courses or in your lab), you should feel free to remix and reuse the
book in any way that you find helpful.
Funding
Preparation of this book was made possible by grant R01MH087450 from the National Institute of Mental Health.
References
Davis, P. A. (1939). Effects of acoustic stimuli on the waking human brain. Journal of Neurophysiology, 2, 494–499.
Kappenman, E. S., Farrens, J. L., Zhang, W., Stewart, A. X., & Luck, S. J. (2021). ERP CORE: An Open Resource for Human
Event-Related Potential Research. NeuroImage, 225, 117465. https://doi.org/10.1016/j.neuroimage.2020.117465
Lopez-Calderon, J., & Luck, S. J. (2014). ERPLAB: An open-source toolbox for the analysis of event-related potentials. Frontiers
in Human Neuroscience, 8, 213. https://doi.org/10.3389/fnhum.2014.00213
Luck, S. J. (2005). An Introduction to the Event-Related Potential Technique. MIT Press.
Luck, S. J. (2014). An Introduction to the Event-Related Potential Technique, Second Edition. MIT Press.
Luck, S. J., & Kappenman, E. S. (2012). The Oxford Handbook of Event-Related Potential Components. Oxford University Press.
1 https://socialsci.libretexts.org/@go/page/88076

<!-- source_pdf=Full.pdf pdf_page=12 source_page_label="1" source_url="https://socialsci.libretexts.org/@go/page/138350" -->

## PDF page 12

- Source page label: 1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/138350

Acknowledgments
This book simply would not have been possible if it had not been for the hard work and creativity of the wonderful people who
have worked in my lab over the years.
I'd like to start with a shout-out to Emily Kappenman. Emily and I have worked together for over 15 years on the ERP Boot Camp
and many other efforts designed to promote rigorous and high-impact ERP research. Emily spearheaded the ERP CORE, which is
one of the two main pillars of this book. Jaclyn Farrens also put years of work into the CORE, and the CORE was pushed across
the finish line with help from Wendy Zhang and Andrew Stewart.
The other pillar of this book is ERPLAB Toolbox. The first several releases of ERPLAB were written entirely by Javier Lopez-
Calderon, and his fingerprints can still be seen throughout the software. After Javier moved on, Andrew Stewart took over
programming duties, and he wrote the initial code for the data quality metrics. After Andrew's departure, my lab manager Aaron
Simmons filled in for a while, and it's amazing how much he added while simultaneously running my lab. Aaron made a ton of
changes that will make your life easier as you go through the exercises in this book and then apply ERPLAB to your own
data. Guanghui Zhang has recently become the primary ERPLAB developer, and I can't wait for the world to see the new
version that he's working on now.
I'd also like to thank the other members of my lab who provided feedback on drafts of the book, including (alphabetically) Brett
Bahle, Carlos Carrasco, John Kiat, Lara Krisst, Orestis Papaioannou, and Kurt Winsler. I received additional feedback from several
members of the UCD EEG Research Group.
In addition, I'd like to acknowledge the National Institute of Mental Health, which has funded ERPLAB for many years (grant
R01MH087450) and made this book possible.
Finally, I'd like to thank Lisa and Ruthie, who did their best to keep me sane during the writing process.
1 https://socialsci.libretexts.org/@go/page/138350

<!-- source_pdf=Full.pdf pdf_page=13 source_page_label="1" source_url="https://socialsci.libretexts.org/@go/page/142071" -->

## PDF page 13

- Source page label: 1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/142071

How to Cite This Book
Cite as: Luck, S. J. (2022). Applied Event-Related Potential Data Analysis. LibreTexts. https://doi.org/10.18115/D5QG92
Acknowledgments by Steven J Luck is licensed CC BY 4.0. Original source: native.
1 https://socialsci.libretexts.org/@go/page/142071
