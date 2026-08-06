# 5: Referencing and Other Channel Operations

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 130-153. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=130 source_page_label="1" source_url="" -->

## PDF page 130

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
5: Referencing and Other Channel Operations
 Learning Objectives
In this chapter, you will learn to:
Avoid the incorrect assumption that an ERP waveform primarily reflects signals from the active electrode site and instead
recognize that the waveform equally reflects signals from the active and reference sites
Compute the absolute voltage at the scalp electrodes given the internal generator voltage and the propagation weights
between the generator and the scalp sites
Compute the voltage between each electrode site and the ground electrode given the absolute voltages at each site
Compute the referenced voltage at each site given the voltage between each site and the ground electrode
Re-reference the voltage to another site
Use simple algebra to determine the correct equations for re-referencing your data
Use two alternatives to referencing your data, namely current density and global field power
Implement several different reference schemes and alternatives to referencing in ERPLAB using ERP Channel Operations
and EEG Channel Operations
Implement common referencing scenarios using a script
This chapter dives deeper into channel operations, especially with respect to how the reference electrode works and how you can
re-reference your data. Once you know what you’re doing, re-referencing the data will take you just a few seconds, and many
researchers don’t give it much thought. However, the reference has an enormous impact on your ERP waveforms, so you really
need to understand what you’re doing when you reference or re-reference your data.
The exercises in this chapter are designed to give you greater insight into what the reference site does, why we need to reference
the data, and how re-referencing the data can clarify or obfuscate the results depending on what new reference you choose. We’ll
also discuss the mechanics of re-referencing in ERPLAB so that you can have confidence that you’re doing it correctly.
We’ll start with simulated data so that you can see how the original and referenced data on the scalp are related to the underlying
neural generator. The simulations use Excel rather than ERPLAB, which makes it easier to see exactly what’s going on. You can
use Google Sheets instead of Excel, if you prefer. I’m assuming that you know the basics of spreadsheets, including how an
equation in one cell can compute a value on the basis of other cells.
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
1

<!-- source_pdf=Full.pdf pdf_page=131 source_page_label="2" source_url="" -->

## PDF page 131

- Source page label: 2
- LibreTexts source: not printed on page

This page titled 5: Referencing and Other Channel Operations is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
2

<!-- source_pdf=Full.pdf pdf_page=132 source_page_label="5.1.1" source_url="https://socialsci.libretexts.org/@go/page/87953" -->

## PDF page 132

- Source page label: 5.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87953

5.1: Data for This Chapter
The data we’ll be using for the exercises in this chapter can be found in the Chapter_5 folder in the master folder:
https://doi.org/10.18115/D50056.
This page titled 5.1: Data for This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
5.1.1 https://socialsci.libretexts.org/@go/page/87953

<!-- source_pdf=Full.pdf pdf_page=133 source_page_label="5.2.1" source_url="https://socialsci.libretexts.org/@go/page/87954" -->

## PDF page 133

- Source page label: 5.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87954

5.2: Background- Understanding Active, Reference, and Ground Electrodes
In this section, we’ll review how active, reference, and ground electrodes work in EEG recordings. You can find a detailed
discussion in Chapter 5 of Luck (2014). Here, I’ll explain the concepts using the artificial ERP waveforms shown in Figure 5.1. It
helps to use artificial data in this context because we know what the true signals are. Later in the chapter, you’ll apply what you’ve
learned to real data.
In the artificial example shown in Figure 5.1A, the generator dipole is represented by the arrow, with the positive side pointing
toward the Pz electrode. The broken line represents the transition between the positive and negative sides of the dipole, and the
voltage is zero along this line. Unfortunately, we don’t know the location of this zero line when we’re looking at real data, and we
don’t have a single zero line when more than one dipole is active (which is almost always the case).
Figure 5.1. Example of active, ground, and reference electrodes. (A) Generation of the ERP. The arrow represents the generator
dipole, and the source waveform shows the change in voltage over time at this dipole. The broken line represents the band of zero
voltage at the transition between the positive and negative sides of the dipole. (B) Absolute voltage at each electrode site (which is
known in this simulation but cannot be directly recorded). The absolute voltage at a given site is the source waveform multiplied by
the weight for that site. (C) Single-ended voltage at each electrode site (i.e., the potential between a given site and the ground
electrode). In most systems, this signal is present only inside the amplifier and is not available in the system’s output. Note that a
small amount of 60 Hz noise from the amplifier’s ground circuit contaminates these signals. (D) Voltage at each site referenced to
the left mastoid (Lm) electrode. This signal is obtained by subtracting (either in hardware or in software) the single-ended Lm
signal from the signal at each of the other electrodes.
Voltage is the potential (pressure) for charges to move from one place to another place, so there is no such thing as the voltage at a
single electrode site. However, it is convenient to use the term absolute voltage to refer to the potential between one electrode and
the average of the entire surface of the head. We use the average of the surface of the head in our definition of absolute voltage
because the average voltage across the entire surface of the head is assumed to be zero. This assumption is true only for perfectly
spherical heads (Yao, 2017), but it is a reasonable approximation for our present purposes.
Figure 5.1B shows the absolute voltage that we would expect at each of our recording electrodes. The absolute voltage at a given
electrode site is equal to the source waveform multiplied by a weighting factor that represents the degree to which voltage is
conducted from the specific generator to a given electrode site. For example, we’re assuming that 10% of the voltage from the
generator dipole is conducted to the Pz electrode site, so the weight for that site is 0.10. The source waveform has a peak amplitude
of 100 µV, so the absolute voltage waveform at Pz peaks at 10 µV. The weights are negative for the electrodes on the negative side
of the dipole, so the waveforms are negative-going at those sites. (The weights shown in Figure 5.1A are not the true weights, but
are just examples that produce nice round numbers.) If this set of concepts about ERP generation is unfamiliar to you, you can learn
more by reading Chapter 2 of Luck (2014) or by taking my online Introduction to ERPs course.
There is no way to measure the absolute voltage at a given electrode site. The absolute voltage is just a convenient hypothetical
entity for explaining how reference electrodes work. The EEG amplifier would actually measure the voltage between each
5.2.1 https://socialsci.libretexts.org/@go/page/87954

<!-- source_pdf=Full.pdf pdf_page=134 source_page_label="5.2.2" source_url="https://socialsci.libretexts.org/@go/page/87954" -->

## PDF page 134

- Source page label: 5.2.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87954

electrode site and the ground electrode. The voltage between two electrodes is simply the difference between the absolute voltages
at those two sites. For example, the absolute voltage at Pz peaks at 10 µV and the absolute voltage at the ground electrode peaks at
-4 µV, so the voltage between Pz and ground is 14 µV (10 minus -4). We call the voltage between a given site and the ground
electrode, which is what an EEG amplifier actually measures, the single-ended signal (shown in Figure 5.1C).
EEG amplifiers contain noise in the ground circuit (which is the part of the amplifier that the ground electrode is connected to).
Because all electrodes are initially measured with respect to the ground electrode, the noise in the ground circuit is present with
approximately equal amplitude in the single-ended signals from all of the electrode sites. In Figure 5.1C, I added some 60 Hz noise
to every signal to simulate this noise. However, this noise is often much much much larger, obscuring the actual EEG signals.
EEG recording systems therefore contain differential amplifiers, which use a trick to subtract away the noise from the ground
circuit. The trick is to use another electrode as the reference electrode. The single-ended signal at the reference electrode is also
recorded relative to the ground electrode, so it also contains the noise from the ground circuit. Consequently, if we subtract the
reference electrode signal from the signals at our other electrodes (our active electrodes), the noise is approximately the same in the
active and reference electrodes, so the noise is subtracted away. This is shown in Figure 5.1D, in which the single-ended signal
from the left mastoid (Lm) electrode is subtracted from the signal at each of the other electrodes to create a referenced or
differential signal. You can see that the referenced waveforms no longer have the 60 Hz noise that is visible in the single-ended
signals. If you didn’t follow this brief overview of referencing, you can watch this brief video from the online Introduction to ERPs
course or read the more detailed description in Chapter 5 of Luck (2014).
In most EEG systems, the referencing subtraction is performed in the amplifier’s hardware, so you have no way of accessing the
single-ended signals. You’ll only ever see the referenced signals. There are, however, some exceptions. The BioSemi ActiveTwo
system (which we used for the ERP CORE experiments) does not subtract the reference in hardware and instead outputs the single-
ended signals. The researcher then subtracts the reference from the single-ended signals in software, after the recording session is
over. During the recording, this system will show the referenced signals on the screen (to minimize noise from the ground circuit),
but only the single-ended signals are saved to the file. This confuses many researchers, who do not realize that the saved data has
not been referenced. If you use BioSemi, don’t forget to subtract the reference! The Brain Products ActiCHamp system also obtains
the single-ended signals, but the data collection software performs the referencing subtraction before the data are saved to a file.
This is less confusing.
Yes, I’m a control freak
For recording the EEG from the ActiCHamp system, Brain Products provides an open source program called Pycorder in
addition to their closed source Recorder software. My lab has modified the Pycorder software so that we can save the single-
ended signals instead of the referenced signals. We then do the referencing offline in software. This produces the same end
result that we would get by saving the referenced data, but I like having the raw single-ended data and doing the referencing
myself. I guess I’m a bit of a control freak…
In the example shown in Figure 5.1, the Lm electrode is near the zero line for the generator dipole. As a result, the referenced
voltages at each site are close in amplitude to the absolute voltages. However, that will not typically be the case, so you shouldn’t
assume that the referenced voltages are a good approximation of the absolute voltages. Instead, you should always think of the
voltage at a given electrode site as being the difference between the signal at the so-called active electrode and the signal at the so-
called reference electrode. I use the phrase “so-called” here because we are simply making a difference between two sites, and both
contribute equally to the referenced voltage. If there is a large deflection in the absolute voltage in the reference electrode, than an
inverted version of this deflection will be present at every so-called active site. (It’s inverted because we subtract the reference.) So,
when you see a waveform labeled “Cz”, you are not looking at the voltage at the Cz electrode site. You are looking at the potential
between the Cz site and the reference site, which is equivalent to the absolute voltage at Cz minus the absolute voltage at the
reference site. The so-called active and so-called reference sites are equal contributors to this voltage. In fact, in some areas of
research, Cz is used as the reference (which is equivalent to inverting the waveform). It’s therefore more accurate to say that a
waveform is from the “Cz channel” rather than from the “Cz electrode”.
If there is one thing I hope you learn from this chapter, it’s that you need to think of a given ERP waveform as equally reflecting
signals from the so-called active and so-called reference sites, not as being primarily from the active site. The reference site
5.2.2 https://socialsci.libretexts.org/@go/page/87954

<!-- source_pdf=Full.pdf pdf_page=135 source_page_label="5.2.3" source_url="https://socialsci.libretexts.org/@go/page/87954" -->

## PDF page 135

- Source page label: 5.2.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87954

you choose for your analyses can have a huge impact on how the waveforms look and which channels show the experimental
effects. Unfortunately, there is no perfect reference site. In most cases I recommend simply using whatever is common in your
subfield. That way, your data can be compared with the data from other studies. If you use a different reference site, your data may
end up looking quite odd, and you may think that you’ve discovered new effects.
This page titled 5.2: Background- Understanding Active, Reference, and Ground Electrodes is shared under a CC BY 4.0 license and was
authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
5.2.3 https://socialsci.libretexts.org/@go/page/87954

<!-- source_pdf=Full.pdf pdf_page=136 source_page_label="5.3.1" source_url="https://socialsci.libretexts.org/@go/page/87955" -->

## PDF page 136

- Source page label: 5.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87955

5.3: Exercise- Working with the Artificial Data
In the Chapter_5 data folder, you will find an Excel spreadsheet named simulated_data.xlsx, which contains everything I used to
create the simulated data in Figure 5.1. Open the file in Excel (or import it into Google Sheets). You will see that each line is a time
point. The first column shows the latency of the time point (in ms), and the second column is the source waveform. There are also
columns for the absolute voltage at each electrode site, with the weighting factor for a given site in the second row.
If you look at the equations in the cells that compute the absolute voltage values, you’ll see that the absolute voltage at a given
electrode site was computed by multiplying the weighting factor for that site by the source waveform. You’ll also see that the
single-ended voltage was created by subtracting the absolute voltage at the ground electrode from the absolute voltage at each other
site, and then adding the 60 Hz noise. And you’ll see that the referenced voltage was computed by subtracting the single-ended
signal at the Lm electrode from the single-ended signal at a given active site. At the right side of the spreadsheet, you’ll see plots of
the absolute voltages, the single-ended voltages, and the referenced voltages. Take a careful look at the equations in the spreadsheet
and make sure that you understand how the absolute voltage is related to the source waveform and the weights, how the single-
ended voltage is related to the absolute voltage, and how the referenced voltage is related to the single-ended voltage.
The spreadsheet also contains sheets with copies of the data formatted for exporting as a text file (using the Tab delimited Text
format), which can easily be imported into ERPLAB (using EEGLAB > ERPLAB > Export & Import ERP > Import ERP from
text (universal)). This allows you to create simulated data and see how the various ERPLAB processes work.
In the spreadsheet, change the weight above the Absolute_Ground label from -.04 to -.10. You’ll see that this greatly increases the
magnitude of the absolute voltage in the ground channel. And because the ground is subtracted from the other signals to create the
single-ended voltage, this also changes all the single-ended voltage waveforms. But did it change the referenced waveforms?
No, it did not! The nature of the referencing procedure means that any signals or noise at the ground electrode are subtracted away
from the referenced voltages. This means that you can place the ground electrode anywhere on the head, and the location does not
matter. You might then wonder why we use a ground electrode at all. The answer is simple: The amplifier will freak out if there
isn’t a ground electrode. You need to have a ground, and it needs to be appropriately attached to the head (or anywhere on the
body). But the location does not matter.
Now try changing the weight for the Lm channel from -.011 to -.20. This simulates changing the location of the reference electrode,
moving it farther away from the zero line. What did this do to the referenced waveforms? Not only are some of them now larger,
the polarity of the Fz waveform has now changed from negative to positive. This demonstrates how the signal at the reference
electrode can have a large impact on the referenced waveforms from the so-called active electrodes.
Play around with the spreadsheet some more. For example, try changing the weights for the other electrodes or the magnitude of
the 60 Hz noise.
This page titled 5.3: Exercise- Working with the Artificial Data is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
5.3.1 https://socialsci.libretexts.org/@go/page/87955

<!-- source_pdf=Full.pdf pdf_page=137 source_page_label="5.4.1" source_url="https://socialsci.libretexts.org/@go/page/87956" -->

## PDF page 137

- Source page label: 5.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87956

5.4: Exercise- Average Mastoids as the Reference
For historical reasons, many ERP studies use the mastoid process (the thick bone behind the ear) as the reference electrode. This is
why the data shown in Figure 5.1D use the left mastoid as the reference. However, it seems a little odd to use a reference that is
lateralized to one side of the head. Might this lead to some kind of hemispheric bias in the data? In reality, this isn’t usually a
significant problem. However, just to be safe, many researchers use the average of the left and right mastoids (Lm and Rm) as the
reference. In this exercise, we’re going to look at two ways of transforming the data to reference the simulation data to the average
of Lm and Rm. This exercise exemplifies an important principle, namely that data recorded using one electrode site as the reference
can easily be re-referenced offline, in software, to one of the other electrode sites (or some combination of electrode sites).
Open up the spreadsheet from the previous exercise and make sure everything is back to the way it was originally (or download the
spreadsheet again). Make 3 new columns just to the right of the columns for the referenced data, and label them Fz-Avg, Cz-Avg,
and Pz-Avg. If you look at how the referencing is done for the Fz channel at the first time point (cell O4 of the spreadsheet), you’ll
see that the referenced value is the single-ended value for Fz (cell J4) at this time point minus the single-ended value for Lm (cell
M4, but with a “$” symbol before the letter so that it remains column M even if we paste it somewhere else). This is the subtraction
that I used to reference the data in Figure 5.1.
We want to change this so that we subtract the average of Lm and Rm from Fz. That average is simply (Lm+Rm)/2, which would
be ($M4+$N4)/2 given that Lm is in column M and Rm is in column N of our spreadsheet. So, to create a value for Fz using the
average of Lm and Rm as the reference, we need the equation for the first time point to be =J4-($M4+$N4)/2. Go ahead and put
this equation into cell S4, which should be in the new column that you labeled Fz-Avg. If you then copy and paste this equation
into cells T4 and U4, the J4 should update to K4 and L4, respectively. If you then copy and paste these three cells to all the
remaining time points, the row numbers should update, and you’ll have the appropriate values for all the cells.
Now compare the new values you created to the original referenced values (with Lm as the reference). They should be pretty
similar. This is because the single-ended signal at Rm is nearly identical to the single-ended signal at Lm, so the average of Lm and
Rm is nearly identical to the Lm signal. In turn, this is because the weights for Lm and Rm are pretty similar. However, there may
be situations in which the Lm and Rm signals are not so similar (e.g., if the generator dipole happened to be near Lm without a
generator near Rm). This is why it’s a good idea to use the average of Lm and Rm rather than just using one side.
In most systems, you don’t have access to the single-ended signals, so you wouldn’t be able to use this approach for referencing the
data to the average of the two mastoids. For example, the original data might all be referenced to Lm. However, if you have a
recording of Rm (also referenced to Lm), there is a trick you can use to re-reference the data to the average of Lm and Rm. The
trick was described by Paul Nunez in his classic book on the biophysics of EEG (Nunez, 1981), and the algebra is spelled out in
Chapter 5 of Luck (2014). Specifically, if you subtract 50% of the Rm signal from each channel that was already referenced to Lm,
this is equivalent to taking the single-ended data from the active electrode and subtracting the average of the single-ended Lm and
Rm signals. For example, to re-reference Fz to the average of Lm and Rm, you would take the already-referenced Fz channel
(which is really Fz – Lm) and subtract 0.5 of the Rm channel (which is really Rm – Lm).
Create three new columns labeled Fz-Avg2, Cz-Avg2, and Pz-Avg2. Put equations into these columns that use this different
approach to re-referencing. That is, take the values that were already referenced (Columns O-R) and subtract 0.5 times the Rm
channel from the Fz, Cz, and Pz channels. Once you’ve created these three new channels, compare them with the previous set you
created. You should see that these two ways of referencing to the average of Lm create exactly identical results. However, the first
method can’t be used in most systems, because it requires access to the single-ended signals, so you may need to use the second
method. When you’re working with real data instead of simulated data, you’ll do the referencing in ERPLAB using Channel
Operations rather than in a spreadsheet. However, Channel Operations uses equations that are much like the spreadsheet equations.
I hope that the experience you’ve now gotten with the spreadsheet will give you a better understanding of how the equations work
in Channel Operations.
This page titled 5.4: Exercise- Average Mastoids as the Reference is shared under a CC BY 4.0 license and was authored, remixed, and/or curated
by Steven J Luck directly on the LibreTexts platform.
5.4.1 https://socialsci.libretexts.org/@go/page/87956

<!-- source_pdf=Full.pdf pdf_page=138 source_page_label="5.5.1" source_url="https://socialsci.libretexts.org/@go/page/87957" -->

## PDF page 138

- Source page label: 5.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87957

5.5: Exercise- Re-Referencing the N400 ERP CORE Data
Now let’s see how re-referencing is accomplished in ERPLAB with the data from the N400 ERP CORE experiment. To keep things
simple for this exercise, we’ll just work with the grand average ERPs.
Launch EEGLAB and set the current directory to be the Chapter_5 folder. Load the file named Grand_N400_diff.erp using
EEGLAB > ERPLAB > Load existing ERPset. Plot the data from Bins 3, 4 and 5 (EEGLAB > ERPLAB > Plot ERP > Plot
ERP waveforms). The waveforms should look familiar from the previous chapters. As before, Bins 3 and 4 are the related and
unrelated target words, respectively. Bin 5 is the unrelated-minus-related difference wave. You can see a big beautiful N400
(especially in the difference wave), with the biggest N400 in the CPz channel.
But remember, the waveform in a given channel is determined just as much by the reference electrode as by the active electrode,
even though the active electrode is typically used to name the channel. Unless we know what was used as the reference, we don’t
really know what we’re looking at in this plot. When I’m reading a journal article, I go to the Method section and find out what was
used as the reference before I look at any of the waveforms. If you look at the Method section for the paper on the ERP CORE
(Kappenman et al., 2021), you’ll see that we used the average of the P9 and P10 electrode sites as the reference for the N400
experiment (and most of the other experiments). P9 and P10 are quite close to the left and right mastoids, so the waveforms look
almost identical to what we would have gotten using the average of Lm and Rm as the reference. However, it’s easier to get a good
electrical connection with P9 and P10, so we’re starting to use these electrodes as our standard reference sites.
Once you understand that referencing is just a matter of subtraction, you can use some very simple algebra to figure out how to re-
reference data that have already been referenced. To demonstrate, we’re going to re-reference the N400 data to the Cz electrode
site. Almost all N400 studies use the mastoids (or something nearby) as the reference, so Cz would be an unusual choice for an
N400 experiment. However, Cz is used as the default reference in some EEG recording systems (e.g., the EGI system), so it’s easy
to imagine that someone would look at N400 data with a Cz reference (especially someone who didn’t understand the importance
of the reference location). As you’ll see, the data look quite different with a Cz reference.
Let’s start with the algebra. I’m not much of a math person, so I promise it will be simple. For the CPz channel, the waveforms that
you just looked at—with the average of P9 and P10 as the reference—can be expressed conceptually as:
CPz = CPz – [(P9 + P10 )/2]
Referenced Absolute Absolute Absolute
In other words, the referenced voltage at CPz is just the absolute voltage at CPz minus the average of the absolute voltages from P9
and P10. That’s not how the referenced CPz channel was actually created, but it’s conceptually equivalent. Here’s the
corresponding expression for the Cz channel:
Cz = Cz – [(P9 + P10 )/2]
Referenced Absolute Absolute Absolute
Our goal is to re-reference the CPz channel so that Cz is now the reference. In other words, we want to create a new channel
defined as:
CPz = CPz - Cz
Referenced Absolute Absolute
It turns out that we can get this by just taking the data that have been referenced to the average of P9 and P10 and subtracting Cz
from each channel. For CPz, this gives us:
CPz - Cz
Referenced Referenced
= (CPz – [(P9 + P10 )/2]) – (Cz – [(P9 + P10 )/2])
Absolute Absolute Absolute Absolute Absolute Absolute
= CPz - Cz - [(P9 + P10 )/2] - [-(P9 + P10 )/2]
Absolute Absolute Absolute Absolute Absolute Absolute
= CPz - Cz
Absolute Absolute
The original reference is in both signals, so it drops out when we do the subtraction. Pretty cool, eh? I think so. But maybe that’s
why I’ve spent much of my adult life doing ERP research.
Okay, let’s try it. With Grand_N400_diff.erp as the active ERPset, select EEGLAB > ERPLAB > ERP Operations > ERP
Channel Operations. Clear out any equations that remain in the text box from the last time you used this routine. Then change the
Mode from Modify existing ERPset to Create new ERPset. We used the Modify existing ERPset mode previously when we
5.5.1 https://socialsci.libretexts.org/@go/page/87957

<!-- source_pdf=Full.pdf pdf_page=139 source_page_label="5.5.2" source_url="https://socialsci.libretexts.org/@go/page/87957" -->

## PDF page 139

- Source page label: 5.5.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87957

added a new channel that was the average of several existing channels. But now we don’t want to add new channels to our existing
set of channels—we want to create a brand-new ERPset in which all of the channels have Cz as the reference. Otherwise we would
have a huge number of channels in our ERPset.
When we create a new ERPset, we use nch (short for “new channel”) to indicate the new channels that we’re creating and ch to
indicate the original channels. For our first channel, FP1, we would subtract the original Cz channel (ch21) from the original FP1
channel (ch1) to create the new channel (nch1). The formula we would enter into the Channel Operations GUI would therefore be:
nch1 = ch1 - ch12 Label FP1
We would then repeat this for channels 2-28. Channels 29 and 30 are the horizontal and vertical electrooculogram (EOG) channels,
which use a different reference, so we would just create new channels that are exact copies of the original channels for these sites.
To avoid typing all these equations, click the Reference assistant button. You’ll see a new window that looks like Screenshot 5.1.
If you type ch21 in the text box labeled Ch_REF near the top of the window, the Reference assistant will create appropriate
equations using ch21 as the reference for every channel. Make sure that the check boxes are set as shown in the screenshot. Also,
select Exclude these channels and put 29 30 in the text box, which will cause it not to create re-referencing equations for the
horizontal and vertical EOG channels. Then click OK.
Screenshot 5.1
Now the main Channel Operations window should be filled with equations, as shown in Screenshot 5.2 (but note that you may need
to scroll the equations window to see all the equations). The equation for each channel simply creates a new channel that is the
original channel minus channel 21 (Cz). However, channels 29 and 30 just copy the original horizontal and vertical EOG channels
without changing the reference.
5.5.2 https://socialsci.libretexts.org/@go/page/87957

<!-- source_pdf=Full.pdf pdf_page=140 source_page_label="5.5.3" source_url="https://socialsci.libretexts.org/@go/page/87957" -->

## PDF page 140

- Source page label: 5.5.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87957

Screenshot 5.2
You can now click RUN to execute this set of equations. Because you’ve selected the Create new ERPset option, you’ll see the
usual window for saving a new ERPset. It will suggest a name composed of the original ERPset name with _chop (for “channel
operations”) appended to the end. However, this is just a suggestion, and it’s often good to use a more informative name. Let’s use
_CzRef instead of _chop. You should save it as a file if you’re not going to do the next step right away.
Channel Operations and the ERPLAB Design Philosophy
Creating a separate equation for each channel might seem overly complicated. After all, we’re applying the same operation to
almost every channel, so there’s considerable redundancy in the list of equations. Other EEG/ERP analysis systems have much
more concise ways of specifying how to re-reference the data. However, by specifying a literal equation for each channel, you
know exactly what the operation is doing to your data. In other systems, it’s not obvious exactly what the software is doing
when you re-reference the data. In fact, when I’ve used other systems, I’ve resorted to passing artificial data through the re-
referencing procedure so that I could figure out exactly what it was doing. In ERPLAB, you write the equations for re-
referencing, so there is no uncertainty about how the re-referencing works. This reflects one of our core design philosophies
when we created ERPLAB: No magic! We want researchers to know exactly what our software is doing to their precious data.
As an example of this philosophy, check out our documentation page on Timing Details. When you say you want to measure
the mean amplitude between 300 and 500 ms, what happens if your sampling rate is 256 Hz and you don’t have time points at
exactly 300 and 500 ms? We describe the exact algorithm that we use to round up or down.
The equation approach we use in Channel Operations has another benefit: It’s incredibly flexible. You can perform all kinds of
interesting transformations of the data, going way beyond re-referencing. For example, you can take the absolute value of a
channel to rectify it (which is useful if you have a channel that contains EMG data). You can create a new channel with the
global field power (Skrandies, 1989), as will be described below. You can compute the difference between two channels. And,
as you saw in Chapter 3, you can create a new “cluster” channel that is the average of a subset of your channels. To see the
possibilities, click the Equation examples button in ERP Channel Operations.
Now plot the data from Bins 3–5. You will see that the Cz channel is now flat, because a channel minus itself is zero. You’ll also
see that most of the channels now have a more positive voltage for the unrelated targets than for the related targets, and the
5.5.3 https://socialsci.libretexts.org/@go/page/87957

<!-- source_pdf=Full.pdf pdf_page=141 source_page_label="5.5.4" source_url="https://socialsci.libretexts.org/@go/page/87957" -->

## PDF page 141

- Source page label: 5.5.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87957

unrelated-minus-related difference is now positive instead of negative. In other words, with Cz as the reference, we have a P400
instead of an N400! Moreover, rather than being largest in the CPz channel, the unrelated-minus-related difference is now largest in
the F7 channel.
Next, let’s re-reference the data using Oz as the reference. That is, follow the same steps you used to re-reference the data to Cz,
but use ch12 instead of ch21 as the reference site and name the ERPset Grand_N400_diff_OzRef. When you plot the data, you’ll
see a small N400 in the CPz channel and an opposite-polarity “P400” in the F7 channel. So, you can see that the choice of the
reference determines whether a given ERP component is positive, negative, or positive at some sites and negative at others. The
reference electrode also impacts which channel has the biggest effects. It really matters!
This page titled 5.5: Exercise- Re-Referencing the N400 ERP CORE Data is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
5.5.4 https://socialsci.libretexts.org/@go/page/87957

<!-- source_pdf=Full.pdf pdf_page=142 source_page_label="5.6.1" source_url="https://socialsci.libretexts.org/@go/page/87958" -->

## PDF page 142

- Source page label: 5.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87958

5.6: Exercise- The Average Reference
Earlier in this chapter, we defined the absolute voltage as the potential between a given electrode and the average of the entire
surface of the head. This is a strictly theoretical concept, because we can’t record from the entire surface of the head. How would
you get an electrode on the bottom side of someone’s skull?
However, many researchers try to approximate the absolute voltage by using the average across all the electrode sites in their
recording as the reference. Although this has been shown to be a good approximation for one particular generator site when an
extremely broad array of electrodes is used (Dien, 1998), it often provides a very poor approximation of the absolute voltage (see
Chapter 7 in Luck, 2014). Nonetheless, the average reference can still be useful under some conditions. For example, it is
commonly used for studies of face-elicited N170 activity (Rossion & Jacques, 2012), and we used it for the N170 paradigm in the
ERP CORE (Kappenman et al., 2021).
In this exercise, we’ll re-reference the data in Grand_N400_diff.erp to the average of all the EEG electrodes. To accomplish this,
load Grand_N400_diff.erp into ERPLAB if it’s not already loaded, and make sure that the original ERPset is active (rather than
the ERPsets that you created with Cz or Oz as the reference). Select EEGLAB > ERPLAB > ERP Operations > ERP Channel
Operations, clear out any equations that remain in the text box from the last time you used this routine, and make sure that the
Mode is set to Create new ERPset.
Now click the Reference assistant button. In the text box labeled Ch_REF near the top of the window, type avgchan( 1:28 ). This
indicates that you want to use the average of channels 1–28 as the reference. We’re excluding channels 29 and 30, which are the
EOG channels. As before, select Exclude these channels with 29 30 in the text box. Then click OK. You’ll see that the list of
equations subtracts avgchan( 1:28) from each individual channel, except for the EOG channels. If you go through the algebra of
this subtraction, you’ll see that this will create EEG channels that are equal to the active electrode minus the average of all the
electrodes. Now click RUN, and then name the new ERPset Grand_N400_diff_AvgRef.
Now plot the data. Just as you saw with the Oz reference, you’ll see that the difference between related and unrelated targets with
the average reference is positive at some sites and negative at others. This is an inevitable consequence of using the average of all
sites as the reference. That is, at every moment in time, the average-referenced voltages across the different electrode sites must
sum to zero, so the voltage will be negative at some electrode sites and positive at others. This is true both for parent waveforms
(e.g., the waveforms for the related and unrelated target words) and for difference waveforms. So, when you use the average
reference, don’t think you’ve discovered something interesting when you find that your experimental effect is positive in some
channels and negative in others. It’s just a necessary consequence of the algebra. Some components and experimental effects will
exhibit such polarity inversions with other references, but it is inevitable with the average reference.
I’d like to point out using the average across sites as the reference in order to approximate the absolute voltage assumes that the
surface of the head sums to zero, but this is only true for spheres. I have yet to meet someone with a spherical head. And no neck.
Fortunately, there is a way to estimate the true zero, called the Reference Electrode Standardization Technique (REST), and there is
an EEGLAB plugin that implements it (Dong et al., 2017). I haven’t tried it myself or looked at the math, so I don’t have an
opinion about whether it’s useful and robust. But if you really want to get an estimate of the absolute voltage, REST seems like the
best current approach.
This page titled 5.6: Exercise- The Average Reference is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
5.6.1 https://socialsci.libretexts.org/@go/page/87958

<!-- source_pdf=Full.pdf pdf_page=143 source_page_label="5.7.1" source_url="https://socialsci.libretexts.org/@go/page/108168" -->

## PDF page 143

- Source page label: 5.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108168

5.7: What is the Best Reference Site?
Figure 5.2 shows the data for a few key channels with the four references we’ve used so far (Average of P9 and P10, Cz, Oz, and
the average of all the EEG sites). As you can see, the choice of reference electrode has a massive effect on the waveforms. But
which of these is the correct way to reference the data? That is, which reference site will give us the true waveforms?
Figure 5.2. Grand average ERP waveforms for selected channels from the N400 ERP CORE experiment with four different
references.
If you think about it, these are not meaningful questions. Voltage is the potential for electrical current to flow between two places. It
makes no sense to talk about the voltage at a single electrode site. Even if we could measure (and not merely estimate) the absolute
voltage, it would have no special truth status. For example, the cortical generator site of a given ERP component could be quite far
away from the electrode with the largest voltage.
Even if there is no “correct” way to reference the data, is there a “best” way? I discuss this issue in detail in Chapter 5 of Luck
(2014). My bottom line is that the best approach is usually to use whatever is most common in a particular area of research. If you
don’t use the same reference as most other studies, then people can’t compare your data with the data from other similar studies.
And you might think you’ve discovered a new effect. For example, most language ERP studies use the average of the mastoids as
the reference, and if you use the average reference, you might think you’ve discovered a new “P400” component at the F7
electrode site.
If you have a good reason to use an atypical reference in a given study, you should also show what the data look like with the
typical reference (e.g., by providing the waveforms with the typical reference in online supplementary materials). That way, no one
will be confused about the relationship between your study and other studies.
My final piece of practical advice about the reference electrode—especially when you’re first starting out in ERP research or
looking at a new component—is to look at your data with multiple different references (as in Figure 5.2). That way, you won’t be
lulled into thinking that the waveform in a given channel primarily reflects brain activity at the so-called active electrode for that
channel. That is, you’ll see that the reference has a big effect on your data, and you’ll realize that no matter what reference you use,
you’re looking at the potential between two sites.
I’ve made this recommendation to many people, but I don’t know how many of them have followed my advice. However, I do
know that the people who have followed it and then discussed their experiences with me said that it really helped them understand
their data better. So give it a try!
This page titled 5.7: What is the Best Reference Site? is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
5.7.1 https://socialsci.libretexts.org/@go/page/108168

<!-- source_pdf=Full.pdf pdf_page=144 source_page_label="5.8.1" source_url="https://socialsci.libretexts.org/@go/page/108169" -->

## PDF page 144

- Source page label: 5.8.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108169

5.8: Exercise- Current Density
The need to use a reference electrode to measure voltage can sometimes make it difficult to answer the scientific question of
interest. Fortunately, there are two common ways of transforming the data into a reference-free signal, namely converting the
voltage to current density or computing the global field power. I’ve used both transformations, and they can be quite useful.
Let’s start with current density (also called current source density). Unlike voltage, which always involves two places, current is the
flow of charges at a single point. There is no reference for measures of current. Unfortunately, we can’t directly measure the current
flowing out of the scalp at a given electrode site. But fortunately, we can estimate the current flow from the pattern of voltage
across a set of electrodes. To estimate the current flow perpendicular to the scalp (the current density or current source density) at a
given time point, we apply the Laplacian transform to the distribution of voltage across the scalp at that time point. The details are
described in Chapter 7 of Luck (2014). Here, we’ll see how it’s actually done using ERPLAB.
Load Grand_N400_diff.erp into ERPLAB if it’s not already loaded, and make sure that it’s the active ERPset. Plot the Bin 5
(unrelated minus related target) waveforms, and keep the plot window open so that you can compare the voltages in this ERPset
with the current density values that we’ll create.
The Laplacian transform requires that the 3-dimensional locations of the electrodes are specified in the ERPset. They should
already be present in Grand_N400_diff.erp, and we provide a tool for adding them to your own data (EEGLAB > ERPLAB >
Plot ERP > Edit channel location table). The Laplacian transform also requires that all channels have the same reference, so we’ll
need to eliminate the bipolar VEOG and HEOG channels from our data. To do this, select EEGLAB > ERPLAB > ERP
Operations > ERP Channel Operations, clear out any equations that remain in the text box from the last time you used this
routine, make sure that Try to retain location information is checked, click the Remove Channel(s) button, and specify 29 30 as
the indices of the channels to be removed.
Now we’re ready to convert from voltage to current density. Select EEGLAB > ERPLAB > Datatype Transformations >
Compute Current Source Density (CSD) data from averaged ERP data. It will bring up a window that shows your electrode
locations (so that you can make sure they’re correct) and has some parameters. Just leave the parameters at their default values and
click Generate CSD.
Now plot the Bin 5 (unrelated minus related target) waveforms for this new ERPset. If you look at the CPz channel, you’ll see an
N400 (a negativity peaking around 400 ms). However, if you look at the surrounding sites, you’ll see that N400 current density has
a much more focused scalp distribution than the N400 voltage that you plotted prior to performing the Laplacian transformation.
For example, the N400 is quite large at Pz in the voltage waveforms but near zero in the current density waveforms. This is typical:
The Laplacian transformation creates are narrower scalp distribution. This is sometimes very useful, because it allows us to
separate components that have different but overlapping voltage distributions. Once we convert voltage to current density, the
components may be at distinct sites, allowing us to measure them separately.
We can see this better by plotting scalp maps. Let’s start with the voltage. Select the original ERPset (with the EOG channels
removed) in the ERPsets menu, and select EEGLAB > ERPLAB > Plot ERP > Plot ERP scalp maps. Set the plotting parameters as
shown in Screenshot 5.3. We’re going to plot the difference wave (Bin 5), using the mean voltage from 300 to 500 ms. When
everything is set, click PLOT, and you should see a scalp map like the one in the lower left of Screenshot 5.3. Note that the
negative voltage is centered at the CPz electrode site and broadly distributed, with a slight bias toward the right hemisphere (which
is typical for the N400).
Now select the ERPset with the current density and repeat the procedure for plotting the scalp map. The result should like the map
in the lower right of Screenshot 5.3. Note that the negativity is now much sharper, and you can actually see separate foci over the
left and right hemispheres. The most important thing, however, is that we are now looking at (an estimate of) the current flowing
out of the scalp at each location, not a potential between each location and the reference site. The location of the original reference
site no longer matters.
5.8.1 https://socialsci.libretexts.org/@go/page/108169

<!-- source_pdf=Full.pdf pdf_page=145 source_page_label="5.8.2" source_url="https://socialsci.libretexts.org/@go/page/108169" -->

## PDF page 145

- Source page label: 5.8.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108169

Screenshot 5.3
This page titled 5.8: Exercise- Current Density is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
5.8.2 https://socialsci.libretexts.org/@go/page/108169

<!-- source_pdf=Full.pdf pdf_page=146 source_page_label="5.9.1" source_url="https://socialsci.libretexts.org/@go/page/108170" -->

## PDF page 146

- Source page label: 5.9.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108170

5.9: Exercise- Global Field Power
Another useful reference-free transformation is mean global field power. If you have a reasonable number and spread of electrodes,
any given ERP component will produce a systematic gradient in the amplitude across electrode sites that is proportional to the
amplitude of the internal generator. For example, Screenshot 5.4 (which I generated with the Viewer in the Measurement Tool)
overlays all 28 scalp electrodes for the unrelated-minus-related difference wave in the N400 experiment (referenced to the average
of P9 and P10). The spread of voltage values across electrode sites is proportional to the amplitude of the N400. We can quantify
this spread by taking the standard deviation across sites at any given time point. This standard deviation is called the global field
power or GFP. Because the reference electrode contributes equally to each channel, it is effectively a constant and has no impact on
the GFP.
Screenshot 5.4
Let’s compute the GFP for the data in the N400 data. Load Grand_N400_diff.erp into ERPLAB if it’s not already loaded, and
make sure that it’s the active ERPset. Select EEGLAB > ERPLAB > ERP Operations > ERP Channel Operations, clear out any
equations that remain in the text box from the last time you used this routine, and change the Mode to Modify existing ERPset.
We’re going to create a new channel (channel 31) with the GFP for the EEG channels (channels 1–28). To do this, put the following
equation in the ERP Channel Operations text box:
ch31 = mgfperp(1:28) label GFP
Now click RUN, and then plot the data from Bin 5. At the bottom of the plot, you should see a channel labeled GFP (see
Screenshot 5.5). This waveform is the standard deviation across channels 1–28 at each time point, and you can see that the time
course matches the time course of the difference wave at the other electrode sites. However, when we look at the GFP, we no longer
have to worry about that pesky reference electrode issue.
Screenshot 5.5
GFP has some other virtues as well. For example, it is typically cleaner than the individual-channel waveforms (because noise is
typically minimized by transformations that combine the data from multiple sites). In addition, rather than having to choose which
electrode site or sites to use in your statistical analyses (which can be a source of bias), you can just measure the amplitude or
latency from the GFP waveform (Hamburger & Van der Burgt, 1991). However, you should keep in mind that the standard
deviation across channels will increase as the noise level increases, so special methods are necessary to compare GFP amplitudes
across conditions that differ in the number of trials or any other factor that might impact the noise level (Files et al., 2016).
5.9: Exercise- Global Field Power is shared under a CC BY license and was authored, remixed, and/or curated by LibreTexts.
5.9.1 https://socialsci.libretexts.org/@go/page/108170

<!-- source_pdf=Full.pdf pdf_page=147 source_page_label="5.10.1" source_url="https://socialsci.libretexts.org/@go/page/108171" -->

## PDF page 147

- Source page label: 5.10.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108171

5.10: Exercise- Referencing the EEG Data from the ERP CORE N400 Experiment
For the sake of simplicity, the preceding exercises in this chapter were performed on grand average ERP waveforms. This is fine
for visualization, but you will ordinarily need to re-reference the single-subject data. The kinds of re-referencing we’ve been
discussing so far in this chapter can be applied to the continuous EEG, the epoched EEG, or the averaged ERPs. In many cases,
however, you will need to re-reference the EEG prior to artifact rejection or correction. In this exercise, we’ll see how to re-
reference the continuous EEG.
Before you start this exercise, I recommend quitting and restarting EEGLAB so that everything is fresh. You won’t need any of the
data you created in the previous exercises.
In the Chapter_5 folder, you’ll find a dataset named 6_N400_unreferenced.set. This is EEG dataset for the participant we looked
at in Chapter 2. In that chapter, we looked at a dataset that had already been referenced, but this version has not be referenced.
However, it has been filtered (0.1–30 Hz). Launch EEGLAB and load this file (EEGLAB > File > Load existing dataset) and take
a look at the EEG (EEGLAB > Plot > Channel data (scroll)). Set the vertical scale to 100 µV, and click the >> button once to
scroll to the 5 second point. You should see something like Screenshot 5.6.
Screenshot 5.6
These data were recorded with a BioSemi ActiveTwo EEG recording system, which saves the single-ended data rather than saving
the referenced data. So, the voltages that you’re looking at are the raw voltages between each active electrode and the ground
electrode (or, more precisely, the common mode sense electrode, which is BioSemi’s equivalent of ground). You can see EEG from
the P9 and P10 channels, which were used as the reference in data from the previous exercises. In the present exercise, we’ll
reference (not re-reference) the data to the average of P9 and P10.
We'll also create special bipolar versions of the horizontal EOG and vertical EOG (HEOG and VEOG) channels. To understand
why this is useful, take a look at the channel labeled VEOG-lower at the bottom of the plot. This electrode was located just below
the right eye, and the negative-going deflection that you can see in this channel shortly after the 5 second mark is an eyeblink. If
you look at the FP1 and FP2 channels at the same time, you’ll see a positive-going deflection. This pattern occurs because
5.10.1 https://socialsci.libretexts.org/@go/page/108171

<!-- source_pdf=Full.pdf pdf_page=148 source_page_label="5.10.2" source_url="https://socialsci.libretexts.org/@go/page/108171" -->

## PDF page 148

- Source page label: 5.10.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108171

eyeblinks (and vertical eye movements) arise from a dipole located inside the eyes, and electrodes under versus over the eyes are
on opposite sides of this dipole, yielding opposite polarities.
Brain activity spreads over the entire head, so the VEOG-lower electrode picks up brain activity as well as the electrooculogram
(EOG) voltage produced by eyeblinks. However, most brain activity will be quite similar at electrodes just above and just below
the eye. We can therefore isolate the EOG activity and largely eliminate the brain activity by subtracting the FP2 signal (just above
the right eye) from the VEOG-lower signal (just below the right eye). In addition, because the blink activity is positive at FP2 and
negative at VEOG-lower, this subtraction also increases the size of the blink activity. When we try to reject trials with blinks, this
subtraction makes our job much easier, because it makes the blinks bigger and makes non-blink EEG activity smaller. Thus, when
we reference the data from our EEG electrodes, we’ll also create a bipolar VEOG channel in which we subtract FP2 from VEOG-
lower.
All EEG voltages are actually “bipolar” in the sense of having two poles (active and reference). However, the term bipolar is used
in EEG recordings when a channel uses a special reference that is different from the other channels.
We also usually create a bipolar HEOG signal to isolate horizontal eye movements. During a typical EEG recording, we place one
HEOG electrode next to the left eye (HEOG-left) and another next to the right eye (HEOG-right). When the eyes move leftward,
this produces a negative voltage at HEOG-left and a positive voltage at HEOG-right. This reverses for rightward eye movements.
By creating a bipolar channel (HEOG-right minus HEOG-left), we can effectively double the size of the eye movement voltage. In
addition, brain activity is usually quite similar at these two sites, so this subtraction also eliminates most of the brain activity. Thus,
the bipolar HEOG signal is very useful when we try to reject trials with horizontal eye movements.
Enough talk—let’s try it! We’ll reference each scalp channel to the average of P9 and P10, and we’ll create bipolar VEOG and
HEOG channels. With the 6_N400_unreferenced.set dataset loaded and active, select EEGLAB > ERPLAB > EEG Channel
Operations. This is nearly identical to ERP Channel Operations, but it operates on the EEG (whether continuous or epoched).
Clear out any existing equations and set the mode to Create new dataset.
Click the Reference assistant button and type (ch9+ch27)/2 into the Ch_REF text box. P9 is in Channel 9, and P10 is in Channel
27, so this expression gives us the average of P9 and P10. Check the boxes shown in Screenshot 5.7. Even the EOG channels will
benefit from having a reference electrode, so indicate that All channels should be included. The click OK to create the equations.
In the main EEG Channel Operations GUI, you should now see that each channel being created will be computed as the original
channel minus the average of P9 and P10.
5.10.2 https://socialsci.libretexts.org/@go/page/108171

<!-- source_pdf=Full.pdf pdf_page=149 source_page_label="5.10.3" source_url="https://socialsci.libretexts.org/@go/page/108171" -->

## PDF page 149

- Source page label: 5.10.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108171

Screenshot 5.7
Now we need to add equations for creating the bipolar EOG signals. For reasons that will become clear in the chapter on artifact
correction, it’s often a good idea to have both the bipolar signals and the signals referenced to the average of P9 and P10. To make
this happen, add the following two equations to the list of equations in the EEG Channel Operations GUI:
nch34 = ch31 - ch32 Label HEOG-bipolar
nch35 = ch33 - ch16 Label VEOG-bipolar
The new Channel 34 will be HEOG-right minus HEOG-left, and the new Channel 35 will be VEOG-lower minus FP2 (which is
just above the right eye). The list of equations should look like that shown in Screenshot 5.8. Click RUN, and name the new dataset
6_N400_ref to indicate that it has now been referenced. You’ll want to refer to this dataset in the next exercise, so save it as a file if
you’re not going to do the next exercise right away.
Now plot the data with EEGLAB > Plot > Channel data (scroll). The most obvious change is that the bipolar EOG channels are
now present. You can see that blinks are larger in the VEOG-bipolar channel than in the VEOG-lower or FP2 channels. The N400
task used stimuli presented in the center of the monitor, so there aren’t any obvious horizontal eye movements. We'll see what those
look like in the chapter on artifact rejection.
5.10.3 https://socialsci.libretexts.org/@go/page/108171

<!-- source_pdf=Full.pdf pdf_page=150 source_page_label="5.10.4" source_url="https://socialsci.libretexts.org/@go/page/108171" -->

## PDF page 150

- Source page label: 5.10.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108171

Screenshot 5.8
This page titled 5.10: Exercise- Referencing the EEG Data from the ERP CORE N400 Experiment is shared under a CC BY 4.0 license and was
authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
5.10.4 https://socialsci.libretexts.org/@go/page/108171

<!-- source_pdf=Full.pdf pdf_page=151 source_page_label="5.11.1" source_url="https://socialsci.libretexts.org/@go/page/108172" -->

## PDF page 151

- Source page label: 5.11.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108172

5.11: Exercise- Other Common Re-Referencing Scenarios
The previous exercise began with the single-ended data produced by the BioSemi system we used for the ERP CORE experiments,
so we referenced the data rather than re-referencing the data. Most EEG systems give you differential (referenced) data rather than
single-ended data, but it is often necessary to re-reference the data from these systems offline . In this exercise, we’ll see how to
implement two common re-referencing scenarios you might encounter with differential data. In the first scenario, the data were
recorded with a left mastoid reference, but you want to use the average of the left and right mastoids as the reference. In the second,
the data were recorded with Cz as the reference (which is the default in the EGI system), and you again want to use the average of
the mastoids as the reference. Another common scenario would be to take referenced data and re-reference to the average of all
sites, but we already saw how to do that in an earlier exercise. (That exercise used averaged ERPs rather than EEG, but re-
referencing works the same with ERP data and EEG data.)
I’ve created two versions of the EEG data from the preceding N400 example for these two scenarios, and you can find them in the
Chapter_5 folder. The file named 6_N400_LmRef.set has EEG and EOG data referenced to the left mastoid (including an Rm
channel that has EEG data from the Rm site that were referenced to Lm). The file named 6_N400_CzRef.set has EEG and EOG
data referenced to Cz (including Lm and Rm channels that were referenced to Cz). Go ahead and load these two files into
EEGLAB.
Where did these datasets come from?
I don’t actually have files for the N400 experiment that were recorded using Lm or Cz as the reference, so I created
approximations by applying Channel Operations to the single-ended data. I simply relabeled the P9 and P10 channels as Lm
and Rm. That is, we’re just going to pretend that P9 was actually Lm and P10 was actually Rm. In 6_N400_LmRef.set, we’ll
pretend that the data were referenced to Lm (even though I actually referenced the data to P9). This file contains a channel
labeled Rm, which we’re pretending is the voltage between Rm and Lm (but is actually the voltage between P10 and P9). In
6_N400_CzRef.set, I simply referenced the data to to Cz (including channels labeled Lm and Rm that actually have the data
from P9 and P10, referenced to Cz).
Let’s start by re-referencing the data in 6_N400_LmRef.set to the average of the left and right mastoids. As we saw in the exercises
using the spreadsheet, we can do this by simply subtracting 50% of the voltage between Rm and Lm from the voltage in each
channel. Make sure the 6_N400_LmRef.set dataset is active and then select EEGLAB > ERPLAB > EEG Channel Operations.
Clear out any existing equations and make sure the mode is set to Create new dataset. You can then use the Reference assistant to
create the appropriate equation for each channel. But this time, I’m not going to tell you how to do it; you should figure it out for
yourself. You can look at the list of Existing Channels in the Channel Operations GUI to figure out the channel number for the Rm
signal. (If you get stuck, the equations are in a file named Re-Reference_Lm.txt. But you’ll learn a lot more if you figure it out for
yourself.) Once you’re done, you can plot the data. The waveforms should look nearly identical to those you created in the previous
exercise, with the average of P9 and P10 as the reference.
If you did it the same way I did, you’ll still have a channel labeled Rm, but now it's the voltage between Rm and the average of Lm
and Rm. It’s not a very useful channel, but it doesn’t hurt to keep it. Alternatively, you could keep the original signal, with Rm
referenced to Lm. Or you could just eliminate that channel.
Now let’s re-reference the data in 6_N400_CzRef.set to the average of the left and right mastoids. This is pretty simple: We just
need to subtract the average of the two mastoids from each channel. To make it a little more challenging, you should also include
an equation to recover the Cz signal, referenced to the average of the two mastoids. Again, I’m not going to tell you how to do it,
but here’s a hint for recreating Cz: the voltage at Cz with Lm as the reference is the same as -1 times the voltage at Lm with Cz as
the reference. Don’t forget to look at the list of Existing Channels in the Channel Operations GUI to figure out the channel
numbers for the Lm and Rm signals. (If you get stuck, the equations are in a file named Re-Reference_Cz.txt.) Again, when you
plot the data, the waveforms should look nearly identical to those you created in the previous exercise. Pay particular attention to
the Cz channel to make sure the one you just created looks like the original.
This page titled 5.11: Exercise- Other Common Re-Referencing Scenarios is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
5.11.1 https://socialsci.libretexts.org/@go/page/108172

<!-- source_pdf=Full.pdf pdf_page=152 source_page_label="5.12.1" source_url="https://socialsci.libretexts.org/@go/page/108173" -->

## PDF page 152

- Source page label: 5.12.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/108173

5.12: Matlab Script For This Chapter
I’ve provided a script called referencing_examples.m in the Chapter_5 folder. This script implements the EEG referencing/re-
referencing procedures from the last few exercises. It uses equations stored in text files, which can be quite convenient.
This page titled 5.12: Matlab Script For This Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
5.12.1 https://socialsci.libretexts.org/@go/page/108173

<!-- source_pdf=Full.pdf pdf_page=153 source_page_label="5.13.1" source_url="https://socialsci.libretexts.org/@go/page/137598" -->

## PDF page 153

- Source page label: 5.13.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137598

5.13: Key Takeaways and References
Key Takeaways
Voltage is the potential for charges to flow from one location (the so-called active site) to another location (the so-called
reference site). There is no such thing as the voltage at a single electrode site.
When you’re looking at data from a channel that is labeled with the so-called active electrode site for that channel (e.g., Pz), the
waveforms are impacted equally by activity the so-called active and so-called reference sites. If you don’t know what the
reference was, you really don’t know what you’re looking at. You should always find out what reference was used before you
spend time looking at ERP waveforms
There is no “correct” reference location. No matter what you use, the data are impacted equally by the so-called reference and
so-called active electrodes.
The “best” reference is usually whatever is common in your subarea (because using the same reference facilitates comparisons
across studies).
To avoid falling into the trap of thinking that the waveform from a given channel is primarily a result of the so-called active
electrode for that channel, it can be helpful to look at your data with multiple different reference sites. For this purpose, it is
usually sufficient to re-reference the grand average ERPs.
It is simple to re-reference data offline. In many cases, you can make one of your channels (or the average of a set of channels)
the reference by simply subtracting it from the other channels (assuming that they all started with the same reference).
You can avoid the reference issue altogether by converting your voltage waveforms into current density or global field power.
References
Dien, J. (1998). Issues in the application of the average reference: Review, critiques, and recommendations. Behavior Research
Methods, Instruments & Computers, 30, 34–43.
Dong, L., Li, F., Liu, Q., Wen, X., Lai, Y., Xu, P., & Yao, D. (2017). MATLAB Toolboxes for Reference Electrode Standardization
Technique (REST) of Scalp EEG. Frontiers in Neuroscience, 11. https://doi.org/10.3389/fnins.2017.00601
Files, B. T., Lawhern, V. J., Ries, A. J., & Marathe, A. R. (2016). A Permutation Test for Unbalanced Paired Comparisons of Global
Field Power. Brain Topography, 29, 345–357. https://doi.org/10.1007/s10548-016-0477-3
Hamburger, H. L., & Van der Burgt, M. A. G. (1991). Global Field Power measurement versus classical method in the
determination of the latency of evoked potential components. Brain Topography, 3(3), 391–396.
https://doi.org/10.1007/BF01129642
Kappenman, E. S., Farrens, J. L., Zhang, W., Stewart, A. X., & Luck, S. J. (2021). ERP CORE: An Open Resource for Human
Event-Related Potential Research. NeuroImage, 225, 117465. https://doi.org/10.1016/j.neuroimage.2020.117465
Luck, S. J. (2014). An Introduction to the Event-Related Potential Technique, Second Edition. MIT Press.
Nunez, P. L. (1981). Electric Fields of the Brain. Oxford University Press.
Rossion, B., & Jacques, C. (2012). The N170: Understanding the time course of face perception in the human brain. In S. J. Luck &
E. S. Kappenman (Eds.), The Oxford Handbook of Event-Related Potential Components (pp. 115–141). Oxford University Press.
Skrandies, W. (1989). Data reduction of multichannel fields: Global field power and Principal Component Analysis. Brain
Topography, 2(1), 73–80. https://doi.org/10.1007/BF01128845
Yao, D. (2017). Is the Surface Potential Integral of a Dipole in a Volume Conductor Always Zero? A Cloud Over the Average
Reference of EEG and ERP. Brain Topography, 30(2), 161–171. https://doi.org/10.1007/s10548-016-0543-x
This page titled 5.13: Key Takeaways and References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
5.13.1 https://socialsci.libretexts.org/@go/page/137598
