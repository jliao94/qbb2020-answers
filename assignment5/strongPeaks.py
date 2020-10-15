#!/usr/bin/env python3

peakFile = '/Users/cmdb/qbb2020-answers/assignment5/CTCF_ER4_peaks.narrowPeak'
top100peaks = '/Users/cmdb/qbb2020-answers/assignment5/CTCF_ER4_100peaks.narrowPeak'

topPeaks = [None]*100
pValues = [0]*100
entry_counter = 0
with open(peakFile, 'r') as f:
	for peak in f:
		bed_fields = peak.rstrip().split('\t')

		#according to macs documentation on macs narrowpeak output, the 8th field is the pValue in -log10
		pValue = float(bed_fields[7])

		#populate topPeaks list with 100 values if not full
		if entry_counter <100:
			topPeaks[entry_counter] = peak
			pValues[entry_counter] = pValue
			entry_counter +=1

		#evaluate if the mininum needs to be replaced
		else:
			minPVal, minIndex = min((minPVal, minIndex) for (minIndex, minPVal) in enumerate(pValues))
			#print(minPVal, minIndex)

			#replace the mininum significant peak if current peak if more significant
			if pValue > minPVal:
				topPeaks[minIndex] = peak
				pValues[minIndex] = pValue
				#print("I replaced " + str(minPVal) + " with " + str(pValue))
			else:
				continue

#write to outputFile
output_file = open(top100peaks, 'w')
for peak in topPeaks:
	output_file.write(peak)
output_file.close()









