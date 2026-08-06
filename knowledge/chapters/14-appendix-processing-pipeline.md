# 14: Appendix 3: Example Processing Pipeline

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 364-369. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=364 source_page_label="14.1" source_url="https://socialsci.libretexts.org/@go/page/137523" -->

## PDF page 364

- Source page label: 14.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137523

14: Appendix 3: Example Processing Pipeline
This appendix provides an example of a typical EEG preprocessing pipeline for a single participant, including all the steps prior to
averaging. It is nearly identical to the pipeline scripts provided in the second half of the chapter on Scripting (Chapter 10). Much of
the logic for the ordering of the steps is spelled out in Luck (2014), especially Appendix 1.
This pipeline is optimized for the kinds of experiments typically conducted in my lab, such as the ERP CORE experiments, in
which highly cooperative college student participants are tested with in relatively simple cognitive tasks. Changes will often be
necessary for different types of tasks and/or participants. In other words, don’t blindly follow this pipeline!
Step 1: Preprocessing Prior to ICA-Based Artifact Correction
Import the participant’s original EEG data file(s) into EEGLAB
If there are multiple data files (e.g., one per trial block), combine them into a single dataset.
If the cap was removed and replaced between data files (e.g., because you had recording sessions on multiple days), you
should merge the data files after the ICA step (because the electrodes might not be in exactly the same places for the
different files, which will mess up ICA but isn’t a big deal for most other kinds of analyses).
If a given channel is bad in a subset of the blocks, you could interpolate that channel for those blocks at this stage. If you
do this, you should apply the filtering step described below at this stage, which will make the interpolation work better.
(And then you will skip the filtering at the later stage.)
If your data were recorded without a reference (usually this is only for the BioSemi ActiveTwo system), you may receive a
warning that strongly encourages you to reference the data now. Do not do it. You will reference the data at a later step.
Recommended: Save this dataset as a file
If appropriate, shift the stimulus event codes in time to account for any consistent mismatch between the time of the event code
and the actual stimulus onset time
All LCD displays interpose a constant delay between the time that the video information arrives from the computer’s video
card and the time that the image is presented on the screen. This delay cannot be detected by the computer and cannot be
determined reliably from the manufacturer’s specifications. It must be measured with some kind of photosensor. This delay
is often greater than 25 ms, so it must be accounted for.
Almost all video displays (LCD and CRT) have a delay that depends on the vertical position of the stimulus on the display.
This delay is typically ~15 ms for the bottom of the display relative to the top (assuming a refresh rate of 60 Hz). If you are
using stimuli at very different vertical locations in your different experimental conditions, you should measure the delay
separately for the different locations and adjust accordingly. For large stimuli that are vertically centered, we measure the
delay in the vertical center of the display.
Delays may also occur for stimuli in other modalities. The delay should be measured and, if substantial, accounted for by
shifting the event codes.
Make sure that you shift only the stimulus event codes and not the response event codes (unless the there is also a delay for
the responses). Use a positive shift value because the event code needs to be shifted later in time (because the stimulus
occurred after the event code).
ERPLAB’s function for shifting event codes creates a CSV file showing how each event code was shifted. You should look
at this file to verify that the shifting was correct.
It’s also important to verify that the delay is consistent (±1 sample period). If it is not consistent, there is probably a problem
with the stimulus presentation script.
If desired, downsample your data to a lower sampling rate
My lab typically records at 500 Hz and then downsamples to 250 Hz. This gives us a higher sampling rate if we ever need it,
but downsampling to 250 Hz makes the subsequent data processing faster and the data files half as large.
Note that EEGLAB’s pop_resample routine will automatically apply an appropriate antialiasing filter prior to the resampling
process.
Apply a bandpass filter to the EEG and EOG channels
We ordinarily use a non-causal Butterworth impulse response function, 0.1–30 Hz half-amplitude cut-off, 12 dB/oct roll-off.
14.1 https://socialsci.libretexts.org/@go/page/137523

<!-- source_pdf=Full.pdf pdf_page=365 source_page_label="14.2" source_url="https://socialsci.libretexts.org/@go/page/137523" -->

## PDF page 365

- Source page label: 14.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137523

Some researchers prefer a lower cutoff for the high-pass filter (e.g., .05 Hz or .01 Hz), especially when looking at slow
components like the late positive potential. However, we find that 0.1 Hz works best in most cases. Do not use anything
higher than 0.1 Hz unless you really know what you’re doing!
You should apply the option for removing the DC offset in the data prior to filtering. This can reduce the edge artifacts
that occur at the beginning and end of each recording period.
If extensive 60 Hz noise is present, you can apply the cleanline plugin (Mitra & Pesaran, 1999; see Bigdely-Shamlo et al.,
2015 for important details about implementing this tool). If cleanline doesn't work well for you, you can try the newer
Zapline method (de Cheveigné, 2020; Klug & Kloosterman, 2022). Alternatively, you could decrease the low-pass
frequency to 20 Hz and/or increase the slope of the low-pass filter to 48 dB/octave (which requires doing the low-pass and
high-pass filtering as separate steps).
If you have also recorded other signals (e.g., a photosensor), you may not want to filter those channels (or you might want
different filtering parameters for those channels).
Add channel location information specifying the 3-D locations of the electrodes.
Perform channel operations to create bipolar channels (and to reference the data if they were not referenced during the
recording).
Create a bipolar HEOG channel (HEOG-left minus HEOG-right or vice versa)
If you do not have HEOG electrodes, you can use F7 minus F8 (or just skip this step).
If your data already contain a bipolar HEOG channel, you should skip this step.
Create a bipolar VEOG channel (VEOG-lower minus the closest electrode that is above the eyes). For example, if the
VEOG-lower electrode is under the left eye, the FP1 signal would ordinarily be subtracted from the VEOG-lower signal.
If your data already contain a bipolar VEOG channel, you should skip this step.
Keep the original, monopolar EOG channels, which will be important for ICA.
Make sure that the channel location information is preserved by the Channel Operations routine.
If your data were not recorded with a reference, reference the data now.
In some systems (e.g., BioSemi ActiveTwo), the data saved to disk are not referenced and you should perform
referencing now. However, if your data were referenced during recording, do not re-reference now. The re-referencing
will be performed later, after artifact correction.
In most labs that use the Brain Products ActiCHamp system, the data are already referenced at this point. However, our
lab has a custom version of the data acquisition system in which the data are not referenced. Our lab therefore references
at this point (and we re-reference later, after artifact correction).
If you are referencing now, use a single electrode site as the reference. If a combination of sites is desired in the long run
(e.g., the average of all sites, the average of the mastoids), you will re-reference to that combination later.
It doesn’t really matter what site is used as the reference at this point. My lab uses P9.
Recommended: Save the resulting dataset as a file. We call this dataset the pre-ICA dataset.
View the EEG to make sure everything looks okay and to identify channels that require interpolation. These channels will be
left out of the ICA decomposition process. The actual interpolation will be done after the ICA correction has been performed.
To identify channels that should be interpolated:
Visually inspect the EEG on both short (e.g., 5-second) and long (e.g., 60-second) time scales. This video demonstrates
how to perform an initial visual inspection of continuous EEG data https://doi.org/10.18115/D5V638.
If the voltage drifts around or there are many sudden changes in voltage, that channel should be interpolated.
If a channel is fine for most of the session but shows occasional periods of large deflections, this channel can be
interpolated after epoching but limited to epochs in which the large deflections occur (as determined with the artifact
detection procedures).
If a channel shows a lot of high-frequency noise, it may not actually need to be interpolated.
If the main dependent variable will be the mean voltage over some time range (e.g., 200-300 ms for N2pc or 300-500
ms for N400), high-frequency noise is not usually a problem. The best way to tell if it will be a problem is to look at
the standardized measurement error (SME). If the SME for that channel is >2 SD beyond the mean SME of the other
14.2 https://socialsci.libretexts.org/@go/page/137523

<!-- source_pdf=Full.pdf pdf_page=366 source_page_label="14.3" source_url="https://socialsci.libretexts.org/@go/page/137523" -->

## PDF page 366

- Source page label: 14.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137523

channels (excluding EOG, Fp1, and Fp2), then the channel should be interpolated. If the channel is the main channel
for data analysis, you could interpolate if it is >1.5 SD beyond the mean.
If there is a lot of high-frequency noise, the signal may also be corrupted in this channel. To see this, make a note to
check the averaged ERP for that channel and surrounding channels after the averaging process. If the channel looks
quite different from the surrounding channels, the signal is probably corrupted and the channel should be interpolated
(which will require going back to this stage and repeating all the subsequent processes.
If the main dependent variable will be a latency value and/or a peak-related variable, high-frequency noise is more
likely to be a problem. You can confirm this by computing the bootstrapped SME when you get to the averaging step.
Save information about channels that should be interpolated in an Excel file. That makes it possible to repeat the processing
with a script.
If a given channel misbehaves only occasionally, save this information the Excel file that controls artifact detection.
Step 2: ICA-Based Artifact Correction
Make a copy of the pre-ICA dataset. We will use this new dataset for the ICA decomposition. This new dataset is called the
ICA decomposition dataset.
Apply the following operations to the ICA decomposition dataset.
Bandpass filter with half-amplitude cutoffs at 1 and 30 Hz, 48 dB/octave
It’s OK that we’ve double-filtered the data. The original filtering is so much milder that it will be dwarfed by the new
filter.
If your previous low-pass cutoff was at 20 Hz, use 20 Hz here as well
If your previous low-pass slope was 48 dB/octave, just do a high-pass filter at this stage (1 Hz, 48 dB/octave).
Note: It is important that this filtering is done before the following steps. Some of the following steps introduce
discontinuities in the EEG data, and those can lead to edge artifacts if the filtering is applied later.
Resample the data at 100 Hz.
This is not strictly necessary, but it makes the ICA decomposition faster.
Don’t resample if the recording was brief. You need enough data to train the ICA decomposition routine. See the chapter
on artifact correction for details on how much data is necessary.
Delete break periods, because the EEG is often “crazy” during breaks, which degrades the ICA decomposition.
A break is defined as a period of at least X ms without an event code, where X is some reasonable value (e.g., 2000 ms,
assuming that you never have 2000 ms between event codes except during breaks).
You can tell it to ignore certain event codes. You should always exclude boundary events. You may also want to exclude
response events (in case the subject makes button presses during the breaks).
You need a buffer at the edges of the break periods so that you do not cut into your eventual epochs (e.g., 1500 ms at the
beginning of the break and 500 ms at the end of the break).
Delete periods of “crazy” EEG (wild deflections, beyond what you see with ordinary artifacts).
This can ordinarily be done using ERPLAB’s Artifact rejection (continuous data) routine.
When setting the parameters, make sure that you are mainly rejecting segments of data with "crazy" EEG and are not
rejecting segments with blinks or other ordinary artifacts.
You should ordinarily exclude the EOG channels. If you include these channels, you may need a rejection threshold that
is too high for the EEG channels. For subjects with unusually large blinks, you may also need to exclude Fp1, Fp2, or
any other channels that are very close to the eyes.
For most subjects, a threshold of 500 µV and a window size of 1000 ms works well. However, you should visually
inspect the results and adjust these parameters if necessary. If blinks exceed the threshold, you will need to increase the
threshold (or perhaps exclude Fp1, Fp2, or other channels with huge blink activity). The final parameters should be
stored in an Excel spreadsheet for use in scripting.
Check the box labeled Join artifactual segments separated by less than and put 1000 in the corresponding text box.
Note that this deletion of segments with "crazy" EEG is designed only the improve the ICA decomposition. Once the
ICA weights are transferred back to the pre-ICA dataset to create the post-ICA dataset (see below), these segments will
14.3 https://socialsci.libretexts.org/@go/page/137523

<!-- source_pdf=Full.pdf pdf_page=367 source_page_label="14.4" source_url="https://socialsci.libretexts.org/@go/page/137523" -->

## PDF page 367

- Source page label: 14.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137523

be present in the data. You will later epoch the post-ICA data and apply ordinary artifact detection to mark and
eventually excluded any epochs that contain wild voltage deflections. This way, you will have an accurate count of the
number of trials excluded because of artifacts.
Recommended: Save the final version of the ICA decomposition dataset as a file.
Perform the ICA decomposition process on the ICA decomposition dataset.
Make sure that ‘extended’, 1 is set (it should be set by default). This allows ICA to detect sub-Gaussian components, such
as line noise and slow drifts.
Exclude the bipolar EOG channels (because we will use these later to see the blinks and eye movements). If your dataset
does not contain unipolar EOG signals, the ICA decomposition will still work reasonably well.
Exclude “bad channels” that will be interpolated.
If the ICA crashes or fails to converge, check the dataset to see if you have a lot of very short segments between boundary
events. If so, you may need to alter your procedures for deleting periods of "crazy" EEG (e.g., by increasing the value for
Join artifactual segments separated by less than).
Recommended: Save the result as a new file.
Examine the components (especially the scalp maps) to make sure that the decomposition worked correctly. You should have 1-
2 channels corresponding to blinks (and possibly vertical eye movements) and 1-2 channels corresponding to horizontal eye
movements.
My lab doesn’t ordinarily remove components corresponding to other artifacts, but this could be done when necessary for
EKG artifacts and perhaps others.
Determine which components correspond to artifacts that should be removed. This is done by both examining the scalp maps
and comparing the time course of the components with the time course of the EOG signals. This information should be stored in
a spreadsheet so that it can be used in scripts.
Transfer the ICA weights from the ICA decomposition dataset to the pre-ICA dataset. The result is called the post-ICA
dataset.
Remove the independent components corresponding to the artifacts.
Recommended: Save the result as a file.
Visually inspect the corrected data to make sure that the correction worked properly.
Step 3: Post-ICA EEG Processing (starting with the post-ICA dataset)
Re-reference the data
My lab’s current preference is the average of P9 and P10, with the average of the left and right mastoids as a second best
alternative. It is usually best to use whatever is most common in your area of ERP research. For example, we use the
average of all sites as the reference when we look at the N170 elicited by faces, because that is the most common reference
in that research area. This makes it easier to compare ERPs across studies (because a different reference can make the
waveforms and scalp distributions look radically different).
Also create bipolar HEOG and VEOG from the ICA-corrected EOG channels and look at them to assess the effectiveness of
the artifact correction.
Keep the uncorrected bipolar HEOG and VEOG signals, which we will use for detecting blinks and eye movements that
occurred near that time of stimulus onset and may have interfered with perception of the stimulus.
Perform the interpolation for the “bad channels” that were identified earlier.
Non-EEG channels (e.g., EOG channels, a photosensor channel, a skin conductance channel) should be ignored in the
process of computing interpolated values.
Note that interpolation should ordinarily be performed after high-pass filtering.
If you are using the average of all sites as the reference, you should either perform the interpolation before referencing or
exclude any to-be-interpolated sites from the reference.
Add an EventList to the dataset
Run BINLISTER to assign events to bins
Extract bin-based epochs
14.4 https://socialsci.libretexts.org/@go/page/137523

<!-- source_pdf=Full.pdf pdf_page=368 source_page_label="14.5" source_url="https://socialsci.libretexts.org/@go/page/137523" -->

## PDF page 368

- Source page label: 14.5
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137523

Important: Use ERPLAB’s tool (Extract bin-based epochs), not EEGLAB’s tool (Extract epochs). The subsequent ERPLAB
operations will not work correctly if you use EEGLAB’s tool.
Our standard epoch is from -200 to +800 ms. A longer prestimulus is used if we will be doing frequency-based analyses or if
we want to maximize trial-to-trial stability of the signal (e.g., for decoding, which is extraordinarily sensitive to trial-to-trial
variability).
Baseline correction is ordinarily applied at this step.
Recommended: Save the epoched dataset as a file.
Step 4: Artifact Detection
General procedure for a given type of artifact
Start with default detection parameters
Apply to data
Check number of trials detected
Scroll through data to determine whether the parameters were effective
If the parameters were not effective, update them and try again until effective parameters are found
The parameters should be stored in a spreadsheet for future scripting.
Standard artifacts to detect
Blinks and eye movements that might interfere with the perception of the stimulus
Test for blinks in the uncorrected bipolar VEOG channel and test for eye movements in the uncorrected HEOG channel
Use the step function with a window size of 200 ms and a step size of 10 ms
The test period should start at -200 ms (because vision is functionally suppressed for ~100 ms after the blink is complete,
so we want to detect blinks even if they ended shortly before stimulus onset)
The test period should be at least 200 ms and should terminate at or after the offset of the stimulus
Start with a threshold of 50 µV for blinks and 32 µV for eye movements (which corresponds to a 2° rotation of the eyes)
You can often look at the averaged EOG signals to see if you’ve successfully removed these artifacts.
General C.R.A.P. that increases measurement error
Apply to all channels except for the uncorrected HEOG and VEOG channels
Use both the absolute voltage threshold and moving window peak-to-peak algorithms; they occasionally catch different
trials
The test period should typically encompass the whole epoch.
150 µV is a good starting threshold.
The goal is to reduce measurement error, which you can quantify by looking at the SME. When you discard a trial
because of C.R.A.P., you reduce trial-to-trial variability, which decreases measurement error. However, you also reduce
the number of trials, which increases measurement error. The SME takes both into account and tells you whether, when
both factors are considered, the measurement error is better or worse.
You can tolerate more C.R.A.P. in a given channel if that channel will not contribute to your main analyses (e.g., if your
analyses will be limited to other channels). In many cases, most of the channels are used only when plotting scalp maps.
However, if you will be re-referencing after artifact detection, any channels that are part of the reference are important.
Note: Use a different flag for each type of artifact. This makes it possible to track how many artifacts of each type were
flagged.
The number of trials with versus without artifacts should be recorded. We do this aggregated across conditions (i.e., collapsed
across bins). If the percentage of rejected trials is greater than 25%, my lab always excludes the subject from the final analyses.
(We raise this threshold to 50% for studies of psychiatric and neurological conditions.) A different threshold for exclusion may
be appropriate for other kinds of research. However, it is important for the exclusion criterion to be set prior to looking at the
data.
After a participant’s data have been fully processed in this way (including visualizing the data and saving all the participant-
specific analysis parameters in one or more spreadsheets), the participant’s data should be reprocessed with a script
This should yield the same result, but it can avoid errors that may occur in manual processing
14.5 https://socialsci.libretexts.org/@go/page/137523

<!-- source_pdf=Full.pdf pdf_page=369 source_page_label="14.6" source_url="https://socialsci.libretexts.org/@go/page/137523" -->

## PDF page 369

- Source page label: 14.6
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137523

The ICA decomposition process does not need to be repeated when the data are re-processed with a script. That is, the
weights can be transferred from the ICA decomposition dataset created during the manual processing.
References
Bigdely-Shamlo, N., Mullen, T., Kothe, C., Su, K.-M., & Robbins, K. A. (2015). The PREP pipeline: Standardized preprocessing
for large-scale EEG analysis. Frontiers in Neuroinformatics, 9. https://doi.org/10.3389/fninf.2015.00016
de Cheveigné, A. (2020). ZapLine: A simple and effective method to remove power line artifacts. NeuroImage,
207, 116356. https://doi.org/10.1016/j.neuroimage.2019.116356
Klug, M., & Kloosterman, N. A. (2022). Zapline-plus: A Zapline extension for automatic and adaptive removal of frequency-
specific noise artifacts in M/EEG. Human Brain Mapping, 43(9), 2743–2758. https://doi.org/10.1002/hbm.25832
Luck, S. J. (2014). An Introduction to the Event-Related Potential Technique, Second Edition. MIT Press.
Mitra, P. P., & Pesaran, B. (1999). Analysis of Dynamic Brain Imaging Data. Biophysical Journal, 76(2), 691–708.
https://doi.org/10.1016/S0006-3495(99)77236-X
This page titled 14: Appendix 3: Example Processing Pipeline is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
14.6 https://socialsci.libretexts.org/@go/page/137523
