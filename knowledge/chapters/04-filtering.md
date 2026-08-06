# 4: Filtering the EEG and ERPs

> Source: *Applied Event-Related Potential Data Analysis* (Steven J. Luck), `Full.pdf`, PDF pages 98-129. Text is a mechanical page-by-page extraction, not a summary. Consult the PDF for figures and layout.

<!-- source_pdf=Full.pdf pdf_page=98 source_page_label="1" source_url="" -->

## PDF page 98

- Source page label: 1
- LibreTexts source: not printed on page

CHAPTER OVERVIEW
4: Filtering the EEG and ERPs
 Learning Objectives
In this chapter, you will learn to:
Compare the frequency content of an ERP waveform with the frequency response function of a filter to predict how well
the filter will attenuate the noise in the data
Determine the impulse response function of a filter and conceptualize filtering as a process that replaces each point in the
unfiltered waveform with a scaled copy of this function
Think of an ERP waveform as a series of impulses, one at each time point
Predict how a filter will distort an ERP waveform on the basis of the filter’s impulse response function
Select filter parameters that provide the best balance between noise reduction and distortion of the waveform
Create artificial waveforms and filter them to see how a filter might be distorting your data
You must use filters in ERP experiments. At a minimum, your amplifier includes an antialiasing filter that must be used prior to
digitizing the EEG. In almost all ERP experiments, additional filtering is important for reducing sources of noise that would
otherwise create large measurement error and reduce your statistical power. However, when filters are misused, they can
dramatically distort your data, leading to incorrect conclusions. As a result, it’s vitally important that you understand how filters
work and the conditions under which they can produce significant distortion of your ERP waveforms.
For most ERP researchers, there is no topic more boring than filtering. At the core of filtering is a mathematical operation called
convolution. Even the word “convolution” sounds complicated and boring!
However, you can get a reasonable understanding of filtering by seeing how convolution works visually, without ever seeing an
equation. This chapter takes you through a set of exercises that will show you how convolutions are used for filtering without any
equations. If you want a more detailed description of filtering, you should read Chapter 7 in Luck (2014). If you want to understand
the math, you can read Chapter 12 in Luck (2014), which is available for free online.
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
This page titled 4: Filtering the EEG and ERPs is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
1

<!-- source_pdf=Full.pdf pdf_page=99 source_page_label="4.1.1" source_url="https://socialsci.libretexts.org/@go/page/87947" -->

## PDF page 99

- Source page label: 4.1.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87947

4.1: Data for this Chapter
The data we’ll be using for the exercises in this chapter can be found in the Chapter_4 folder in the master folder:
https://doi.org/10.18115/D50056.
All of the exercises in this chapter involve artificial data rather than real EEG or ERP signals. This is because we don’t know the
true waveform with real data. With real data, the waveform consists of the sum of an unknown ERP waveform and unknown noise,
so when you apply a filter, you don’t know what the result should look like if the filter is working properly. With artificial data, we
can create a true waveform and add known noise to it. We can then see how well we can recover the true waveform by filtering the
data. In other words, artificial waveforms give us ground truth.
Once you understand how filters work, they’re pretty easy to implement using ERPLAB. You’ve already seen how to filter both
EEG and ERP data in the previous chapters, so this chapter will focus on helping you understand how filters work rather than
applying them to real data. All of the exercises use ERPsets rather than EEG datasets, but the general principles are the same for
EEG and averaged ERPs.
This page titled 4.1: Data for this Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck
directly on the LibreTexts platform.
4.1.1 https://socialsci.libretexts.org/@go/page/87947

<!-- source_pdf=Full.pdf pdf_page=100 source_page_label="4.2.1" source_url="https://socialsci.libretexts.org/@go/page/87946" -->

## PDF page 100

- Source page label: 4.2.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87946

4.2: Classes of Filters
There are four main classes of filters used in EEG/ERP research. They’re typically named in terms of the frequencies that they
pass, not the frequencies that are filtered out (much as an air filter passes air and filters out dust).
A low-pass filter passes low frequencies and filters out high frequencies (e.g., muscle activity).
A high-pass filter passes high frequencies and filters out low frequencies (e.g., gradual drifts resulting from skin potentials).
A bandpass filter passes an intermediate band of frequencies and filters out the lower and higher frequencies. A bandpass filter
is the same as filtering twice, once with a low-pass filter and once with a high-pass filter.
A notch filter passes all frequencies except for a narrow band (e.g., 60 Hz). A notch filter is typically used during an EEG
recording when AC electrical devices produce so much contamination of the EEG that it’s hard to see the signal.
I don’t ordinarily recommend applying notch filters (unless they are necessary during the recording process); it’s usually better to
use a low-pass filter that attenuates all the high frequencies. However, if you don’t want to use a low-pass filter with a cutoff of 20
or 30 Hz (e.g., because you are interested in relatively high-frequency activity), a very sophisticated line noise filtering approach
(Mitra & Pesaran, 1999) is available in EEGLAB as the cleanline plugin (see Bigdely-Shamlo et al., 2015 for important details
about implementing this tool). Another tool called Zapline is can also be used for this purpose (de Cheveigné, 2020; Klug &
Kloosterman, 2022), but it is newer and hasn't yet accumulated a strong track record.
This page titled 4.2: Classes of Filters is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck directly
on the LibreTexts platform.
4.2.1 https://socialsci.libretexts.org/@go/page/87946

<!-- source_pdf=Full.pdf pdf_page=101 source_page_label="4.3.1" source_url="https://socialsci.libretexts.org/@go/page/87948" -->

## PDF page 101

- Source page label: 4.3.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87948

4.3: Exercise- Assessing the Frequency Content of the Noise
We’re going to start by thinking about filtering as a frequency-domain operation, in which we suppress some frequencies and pass
others. If you don’t already know how filtering works in the frequency domain, I recommend that you read the first 10 pages in
Chapter 7 of Luck (2014) before you go any further.
If EEGLAB is running, quit it and restart it so that everything is fresh. Set Chapter_4 to be Matlab’s current folder. Load the
ERPset file named waveforms.erp (EEGLAB > ERPLAB > Load existing ERPset) and plot the waveforms (EEGLAB >
ERPLAB > Plot ERP > Plot ERP waveforms). It should look something like Screenshot 4.1.
Screenshot 4.1
You can see that we have three channels. I created the waveforms in Excel. The first channel is an artificial waveform that I created
by summing together three simulated ERP components, each of which was one cycle of a cosine function. The second channel is
the sum of the first channel and a 60 Hz sine wave (like the line noise that is often picked up from electrical devices in the
recording environment). The third channel is the sum of the first channel and some random noise (similar to the noise that is
produced by tonic muscle activity and picked up by our EEG electrodes).
 Line Noise
AC electrical lines run at 60 Hz in North America and some other parts of the world. Other regions use 50 Hz. We often call
this the line frequency to be agnostic about whether it is 50 or 60 Hz. The noise produced by this signal is called line noise.
Before we filter the data, let’s perform a Fourier transform on these waveforms so that we can see their frequency content. To do
this for the original waveform, select ERPLAB > Filter & Frequency Tools > Plot amplitude spectrum for ERP data. In the
window that pops up, specify channel 1 and bin 1. For the Frequency range to plot, set F1 to 0 and F2 to 100. You should see
something like Screenshot 4.2.A. The X axis is the frequency, and the Y axis is the amplitude at this frequency. This plot tells us
that we could reconstruct the original time-domain waveform by summing together a set of sinusoids with the set of amplitudes
shown at each frequency in the plot. We’d also need to know the phase at each frequency to reconstruct the original waveform, but
phase information isn’t usually shown with ERP data. You can get a quick introduction to the Fourier transform in Chapter 6 of my
online Introduction to ERPs course (or just watch this YouTube video). You can find a more detailed treatment in Chapters 7 and 12
of Luck (2014).
Screenshot 4.2
As you can see from the plot, the original ERP waveform mostly consists of relatively low frequencies. This is fairly typical of the
waveforms you would see in most perceptual, cognitive, and affective experiments. In low-level sensory experiments, you might
4.3.1 https://socialsci.libretexts.org/@go/page/87948

<!-- source_pdf=Full.pdf pdf_page=102 source_page_label="4.3.2" source_url="https://socialsci.libretexts.org/@go/page/87948" -->

## PDF page 102

- Source page label: 4.3.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87948

see more high-frequency activity.
Now repeat the process with Channel 2, which should produce something like Screenshot 4.2.B. It’s the same as the amplitude
spectrum for the original waveform, except that there is also activity at 60 Hz. This is because I created Channel 2 by summing
together the original waveform and a 60-Hz waveform. Now do the same thing for Channel 3. As shown in Screenshot 4.2.C, you
can see some activity at all frequencies. Also, the low-frequency activity is slightly different from the original waveform, because
the noise extends down to these frequencies. This broad band of frequencies occurred because I added white noise to the original
waveform, and white noise consists of equal amount of all frequencies (just as white light consists of approximately equal amounts
of all wavelengths in the visible spectrum).
When you’re first starting out in ERP research, you should plot Fourier transforms like these prior to filtering so that you have a
good idea of the frequency content of the noise in your data. This can help you figure out where the noise is coming from (because
different sources of noise have different frequency content). By knowing where the noise is coming from, you may be able to
eliminate it in future recordings. It’s better to reduce the noise before it contaminates your data rather than relying on filters and
other signal processing techniques. For reasons described in Luck (2014), I call this Hansen’s Axiom: “There is no substitute for
clean data.” As we will see later in this chapter, filters reduce the temporal precision of your data. And isn’t temporal precision one
of the most important features of the ERP technique?
This page titled 4.3: Exercise- Assessing the Frequency Content of the Noise is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
4.3.2 https://socialsci.libretexts.org/@go/page/87948

<!-- source_pdf=Full.pdf pdf_page=103 source_page_label="4.4.1" source_url="https://socialsci.libretexts.org/@go/page/87949" -->

## PDF page 103

- Source page label: 4.4.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87949

4.4: Exercise- Filtering the Artificial Waveforms
Now let’s apply a simple filter to the artificial data from the previous exercise. Load waveforms.erp if it isn’t already loaded, and
select ERPLAB > Filter & Frequency Tools > Filters for ERP data. Set the parameters as shown in Screenshot 4.3. Most
importantly, High-Pass should be unselected and Low-Pass should be selected with a cutoff at 30 Hz. For the big white plotting
window, set the X limits to 0 100. Make sure that the function shown in this window matches what is shown in the screenshot.
The function shown in the plotting window is called the frequency response function of the filter. It tells you the gain that will be
applied to each frequency. The gain is just a multiplicative value: A value of 1 means that the amplitude of that frequency will be
multiplied by 1 (i.e., unchanged). A value of 0.75 means that the frequency will be multiplied by 0.75, which means that it will be
attenuated by 25%. The half-amplitude cutoff of 30 Hz that we specified means that the gain of the filter is 0.5 at 30 Hz; this is the
point at which the gain is reduced by half (which is why it’s called the half-amplitude frequency).
The filter we’ve specified has a fairly gentle roll-off of 12 dB/octave. As a result, even though it’s nominally a 30 Hz filter, the gain
is still well above zero at 60 Hz, and there is some significant attenuation as low as 10 Hz. Change the roll-off to 48 dB/octave, and
you’ll see a frequency response function that appears to be better. The gain is now near 1 for everything below about 20 Hz, and
it’s near zero for everything above about 45 Hz. However, as we’ll see later in this chapter, this sharper frequency response
function means that the filter produces more distortion in the time domain.
Screenshot 4.3
Set the roll-off back to 12 dB/octave, click APPLY, and then name the new ERPset waveforms_30Hz_12dB. Now plot the filtered
waveforms. You’ll see that the 60 Hz oscillation is now mostly (but not completely) eliminated from Channel 2. The fact that it’s
4.4.1 https://socialsci.libretexts.org/@go/page/87949

<!-- source_pdf=Full.pdf pdf_page=104 source_page_label="4.4.2" source_url="https://socialsci.libretexts.org/@go/page/87949" -->

## PDF page 104

- Source page label: 4.4.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87949

not completely eliminated makes sense given that the gain at 60 Hz for this filter is around .1 (as shown in the frequency response
function), so about 10% of the 60 Hz noise remains after filtering. Channel 3 is now a little smoother, but it still has quite a bit of
noise. This makes sense given the amplitude spectrum that we looked at in the previous exercise (Screenshot 4.2.C), in which there
was substantial noise at frequencies below 30 Hz.
Now let’s try a more severe filter. Make the original unfiltered ERPset active (by selecting it in the ERPsets menu) and filter it just
as before, except set the low-pass cutoff to 10 Hz and set the roll-off to 48 dB/octave. Click APPLY and then name the new ERPset
waveforms_10Hz_48dB. If you plot the filtered waveforms, you’ll see that the 60 Hz line noise is almost completely gone from
Channel 2 and that the noise in Channel 3 has been significantly reduced (but with some lower-frequency fluctuations in amplitude
still visible).
To precisely compare two waveforms, it really helps to overlay them on the same plot. Unfortunately, ERPLAB’s Plot ERP
waveforms tool is designed to overlay different bins from a single ERPset and can’t overlay waveforms from different ERPsets.
However, there is a trick for solving this problem: We can append multiple ERPsets together into a single ERPset, with different
bins for the data from each original ERPset. Let’s append the ERPsets from the original data, the data filtered at 30 Hz, and the data
filtered at 10 Hz.
Select EEGLAB > ERPLAB > ERP Operations > Append ERPsets. In the window that pops up, select From ERPsets Menu
and put 1 2 3 into the corresponding text box to indicate that you want to append the first three ERPsets. (This assumes that you
just have the three relevant ERPsets loaded in the ERPsets menu; change the numbers as needed if you have other ERPsets loaded).
Check the Use erpnames box so that it names each bin in the appended file with the names of the ERPsets that are being appended
together. See Screenshot 4.4 (you’ll need to select the Include prefixes button before your window will look like the screenshot).
Screenshot 4.4
Click RUN and then name the new ERPset appended_waveforms. Now plot the new ERPset, making sure that all three bins are
being plotted. You’ll see that the original waveforms are plotted as Bin 1, the waveforms filtered at 30 Hz are plotted as Bin 2, and
the waveforms filtered at 10 Hz are plotted as Bin 3. These waveforms are highly overlapping, so you’ll need to zoom in to see
how they differ. To do this, single-click on any of the waveforms or the channel label for Channel 2 (waveform+60Hz) and a new
window will pop up that shows just this channel. Matlab is a little fussy about this feature, so you may need to click a few times to
4.4.2 https://socialsci.libretexts.org/@go/page/87949

<!-- source_pdf=Full.pdf pdf_page=105 source_page_label="4.4.3" source_url="https://socialsci.libretexts.org/@go/page/87949" -->

## PDF page 105

- Source page label: 4.4.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87949

get the click to register (but don’t double-click—you’ll end up with two identical windows). You should see something like
Screenshot 4.5.
Screenshot 4.5
You’ll see that the three waveforms are pretty similar except that the 60-Hz oscillations are clearly present in the original
waveform, mostly but not completely attenuated by the 30-Hz filter, and completely eliminated by the 10-Hz filter. If you look
closely, you’ll also see that the first two peaks in the waveform (analogous to the P1 and N1 waves) are reduced in amplitude by
the 10-Hz filter. This makes sense, because these peaks contain substantial power near 10 Hz, which is now being attenuated.
It’s easier to see how the filter is impacting the ERP waveform by looking at the original waveform, without any noise. Go back to
the plot with all three channels and click on Channel 1 (waveform) to zoom in. You should see something like Screenshot 4.6. The
first two peaks are slightly attenuated by the 30-Hz filter and more clearly attenuated by the 10-Hz filter. You can also see that the
10-Hz filter produces a little overshoot in the third peak (which is like a P2 wave) and makes the first peak onset earlier.
4.4.3 https://socialsci.libretexts.org/@go/page/87949

<!-- source_pdf=Full.pdf pdf_page=106 source_page_label="4.4.4" source_url="https://socialsci.libretexts.org/@go/page/87949" -->

## PDF page 106

- Source page label: 4.4.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87949

Screenshot 4.6
The 10-Hz filter also produces a small artificial negative peak just after time zero and before the first positive peak. This is not
because the filter is at 10 Hz; it’s because we used a very steep roll-off (48 dB/octave). You can verify this for yourself by going
back to the original unfiltered data and filtering it with a 10 Hz cutoff but a slope of 12 dB/octave. You’ll see that the artificial
negative peak is no longer present.
Now you can see why a steep frequency response function—which seems ideal when you’re focused on frequency information—is
not usually a good idea for ERP research. A steep roll-off can really distort the waveform, producing artificial peaks. And this can
lead to wildly incorrect conclusions. For example, Darren Tanner, Kara Morgan-Short, and I wrote a paper several years ago
(Tanner et al., 2015) showing that inappropriate filtering can make a P600 effect (which is usually a result of a syntactic violation
in a language experiment) look like an N400 (which is usually a result of a semantic anomaly). If you learn only one thing from
this chapter, I hope it’s that you should use only very mild filters unless you really know what you’re doing (e.g., you fully
understand all the equations in Chapter 12 of Luck, 2014). I provide some specific recommendations near the end of the chapter
that will allow you to avoid drawing bogus conclusions as a result of inappropriate filtering.
This page titled 4.4: Exercise- Filtering the Artificial Waveforms is shared under a CC BY 4.0 license and was authored, remixed, and/or curated
by Steven J Luck directly on the LibreTexts platform.
4.4.4 https://socialsci.libretexts.org/@go/page/87949

<!-- source_pdf=Full.pdf pdf_page=107 source_page_label="4.5.1" source_url="https://socialsci.libretexts.org/@go/page/87950" -->

## PDF page 107

- Source page label: 4.5.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87950

4.5: Exercise- The Impulse Response Function
Most discussions of filters focus on their frequency response functions, which indicate the effects of the filter in the frequency
domain. But do you actually care about the frequency content of your ERP waveforms? Probably not. If you’re interested in
conventional ERP waveforms (as opposed to time-frequency analyses), then you probably want to know how filters change your
data in the time domain, not in the frequency domain.
Filters can be implemented either in the frequency domain (using the Fourier transform) or in the time domain (using
convolutions). These two approaches yield exactly the same results, but I find that the time domain implementation makes it easier
to understand exactly how a filter changes an ERP waveform. So, we’ll mainly focus on the time domain for the remainder of this
chapter. We’ll start with an exercise designed to help you understand time-domain filtering visually, without any math. There are
many types of filters, and I’m going to focus on a common class called finite impulse response filters, even though this ends up
being a slight oversimplification for the filters implemented in ERPLAB.
The key to understanding filtering in the time domain is to understand something called the impulse response function. A filter’s
impulse response function is simply the output of the filter when the input is an impulse of amplitude 1 at time zero. (An impulse is
a waveform that is zero everywhere except for a nonzero value at a single time point). To see what I mean, quit and restart
EEGLAB, load the ERPset file named impulse0.erp, and plot the ERP waveform. When you plot this example (and the remaining
examples in this chapter), make sure you set Baseline Correction to None in the GUI for plotting ERP waveforms (see the box
below if you want to know why this is necessary).
 Baseline Correction
The waveform in impulse0.erp has a value of 1 at time zero and a value of 0 everywhere else. The value of 1 at time zero
messes up the baseline when you try to plot the waveform. This is because the baseline is defined as the average of the period
up to and including time zero. This average is slightly greater than zero, and baseline correction involves subtracting the
average from every point in the waveform. Thus, the whole waveform ends up being shifted slightly downward
Once you’ve turned off the baseline correction, you should see something like Screenshot 4.7.A when you plot the ERPset.
4.5.1 https://socialsci.libretexts.org/@go/page/87950

<!-- source_pdf=Full.pdf pdf_page=108 source_page_label="4.5.2" source_url="https://socialsci.libretexts.org/@go/page/87950" -->

## PDF page 108

- Source page label: 4.5.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87950

Screenshot 4.7
This ERPset contains a single channel in a single bin, and you can see the impulse (a voltage of 1 µV) at time zero. It looks like a
narrow triangle rather than a pure impulse because the waveform is sampled at 200 Hz (one sample every 5 ms), so there is a line
going from 0 µV at -5 ms to 1 µV at 0 ms and back down to 0 µV at 5 ms.
Now filter this waveform using a half-amplitude cutoff at 30 Hz and a slope of 12 dB/octave (following the same steps you used in
the previous exercise) and plot the result (which should look like Screenshot 4.7.B). You can see that the filtered waveform is now
a little wider and peaks at a lower amplitude (approximately 0.32 µV). This filtered waveform is the impulse response function of
the filter (i.e., the waveform produced by filtering an impulse of amplitude 1 at time zero).
You don’t actually need to filter an impulse to see the impulse response function in ERPLAB. You can also see it by going to the
window for the filtering routine and changing Display from Filter frequency response to Filter impulse response. As you can see
from Screenshot 4.8, the impulse response function is now plotted. Only the right half of the function is shown, but the left half is
just the mirror image. Note that it peaks at approximately 0.32 µV, just like the waveform you created by filtering an impulse
(Screenshot 4.7.B). The time scale is expanded, so it’s easier to see the details of the waveform.
4.5.2 https://socialsci.libretexts.org/@go/page/87950

<!-- source_pdf=Full.pdf pdf_page=109 source_page_label="4.5.3" source_url="https://socialsci.libretexts.org/@go/page/87950" -->

## PDF page 109

- Source page label: 4.5.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87950

Screenshot 4.8
At this point, you’re probably wondering, “Why should I care what the output of a filter looks like when the input is an impulse?
That impulse doesn’t look much like an ERP waveform.” You should care because the key to understanding filtering is that an ERP
waveform is a sequence of voltages, one at each time point, and you can think of this as a sequence of impulses of different
amplitudes. By knowing what the filter’s output looks like for an impulse at one time point (i.e., the impulse response function),
you can know what the filter’s output will look like for the whole waveform. This is demonstrated in the next exercise.
 A Slight Oversimplification
In this chapter, I discuss how finite impulse response (FIR) filters work, because they are quite easy to understand. However,
ERPLAB implements filtering using a specific type of infinite impulse response (IIR) filter called a Butterworth filter. As long
as you use a shallow roll-off (e.g., 12 dB/octave), ERPLAB’s filters provide a close approximation of a FIR filter. So,
everything I say in this chapter is approximately correct for ERPLAB’s filters as long as you use a shallow roll-off.
The key difference between FIR and IIR filters is that the output of an IIR filter feeds back into the filter’s input. This means
that the filter is nonlinear, with a response that could theoretically extend infinitely in time. The main advantage is that IIR
filters require fewer coefficients than FIR filters, making them run faster and potentially reducing edge effects (which will be
described later).
This page titled 4.5: Exercise- The Impulse Response Function is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by
Steven J Luck directly on the LibreTexts platform.
4.5.3 https://socialsci.libretexts.org/@go/page/87950

<!-- source_pdf=Full.pdf pdf_page=110 source_page_label="4.6.1" source_url="https://socialsci.libretexts.org/@go/page/87951" -->

## PDF page 110

- Source page label: 4.6.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87951

4.6: Exercise- Applying the Impulse Response Function to a Series of Impulses
For finite impulse response function filters, the output of the filter for a complex waveform is simply the sum of the filter’s impulse
response function for the voltages at each time point, scaled by the input amplitude at each time point. That’s a pretty complicated
sentence, so in this exercise we’ll look at a couple simple examples.
You can start by loading and plotting the ERPset file names impulse1.erp. This ERPset contains one bin, and each channel has a
different impulse in it. Channel 1 has an impulse of 1 µV at 100 ms. Channels 2, 3, and 4 have impulses at 200, 300, and 400 ms
with amplitudes of 0.5, 1, and 0.5 µV, respectively. Channel 5 has all four of the impulses in it (see Screenshot 4.9.A).
4.6.1 https://socialsci.libretexts.org/@go/page/87951

<!-- source_pdf=Full.pdf pdf_page=111 source_page_label="4.6.2" source_url="https://socialsci.libretexts.org/@go/page/87951" -->

## PDF page 111

- Source page label: 4.6.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87951

Screenshot 4.9
Filter this ERPset using a half-amplitude cutoff at 30 Hz and a slope of 12 dB/octave (following the same steps you used in the
previous exercises) and plot the result (which should look like Screenshot 4.9.B). Each impulse has been replaced by the impulse
response function of the filter, shifted so that it is centered at the latency of the impulse, and scaled (multiplied) by the size of the
impulse. Importantly, filtering the waveform with four impulses (Channel 5) gives you a waveform that is equivalent to the sum of
the four filtered waveforms for the individual impulses (Channels 1-4). This shows you what I meant when I said that “the output
of the filter for a complex waveform is simply the sum of the filter’s impulse response function for the voltages at each time point,
scaled by the input amplitude at each time point.” That is, the output of the filter for the waveform with four impulses (Channel 5)
4.6.2 https://socialsci.libretexts.org/@go/page/87951

<!-- source_pdf=Full.pdf pdf_page=112 source_page_label="4.6.3" source_url="https://socialsci.libretexts.org/@go/page/87951" -->

## PDF page 112

- Source page label: 4.6.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87951

is equivalent to replacing each individual impulse with a copy of the impulse response function that has been shifted to be centered
on a given impulse and scaled by the amplitude of that impulse.
To make this even clearer, we’re going to take the four impulses and make them consecutive sample points (just as an ERP
waveform typically consists of a sequence of consecutive nonzero voltage values). Load the ERPset named impulse2.erp and plot
it. You’ll see that now our four impulses are at 100, 105, 110, and 115 ms, which are consecutive because we have a sampling rate
of 200 Hz and therefore a voltage value every 5 ms. Filter this ERPset using a half-amplitude cutoff at 30 Hz and a slope of 12
dB/octave (just as before) and plot the result. Just as in the previous example, filtering the set of four consecutive impulses is
equivalent to filtering each impulse separately and then summing them together. In other words, the filtered waveform is equivalent
to replacing each impulse in the unfiltered waveform with a copy of the impulse response function, centered on each impulse and
scaled by the height of each impulse.
In this exercise, we used impulses to create 4 time points in an ERP waveform. Figure 4.1 extends this idea to a more realistic ERP
waveform. Panel A is the same artificial waveform shown at the beginning of the chapter in Screenshot 4.1, but blown up. We have
a voltage value every 5 ms, and these voltage values are connected by lines to create a waveform. Panel B is the same set of voltage
values, but with the voltage at each time point shown as an impulse. This is conceptually identical to the set of four impulses shown
in Screenshot 4.9.A, except now we have an impulse at each time point. To filter this waveform, we just replace each of these
impulses with a copy of the impulse response function, centered at each impulse and scaled (multiplied) by the amplitude of the
impulse. We then sum together these scaled copies of the impulse response function to obtain our filtered ERP waveform.
The process of replacing each point in one waveform with a scaled copy of another waveform is called convolving the two
waveforms. So, filtering an ERP waveform is achieved by convolving the waveform with the impulse response function. It turns
out that convolution is not as complicated (or convoluted) as it sounds!
Figure 4.1. Two ways of drawing the same ERP waveform. The waveform consists of a sequence of discrete voltage values, one at
each sample point (every 5 ms in this example). We typically connect these points with lines to make it look like a continuous
waveform (A). However, we can also think of each sample point as an impulse going from zero to the voltage value at that point
(B). We can then think of filtering as replacing each of these impulses with a copy of the impulse response function, scaled
(multiplied) by the amplitude of the impulse.
I hope you can now see that filtering in the time domain is conceptually very simple as long as you know the impulse response
function of the filter. That’s why we designed the filtering tool in ERPLAB to show you this function. Many EEG/ERP analysis
systems don’t show you the impulse response function, but you can always figure it out by making a waveform that consists of a
single impulse (like the one shown in Screenshot 4.7.A) and passing it through the filter.
By knowing the impulse response function, you can make a pretty good guess about how the filter might distort your data. For
example, do you remember the artificial negative peak produced by the filter with the 10 Hz cutoff and 48 dB/octave roll-off
(Screenshot 4.6)? That artificial peak makes perfect sense once you see the impulse response function of the filter. To see the
impulse response function for this filter, load the impulse1.erp ERPset (or make it the active ERPset if it’s already loaded) and
4.6.3 https://socialsci.libretexts.org/@go/page/87951

<!-- source_pdf=Full.pdf pdf_page=113 source_page_label="4.6.4" source_url="https://socialsci.libretexts.org/@go/page/87951" -->

## PDF page 113

- Source page label: 4.6.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/87951

filter it using a 10 Hz half-amplitude cutoff and a roll-off of 48 dB/octave. If you plot the filtered data, you’ll see something like
Screenshot 4.10.
Screenshot 4.10
Channel 1 shows you what the impulse response function looks like (but centered at 100 ms rather than 0 ms because the impulse
was at 100 ms). It has a negative dip on each side of the peak. And when we filter the set of four impulses in Channel 5, we can see
this dip just before the first positive peak. Now imagine what happens when you apply this filter to the more realistic waveform
shown in Figure 4.1.A. This would involve replacing each point in the waveform with a scaled copy of the impulse response
function. When we replace the positive impulses that start around 50 ms with this function, the negative part of the impulse
response function generates the negative dip prior to 50 ms.
This sort of distortion is easy to understand when you think about filtering in the time domain using the impulse response function.
However, the distortion is not at all obvious when you think about filtering using the frequency response function. That’s why I
prefer to think about filtering in the time domain. However, it’s still useful to know the frequency response function, especially if
you know something about the frequency content of the noise in your data. This is why we designed the ERPLAB filtering tool to
provide you with both functions. Also, the frequency response function and impulse response function are very closely related: The
frequency response function is simply the Fourier transform of the impulse response function, and the impulse response function is
simply the inverse Fourier transform of the frequency response function.
This page titled 4.6: Exercise- Applying the Impulse Response Function to a Series of Impulses is shared under a CC BY 4.0 license and was
authored, remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
4.6.4 https://socialsci.libretexts.org/@go/page/87951

<!-- source_pdf=Full.pdf pdf_page=114 source_page_label="4.7.1" source_url="https://socialsci.libretexts.org/@go/page/137552" -->

## PDF page 114

- Source page label: 4.7.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137552

4.7: Background- Filtering with a Running Average
I hope it’s now clear that filtering works by replacing each point in the waveform with a scaled copy of the impulse response
function. However, it’s probably not obvious why this ends up filtering out the high frequencies. There’s a slightly different—but
mathematically equivalent—way of thinking about filtering that makes it more obvious.
Let’s start by forgetting everything you know about EEG and filtering, and instead think about stock market prices. Figure 4.2.A
shows the daily values of the Standard & Poor 500 Stock Index over a 3-month period. There are lots of day-to-day variations that
are largely random and don’t mean much for the overall economy. What would be an easy way to minimize these day-to-day
fluctuations so that you could better visualize the overall trend?
Figure 4.2. A) Standard & Poor 500 Stock Index daily values between January 4 and March 31 of 2016. B) Values after applying a
3-point running average. C) Values after applying a 7-point running average.
A common approach is to take a running average. Figure 4.2.B shows a 3-point running average of the values in Figure 4.2.A. Each
value for a given day in the running average is just the average of the values from the day before, that day, and the day after. For
example, the running average value on February 2 is the average of the values on February 1, 2, and 3. You can see that the running
average is smoother than the original data.
4.7.1 https://socialsci.libretexts.org/@go/page/137552

<!-- source_pdf=Full.pdf pdf_page=115 source_page_label="4.7.2" source_url="https://socialsci.libretexts.org/@go/page/137552" -->

## PDF page 115

- Source page label: 4.7.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137552

We can make the data even smoother with a 7-day running average (Figure 4.2.C). Now, the running average for a given day is the
average of the value on that day, the three days before, and the three days after. The more points we include in our running average,
the more we attenuate rapid day-to-day changes and see the slower trends in the data. In other words, increasing the number of
points in the running average increases the filtering of high frequencies in the data. So, taking a running average is a simple form of
low-pass filtering, and we can control the cutoff frequency by changing the number of points being averaged together. We can
apply this same algorithm to filter out high frequencies in the EEG or in ERPs (see Chapter 7 in Luck, 2014 for additional details).
 Edge Artifacts
The running average approach to filtering exposes a problem that we always face in filtering, no matter what algorithm we use.
The S&P 500 index values shown in Figure 4.2.A start on January 4 and end on March 31. To compute the 3-point running
average value for January 4, we would need values for January 3, 4, and 5, but we don’t have the value for January 3.
Similarly, we can’t calculate the running average value for March 31 because we don’t have the value for April 1. Things are
even worse for the 7-point running average because now we need 3 days before and 3 days after a given day. As a result, we
can’t calculate the running average for January 4, 5, or 6 or for March 29, 30, or 31 with the data that are available to us. You
can see that these points are missing from the running averages in Figure 4.2.
This problem is less obvious when we filter using impulse response functions or the Fourier transform, but the same problem is
present for all filtering algorithms. We solve this problem in ERPLAB using an extrapolation algorithm to estimate the values
for the points that are needed but unavailable. It works quite well in most cases, but it can lead to problems when too many
points must be extrapolated. The most common situation where that arises is when we use a high-pass filter to filter out low
frequencies from the continuous EEG, which requires a very large number of points before and after the current point. In this
situation, we sometimes see “edge artifacts” at the beginning and end of the EEG waveforms. To avoid these edge artifacts, I
recommend recording an extra ~10 seconds of data prior to the first stimulus at the beginning of each trial bock and another
~10 seconds after the last stimulus at the end of each trial block. That way, the edges of the waveforms are far from the period
of time you care about, and the edge artifacts occur during a time period that is outside the epochs that you will use for
averaging.
In addition, ERPLAB's filtering tool has an option that can help reduce edge artifacts. This option is labeled "Remove mean
value (DC offset) before filtering". It should ordinarily be used when you are filtering continuous EEG data. However, it
should not be used for baseline-corrected data (e.g., epoched EEG or averaged ERPs) because the baseline correction already
eliminates the DC offset (and typically works better than removing the mean value).
This page titled 4.7: Background- Filtering with a Running Average is shared under a CC BY 4.0 license and was authored, remixed, and/or
curated by Steven J Luck directly on the LibreTexts platform.
4.7.2 https://socialsci.libretexts.org/@go/page/137552

<!-- source_pdf=Full.pdf pdf_page=116 source_page_label="4.8.1" source_url="https://socialsci.libretexts.org/@go/page/137553" -->

## PDF page 116

- Source page label: 4.8.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137553

4.8: Background- Filtering with a Weighted Running Average
The advantage of the running average approach to filtering is that it’s really easy to see why it reduces high-frequency fluctuations:
Any little “uppies and downies” within the set of points being averaged together will cancel each other out. Imagine that we applied
a running average filter to raw EEG, using a running average width of 50 ms (e.g., 5 points on either side of the current point if we
have one point every 5 ms). If the EEG has a 20 Hz sine wave in it, there will be exactly one cycle of the sine wave in 50 ms, and
the positive and negative sides of the sine wave will cancel each other out.
The disadvantage of the running average filter is that it’s a bit crude. Imagine that we had a 101-point running average filter (the
number is always odd because we have the current point plus an equal number of points on either side). The filtered value at time
point t would be just as influenced by time point t-50 as by point t-1. Instead of giving all 101 points equal weight, it would make
more sense to give nearby points greater weight than more distant points. That’s actually quite easy to do.
This weighted running average approach to filtering is illustrated in Figure 4.3. We start by defining a weighting function, which
indicates how much weight each of the surrounding time points will have. For example, rather than having a 7-point running
average in which each of the 7 points has equal weight, the 7-point weighting function shown in Figure 4.3 gives the greatest
weight to the current point, and then the weights fall off for more distant points. The filtered value at time t is computed by taking
each of the 7 points (t-3 through t+3), multiplying the unfiltered value at each point by the corresponding value from the weighting
function, and the summing these weighted values.
Figure 4.3. Filtering with a weighting function. To calculate the filtered value at time t, you take each of the surround points (t-3
through t+3), multiply the unfiltered value at each point by the corresponding value from the weighting function, and sum them
together.
A standard 7-point running average could be computed in the same way. Our weighting function would have a value of 1/7 at each
of the 7 points. The filtered value at time t would then be computed by taking 1/7 times the voltage at each of the 7 points and then
summing these values together. That’s identical to taking the average of the 7 points.
I hope that you can still see how this more sophisticated version of the running average filter will tend to attenuate high
frequencies: Uppies and downies during the set of points being averaged together will tend to cancel each other out.
4.8.1 https://socialsci.libretexts.org/@go/page/137553

<!-- source_pdf=Full.pdf pdf_page=117 source_page_label="4.8.2" source_url="https://socialsci.libretexts.org/@go/page/137553" -->

## PDF page 117

- Source page label: 4.8.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137553

You may be wondering how this weighted running average approach is related to filtering with an impulse response function. The
answer is beautifully simple: The weighting function is simply the mirror image of the impulse response function. And if the
impulse response function is symmetrical (which is usually the case), the weighting function is exactly the same as the impulse
response function. Also, because the weighting function is just the mirror image of the impulse response function, you can compute
the frequency response function by applying the Fourier transform to the mirror image of the weighting function.
The only real difference between filtering with an impulse response function and filtering with a weighting function is conceptual:
the impulse response approach tells you how the unfiltered value at time t will influence the filtered values at the surrounding time
points (because the unfiltered value at time t is replaced by a scaled copy of the impulse response function), whereas the weighted
running average approach tells you how the filtered value at time t is influenced by the unfiltered values at the surround points
(because the filtered value at time t is the weighted sum of the surrounding time points).
Thinking about filtering in terms of the weighting function should help you understand an important consequence of filtering:
Filtering inevitably reduces temporal resolution (no matter how the filtering is implemented). The filtered value at a given time
point is influenced by the surrounding time points, so the voltage you see at 100 ms is now influenced by the voltages at 95 ms, 105
ms, etc. And the weighting function shows you exactly how much impact the preceding and subsequent time points will have on
the filtered value at a given time point. The wider the weighting function, the more you are filtering your data, and the more
temporal precision you have lost. This is a very clear example of the principle that increasing the precision in the frequency domain
(by limiting the set of frequencies that are in the filter output) decreases the precision in the time domain (by causing the filtered
value at a given time point to be influenced by a wider range of time points from the unfiltered data).
This page titled 4.8: Background- Filtering with a Weighted Running Average is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
4.8.2 https://socialsci.libretexts.org/@go/page/137553

<!-- source_pdf=Full.pdf pdf_page=118 source_page_label="4.9.1" source_url="https://socialsci.libretexts.org/@go/page/137554" -->

## PDF page 118

- Source page label: 4.9.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137554

4.9: Exercise- Distortion of Onset and Offset Times by Low-Pass Filters
Now let’s take a closer at how low-pass filters reduce temporal resolution. The general idea is that each point in the unfiltered
waveform gets replaced by a scaled copy of the impulse response function, so the filtered data get “spread out” by the width of the
impulse response function. Let’s look at an example.
Load the ERPset named peak1.erp and plot it. You’ll see that there are three identical channels, each with a single peak at 100 ms.
We’re going to leave Channel 1 unchanged and we’re going to filter Channels 2 and 3 with different filter cutoffs. To do this,
launch the filtering tool (EEGLAB > ERPLAB > Filter & Frequency Tools > Filters for ERP data) and set it to filter the data
with a low-pass cutoff at 30 Hz and a roll-off of 12 dB/octave. Then, in the lower left corner of the window, change Channel(s) to
filter to be 2 instead of having the All box checked. This will apply the filter only to Channel 2. Click APPLY and then specify
whatever ERPset name you’d like. Now launch the filtering tool again, and change the cutoff to 10 Hz (leaving the roll-off at 12
dB/octave). Change Channel(s) to filter to be 3 instead of 2, click APPLY, and use whatever ERPset name you’d like.
Plot the ERPs to see the effects of the filtering. Channel 1 has not been changed. Channel 2 has been filtered at 30 Hz, but it will
look only slightly different from Channel 1 because this is a pretty minimal filter. Channel 3 has been filtered at 10 Hz, and if you
look closely, you’ll see that the waveform in Channel 3 onsets significantly earlier and offsets significantly later than the original
waveform in Channel 1.
To make it easier to compare the waveforms, I overlaid them in Figure 4.4. You can see that the 30-Hz filter had almost no effect,
but the 10-Hz filter caused the waveform to “spread out,” making the onset earlier and the offset later. It also decreased the peak
amplitude (because the original waveform had significant power in the frequencies around 10 Hz that has now been eliminated).
Now let’s see how these effects can be explained by the impulse response function of the filter. Go back to the filtering tool, and
check the All box for Channel(s) to filter. Leave the cutoff frequency at 10 Hz and change the Display setting near the top from
Filter frequency response to Filter impulse response. Remember, only the right half of the impulse response function is shown;
the left half is the mirror image of the right half. You can see that the impulse response function extends for about 30 ms. This
means that any activity in the unfiltered waveform will be spread approximately 30 ms both leftward and rightward.
 A Frustrating Moment
I forgot to set Channel(s) to filter back to All the first time I ran through this exercise. The next time I filtered an ERP, it
seemed like the filtering wasn’t working because only one channel was being filtered. I tried restarting ERPLAB, and that
didn’t help. I tried restarting Matlab, and that didn’t help either. I was getting frustrated and was about to reset ERPLAB’s
working memory (which would have helped, because it would have reset all the filtering options to their defaults), but then I
noticed that the All box wasn’t checked. I checked it, and then everything started working as expected. This is just one of many
times that I ran into a problem while creating the exercises in this book and used the troubleshooting steps described in
Appendix 1. The moral of the story is that even the guy who oversaw the design of ERPLAB and has decades of experience
with analyzing ERPs runs into problems from time to time!
Now change the half-amplitude cutoff from 10 Hz to 30 Hz and look at the impulse response function. It now declines to near zero
within 10 ms. This means that the spreading produced by this filter will be less than ~10 ms. Note that the visual appearance of the
spreading will depend on the shape of the waveform. For example, the spreading in Figure 4.4 looks more than 3 times greater for
the 10 Hz filter than for the 30 Hz filter. However, you could see that this what is happening if you filtered an impulse. You could
also see the 10-ms spreading for the 30 Hz filter if you zoomed in sufficiently closely.
4.9.1 https://socialsci.libretexts.org/@go/page/137554

<!-- source_pdf=Full.pdf pdf_page=119 source_page_label="4.9.2" source_url="https://socialsci.libretexts.org/@go/page/137554" -->

## PDF page 119

- Source page label: 4.9.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137554

Figure 4.4. Artificial waveform without filtering, with a 30-Hz half-amplitude cutoff, and with a 10-Hz half-amplitude cutoff.
This page titled 4.9: Exercise- Distortion of Onset and Offset Times by Low-Pass Filters is shared under a CC BY 4.0 license and was authored,
remixed, and/or curated by Steven J Luck directly on the LibreTexts platform.
4.9.2 https://socialsci.libretexts.org/@go/page/137554

<!-- source_pdf=Full.pdf pdf_page=120 source_page_label="4.10.1" source_url="https://socialsci.libretexts.org/@go/page/137558" -->

## PDF page 120

- Source page label: 4.10.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137558

4.10: Exercise- High-Pass Filtering
Up to this point, we’ve focused on low-pass filters, but in this exercise we’ll see how high-pass filtering works. The only
fundamental difference is that the impulse response functions are different.
With typical parameters (e.g., a 0.1 Hz half-amplitude cutoff frequency), high-pass filtering requires a very long impulse response
function, so it doesn’t work very well with epoched EEG or ERP data (unless the epochs are many seconds long). Ordinarily, you’ll
apply high-pass filtering to continuous EEG (as in some of the exercises in earlier chapters). However, it’s a little easier to create
simulated waveforms and visualize them with ERPs, so we’ll apply high-pass filters to simulated ERP data in this exercise. As a
compromise, I created simulated waveforms with a longer-than-usual epoch (from -1000 to +1000 ms). But with real data, you’d
want even longer epochs (or, better yet, apply high-pass filters to the continuous EEG data).
To get started, quit and restart EEGLAB and then load the ERPset in the file named waveform+drift.erp. If you plot the ERPs,
you’ll see something like Screenshot 4.11A. Channel 1 is the same artificial waveform we’ve used before, but with a longer epoch.
Channel 2 is the same waveform, but with a linear drift superimposed on it. Channel 3 is an impulse that we can use to visualize the
impulse response functions of the filters we’ll be using.
Screenshot 4.11
We’re going to start by using a high-pass filter cutoff of 5 Hz, which means that we’re filtering out frequencies below 5 Hz. I’d
never recommend using this cutoff with real data (except for a few special cases, such as research on the auditory brainstem
response). However, this will make it easier to see what the impulse response function looks like and how it impacts the filtered
waveform.
Launch the filtering tool, and set the parameters as shown in Screenshot 4.12. In particular, turn off the low-pass filter, turn on the
high-pass filter, set the high-pass cutoff to 5 Hz, and set the roll-off to 12 dB/octave. And make sure that Channel(s) to filter is set
to All. If you look at the frequency response function shown in the upper left, you’ll see that the gain is near zero for the lowest
frequencies, reaches 0.5 at 5 Hz (because that’s the half-amplitude cutoff frequency) and then starts nearing the asymptote of 1.0 by
approximately 10 Hz.
4.10.1 https://socialsci.libretexts.org/@go/page/137558

<!-- source_pdf=Full.pdf pdf_page=121 source_page_label="4.10.2" source_url="https://socialsci.libretexts.org/@go/page/137558" -->

## PDF page 121

- Source page label: 4.10.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137558

Screenshot 4.12
Now look at the impulse response function by changing the Display setting from Filter frequency response to Filter impulse
response. It should look like Screenshot 4.13. It’s very different from the impulse response function of a low-pass filter. Low-pass
and high-pass filters have opposite effects (removing high versus low frequencies), so they have largely opposite impulse response
functions. Whereas the low-pass impulse response functions we’ve looked at had positive values near time zero, this high-pass
impulse response function is negative near time zero (but is near 1.0 right at time zero). The reasons for this are discussed in
Chapters 7 and 12 of Luck (2014). Here, you’ll just have to take my word for it.
Screenshot 4.13
4.10.2 https://socialsci.libretexts.org/@go/page/137558

<!-- source_pdf=Full.pdf pdf_page=122 source_page_label="4.10.3" source_url="https://socialsci.libretexts.org/@go/page/137558" -->

## PDF page 122

- Source page label: 4.10.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137558

Go ahead and click APPLY to run the filter, and then plot the filtered waveforms. You should see something like Screenshot 4.11B.
First look at the impulse (Channel 3), which now shows the impulse response function of the filter. You can see the negative values
surrounding time zero, but they’re pretty small. This is because the impulse response function for a high-pass filter must sum to
zero. If the impulse response extends for a long time period, the individual values must be very small.
Now look at the waveform+drift channel (Channel 2). The good news is that the filter has virtually eliminated the drift. The bad
news is that the filter has produced artifactual negative peaks at the beginning and end of the waveform. You can also see these
artifactual peaks in the channel without the drift (Channel 1). The filter has also reduced the amplitude and change the shape of the
ERP waveform, but that’s to be expected because much of the power in the waveform falls into the frequencies that are attenuated
by the filter (which you can confirm by making the unfiltered ERPset active and using EEGLAB > ERPLAB > Filter &
Frequency Tools > Plot amplitude spectrum for ERP data). These distortions are why I would never recommend using a filter
like this with real data (except for the auditory brainstem responses, which are largely confined to higher frequencies).
If you think about the impulse response function, you can understand why the filter produces artificial negative peaks at the
beginning and end of the waveform. The unfiltered waveform starts and ends with positive values. When we replace these values
with the impulse response function, the negative values to the left and right of the current point in the impulse response function
produce negative values before and after the positive peaks. Note that if the waveform contained negative peaks, the artifactual
peaks would be positive (because a negative voltage from the unfiltered waveform multiplied by a negative value in the impulse
response function creates a positive value).
Next we’re going to try a filter that’s not quite as extreme, but still has a higher cutoff frequency than I’d recommend, namely 1 Hz.
Make the original waveform+drift ERPset active again in the ERPsets menu, launch the filtering tool, and change the cutoff from
5 Hz to 1 Hz. Look at the impulse response function in the filtering tool. You can see a large positive value at time zero, but the
nearby values are just barely negative. The function extends for a longer period of time than the function for the 5 Hz filter, and
each individual point must be nearer to zero so that the points sum to zero.
Go ahead and click APPLY and then plot the filtered data. It should look like Screenshot 4.11C. The drift in Channel 2 is still
largely gone, but we haven’t attenuated the ERP waveform as much, so that’s an improvement. However, the artifactual negative
peaks at the beginning and end of the waveform are still present. That’s why I wouldn’t recommend using a 1 Hz cutoff.
Now let’s try the high-pass filter cutoff I ordinarily recommend for most perceptual, cognitive, and affective ERP studies, namely
0.1 Hz. Make the unfiltered ERPset active again, launch the filtering tool, and change the cutoff to 0.1 Hz. If you look at the
impulse response function in the filtering tool, you can’t really see much beyond the positive value at time zero. That means that
the filter will be very mild. Apply the filter and look at the waveforms. As shown in Screenshot 4.11D, the filter has only partially
reduced the drift in Channel 2. However, it has produced no noticeable distortion of the ERP waveform. That is, the filter hasn’t
attenuated the waveform, and it hasn’t produced any artifactual peaks.
This set of examples illustrates an important principle: You can fully attenuate the slow drifts in your data but distort your ERP
waveforms, or you can fail to fully attenuate the low-frequency noise and avoid distorting your ERP waveforms. You can’t both
fully attenuate the drifts and avoid distorting the waveform. This is because of the inverse relationship between the time and
frequency domains: The more you restrict the frequencies with extensive filtering, the more you distort the time course of the ERP
waveform.
Keep in mind that the slow drifts are noise deflections that mainly arise from the skin, and they’re positive-going on some trials and
negative-going on others. They add random noise to your data, decreasing your power to find statistically significant effects.
Obviously that’s not a good thing. However, it’s much worse to use a filter that induces artifactual effects that are statistically
significant but completely bogus, causing you to draw incorrect conclusions. This is why I usually recommend a high-pass cutoff of
0.1 Hz—it reduces the low-frequency noise reasonably well, but it doesn’t usually produce substantial artifacts.
In the first edition of my ERP textbook (Luck, 2005), I recommended using 0.01 Hz as the half-amplitude cutoff. Over the
following years, however, my collaborators and I systematically compared a variety of different cutoffs, and we typically found
that 0.1 Hz produced the best noise reduction without any substantial distortion of the waveforms (Kappenman & Luck, 2010;
Tanner et al., 2015). If you’re looking at very slow ERPs (like the contralateral delay activity), 0.01 or 0.05 might be better than
0.1, but in most cases I find that 0.1 Hz works best.
4.10.3 https://socialsci.libretexts.org/@go/page/137558

<!-- source_pdf=Full.pdf pdf_page=123 source_page_label="4.10.4" source_url="https://socialsci.libretexts.org/@go/page/137558" -->

## PDF page 123

- Source page label: 4.10.4
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137558

This page titled 4.10: Exercise- High-Pass Filtering is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
4.10.4 https://socialsci.libretexts.org/@go/page/137558

<!-- source_pdf=Full.pdf pdf_page=124 source_page_label="4.11.1" source_url="https://socialsci.libretexts.org/@go/page/137559" -->

## PDF page 124

- Source page label: 4.11.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137559

4.11: Practical Advice
This chapter has focused on helping you understand how filters actually work and how they can distort your data. I’d like to end
with some practical advice about when and how to filter your data. This advice is appropriate for perhaps 95% of perceptual,
cognitive, and affective ERP research. If you think your research falls into the other 5%, then you need to be very sure you fully
understand how filtering works so that you don’t end up either causing significant distortion of your data by overfiltering or failing
to remove enough noise by underfiltering.
Let’s start with the question of when to filter. As mentioned earlier, you should apply your high-pass filter to the continuous EEG to
avoid edge artifacts. To further minimize these artifacts, you should use the option labeled "Remove mean value (DC offset) before
filtering" when you are filtering continuous EEG data (but not when you are filtering epoched EEG or averaged ERPs).
You can apply your low-pass filter to the continuous EEG, the epoched EEG, or the averaged ERPs. For most researchers, it will be
simplest just to apply both the low- and high-pass filters to the continuous EEG. In my lab, we typically apply the low-pass filter
only to the averaged ERPs, but that’s mainly for philosophical reasons rather than practical reasons (as described in Luck, 2014).
Now let’s discuss filter parameters. My lab typically uses cutoffs of 0.1 and 30 Hz, with a roll-off of 12 dB/octave. That’s what I’d
recommend if you are recording very clean data, especially if you have highly cooperative participants (e.g., neurotypical young
adults). If you have a fair amount of high-frequency noise (e.g., 60-Hz line noise or spiky muscle activity), you can increase the
roll-off to 48 dB/octave for the low-pass filter and/or drop the cutoff from 30 to 20 Hz. You’ll get a little more distortion, but not
enough to matter for most studies. However, I don’t recommend a roll-off of 48 dB/octave for the high-pass filter. If you have a lot
of low-frequency noise, which is especially common when the participants move around a lot (e.g., infants or young children), you
can raise the high-pass cutoff to 0.2 or even 0.5 Hz and/or increase the roll-off to 24 dB/octave. However, these parameters can
cause noticeable distortion of the waveforms. If you mainly have line noise and don’t want to use a low-pass filter at 20-30 Hz, you
can use EEGLAB’s cleanline plugin (see Bigdely-Shamlo et al., 2015 for important details). If cleanline doesn't work well for you,
you can try the newer Zapline method (de Cheveigné, 2020; Klug & Kloosterman, 2022).
If you want to use a high-pass cutoff of greater than 0.1 Hz or a low-pass cutoff of less than 20 Hz, I strongly recommend that you
create artificial ERP waveforms that resemble your data and pass them through the filter (even if you’re filtering the continuous or
epoched EEG with your real data). You can then see exactly how the filter distorts your data. If the distortion you see with the
artificial data is small compared to the effects you’re seeing in your study, then you don't need to worry. The next section describes
how to create and import artificial waveforms.
When my lab measures the onset latency of an ERP component, we will often apply a 10 Hz low-pass filter (12 dB/octave). We
find that onset latency measures are highly sensitive to noise, and we get much better statistical power by filtering at 10 Hz. This
might seem problematic given that Figure 4.4 shows that a 10 Hz cutoff produces a substantial distortion of the onset latency.
However, when we quantify the onset latency of an ERP component, we don’t measure the time that the waveform first deviates
from zero. Instead, we measure the time at which the voltage reaches 50% of the peak voltage (see Chapter 9 in Luck, 2014, for a
justification of this approach). If you look closely at Figure 4.4, you’ll see that this 50% point is virtually identical for the filtered
and unfiltered waveforms. Also, we’re usually comparing the ERPs from two conditions that have both been filtered at 10 Hz, so
the effect of the filtering should be equivalent for both conditions. However, we sometimes want to examine the point at which a
difference wave first deviates from zero. In these cases, we do minimal filtering or we quantify the amount of latency shift
produced by the filter (see, e.g., Bae & Luck, 2018).
This page titled 4.11: Practical Advice is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J Luck directly
on the LibreTexts platform.
4.11.1 https://socialsci.libretexts.org/@go/page/137559

<!-- source_pdf=Full.pdf pdf_page=125 source_page_label="4.12.1" source_url="https://socialsci.libretexts.org/@go/page/137560" -->

## PDF page 125

- Source page label: 4.12.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137560

4.12: Exercise- Creating and Importing Artificial Waveforms
Over the years, I’ve found that applying filters to artificial waveforms has really helped me understand how filters work and
whether they might be significantly distorting my data. In fact, I first got interested in how filters work when I used an
inappropriate filter and discovered my error by filtering an artificial waveform (see text box below). As a result, I always encourage
other people to trying filtering artificial waveforms, especially if they’re not going to follow my standard advice about filtering
from 0.1 to 20 or 30 Hz. I even created some example artificial waveforms to go along with the filtering chapter in Luck (2014) and
made them available online on the publisher’s web site. Here, I’m going to explain how you can make artificial waveforms in
Excel and import them into ERPLAB.
 How I Avoided Embarrassment by Filtering an Artificial Waveform
When I was in grad school, I had the good fortune to spend quite a bit of time with Bob Galambos, who was the mentor of my
own mentor, Steve Hillyard. Bob had retired many years before, but he still came to lab meetings from time to time. He was an
amazing scientist—among other things, he and his buddy Donald Griffin were the people who first demonstrated that bats
navigate using echolocation (Griffin & Galambos, 1941). I learned a lot from having him around.
One day, Bob and I cooked up an idea for an experiment that involved recording both ERPs and the electroretinogram (ERG;
see the next text box). Bob volunteered to be the subject. Unfortunately, although he was a great scientist, he was not a very
good subject, and the data were very noisy.
That night, I processed the data, and the recordings were a mess. In an attempt to clean up the data, I applied a very strong
filter (something like 2-8 Hz, 48 dB/octave). Not only did it remove the noise, it revealed that the stimuli had triggered
oscillations in both the ERPs and the ERG. Oscillations were just becoming a hot topic, and I thought I had discovered
something new and important. I would surely become famous!
But then I noticed something: The recordings included square-wave calibration pulses, and the filtered calibration pulses
contained the same oscillations I was seeing in the ERPs and ERG. That made me realize that the oscillations were artifactually
induced by the filter and were not signals that were present in the data. I asked one of the senior grad students, Marty Woldorff,
about the oscillations, and he explained how very sharp filters can produce artifactual oscillations. He explained that a filter is
like a bell: You put a brief input into a bell (by striking the clapper), and the output of the bell is an oscillation.
That experience of seeing how a filter impacted an artificial signal (the calibration pulse) got me interested in learning more
about filters. And it saved me from the embarrassment I would have surely felt if I had tried to write a paper claiming that I had
discovered oscillations in the ERPs and ERG.
I created all of the artificial waveforms for this chapter in Excel. You can find a copy of the spreadsheet file, which is named
artificial_data.xlsx, in the Chapter_4 folder. If you don’t have Excel, you can import it into Google Sheets. The first tab has the
waveforms, with a separate column for each waveform. I created the ERP-like waveform shown in Screenshot 4.1 by summing
together three simulated ERP components, each of which is just one cycle of a cosine function. You can see the formulas in the
spreadsheet. You’ll also see columns for creating 60-Hz noise and white noise. There are also columns for impulses at different
times.
The other sheets are designed to pull out the waveforms for the separate ERPset files that I created for the exercises. These sheets
just copy the relevant values from the first sheet (sometimes with modifications). To create an ERPset from a given sheet, you save
the sheet as a text file and then import it into ERPLAB.
As an example, let’s create a text file for the waveforms sheet, which contains the waveforms shown in Screenshot 4.1. Go to this
sheet in Excel and select Excel > File > Save as. Then select Tab delimited Text (.txt) as the file format and save the file using
waveforms.txt as the filename. Note that with this file format, Excel saves only the current sheet as the text file.
The resulting text file is organized with the leftmost column containing the latency of each sample point and the other column(s)
containing the voltage values for the individual electrode sites. With this approach, you can only have one bin per text file.
Now let’s import the text file into ERPLAB as an ERPset. Quit and restart EEGLAB, and then select EEGLAB > ERPLAB >
Export and Import ERP > Import ERP from text (universal). This will bring up the window shown in Screenshot 4.14. The
4.12.1 https://socialsci.libretexts.org/@go/page/137560

<!-- source_pdf=Full.pdf pdf_page=126 source_page_label="4.12.2" source_url="https://socialsci.libretexts.org/@go/page/137560" -->

## PDF page 126

- Source page label: 4.12.2
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137560

import tool allows you to specify multiple text files, each which will be stored as a separate bin. However, we’re going to just
import one text file and create one bin. To do this, click the Add ERP file button and select the waveforms.txt file that you created
in the previous step. You’ll then see it in the list of text files to be imported, designated as Bin 1 (see Screenshot 4.14).
Screenshot 4.14
Now we need to provide the import tool with some information about the format of the text file. For the overall structure of the file,
click the points=rows & electrodes=columns option (which indicates that each line is a time point and each column is an
electrode). Check the electrode labels exist box, because the first line of the text file contains the labels for the electrodes. Check
the time values exist box, because the leftmost column contains the time values. If we didn’t have the time values in the text file,
we could instead indicate the sampling rate and time range, and the import tool would figure out the latency for each time point.
Once everything is set as shown in the screenshot, click OK. You’ll then see the standard dialog box for naming and saving the
new ERPset. You can name it waveforms. You don’t need to save it, because you already have the file with these waveforms in the
Chapter_4 folder (waveforms.erp). Finally, you should plot the waveforms and verify that they look like those in Screenshot 4.1.
That’s it! Now you can use Excel to create any kind of artificial waveform you like and then import it into ERPLAB. You can then
see how the waveform is changed by different filter settings. As I said before, you’ll definitely want to do this if you filter more
aggressively than my standard recommendation of 0.1 to 30 Hz.
 The Electroretinogram (ERG)
The ERG is an EEG-like signal generated by the retina. I have a soft spot in my heart for the ERG, because it’s how I got
started in electrophysiology. I took a year off in the middle of college and got a job working as a research assistant for Martha
Neuringer at the Oregon National Primate Research Center. I worked on a study of the effects of omega-3 fatty acid
deprivation on visual system development in infant rhesus monkeys.
4.12.2 https://socialsci.libretexts.org/@go/page/137560

<!-- source_pdf=Full.pdf pdf_page=127 source_page_label="4.12.3" source_url="https://socialsci.libretexts.org/@go/page/137560" -->

## PDF page 127

- Source page label: 4.12.3
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137560

Martha recorded the ERG as one of our outcome measures. She anaesthetized the monkeys and then put a special-purpose
electrode on the cornea to record the ERG signal. This signal was then amplified and recorded on a special tape recorder. We
would then drive to a different lab 10 miles away, where we used a gigantic computer to digitize the signals, average across
trials, and a quantify the amplitude of the ERG signal. This was very time-consuming, so I was tasked with writing software
for an Apple II—the first mainstream personal computer—that would allow us to directly record the ERG (onto floppy disks!)
and do the averaging and analysis. This started me down the road to ERP research.
Bob Galambos taught me a trick for more easily recording the ERG from humans using small EEG electrodes placed on the
lower eyelids rather than an electrode placed directly on the eye. The trick is to place one electrode under each eye and put an
opaque patch over one eye. When a visual stimulus is presented, you get ERG activity plus EEG activity from the electrode
under the unpatched eye, and you get nearly identical EEG activity from the electrode unpatched eye, but without the ERG
activity. If you use the electrode under the unpatched eye as the active site and the electrode under the patched eye as the
reference site, the EEG (which is nearly identical at both electrodes) is subtracted away, leaving just the ERG. This was one of
many things I learned from Bob.
This page titled 4.12: Exercise- Creating and Importing Artificial Waveforms is shared under a CC BY 4.0 license and was authored, remixed,
and/or curated by Steven J Luck directly on the LibreTexts platform.
4.12.3 https://socialsci.libretexts.org/@go/page/137560

<!-- source_pdf=Full.pdf pdf_page=128 source_page_label="4.13.1" source_url="https://socialsci.libretexts.org/@go/page/137561" -->

## PDF page 128

- Source page label: 4.13.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137561

4.13: Matlab Script for this Chapter
I haven’t provided a script for this chapter, because scripts in previous chapters have shown how to do filtering from a script.
Instead, I provided the Excel file for creating artificial waveforms (in the folder with the data for this chapter).
This page titled 4.13: Matlab Script for this Chapter is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
4.13.1 https://socialsci.libretexts.org/@go/page/137561

<!-- source_pdf=Full.pdf pdf_page=129 source_page_label="4.14.1" source_url="https://socialsci.libretexts.org/@go/page/137562" -->

## PDF page 129

- Source page label: 4.14.1
- LibreTexts source: https://socialsci.libretexts.org/@go/page/137562

4.14: Key Takeaways and References
Key Takeaways
You can filter EEG and ERPs in the frequency domain using the Fourier transform, or you can filter in the time domain using an
impulse response function or a weighting function. These three approaches are mathematically identical and produce exactly the
same result. However, we mainly care about the time domain in ERP research, so it’s helpful to think about filtering as a time-
domain operation.
The impulse response function of a filter is just the output of the filter when the input is an impulse of amplitude 1 at time zero.
You can think of an ERP waveform as a sequence of impulses, one at each time point. The output of a filter for a given input
waveform can be computed by replacing each impulse in the input waveform with a copy of the impulse response function that
has been scaled by the amplitude of the impulse and then summing them together.
You can also think of filtering as being implemented by a weighted running average. The weighting function is the mirror image
of the impulse response function. This conceptualization allows you to see how the filtered value at a given time point is related
to the values at the surrounding time points.
Precision in the time domain is inversely related to precision in the frequency domain. The more heavily you filter, the more
temporal distortion you will produce. The amount of temporal “smearing” produced by a filter is easily understood by the width
of the impulse response function or weighting function. Heavy filtering can introduce artifactual peaks in your waveform,
especially with high-pass filters or steep roll-offs, potentially causing you to draw completely bogus conclusions.
For most perceptual, cognitive, and affective ERP experiments, filtering from 0.1 to 30 Hz works very well. If you want to filter
more heavily, you should first apply the filter to artificial waveforms so that you can see what kind of distortion is produced by
the filter.
References
Bae, G. Y., & Luck, S. J. (2018). Dissociable decoding of working memory and spatial attention from EEG oscillations and
sustained potentials. The Journal of Neuroscience, 38, 409–422. https://doi.org/10.1523/JNEUROSCI.2860-17.2017
Bigdely-Shamlo, N., Mullen, T., Kothe, C., Su, K.-M., & Robbins, K. A. (2015). The PREP pipeline: Standardized preprocessing
for large-scale EEG analysis. Frontiers in Neuroinformatics, 9. https://doi.org/10.3389/fninf.2015.00016
de Cheveigné, A. (2020). ZapLine: A simple and effective method to remove power line artifacts. NeuroImage, 207, 116356.
https://doi.org/10.1016/j.neuroimage.2019.116356
Klug, M., & Kloosterman, N. A. (2022). Zapline-plus: A Zapline extension for automatic and adaptive removal of frequency-
specific noise artifacts in M/EEG. Human Brain Mapping, 43(9), 2743–2758. https://doi.org/10.1002/hbm.25832
Griffin, D. R., & Galambos, R. (1941). The sensory basis of obstacle avoidance by flying bats. Journal of Experimental Zoology,
86, 481–506. https://doi.org/10.1002/jez.1400860310
Kappenman, E. S., & Luck, S. J. (2010). The effects of electrode impedance on data quality and statistical significance in ERP
recordings. Psychophysiology, 47, 888–904. https://doi.org/10.1111/j.1469-8986.2010.01009.x
Luck, S. J. (2005). An Introduction to the Event-Related Potential Technique. MIT Press.
Luck, S. J. (2014). An Introduction to the Event-Related Potential Technique, Second Edition. MIT Press.
Mitra, P. P., & Pesaran, B. (1999). Analysis of Dynamic Brain Imaging Data. Biophysical Journal, 76(2), 691–708.
https://doi.org/10.1016/S0006-3495(99)77236-X
Tanner, D., Morgan-Short, K., & Luck, S. J. (2015). How inappropriate high-pass filters can produce artifactual effects and
incorrect conclusions in ERP studies of language and cognition. Psychophysiology, 52, 997–1009.
https://doi.org/10.1111/psyp.12437
This page titled 4.14: Key Takeaways and References is shared under a CC BY 4.0 license and was authored, remixed, and/or curated by Steven J
Luck directly on the LibreTexts platform.
4.14.1 https://socialsci.libretexts.org/@go/page/137562
