#!/usr/bin/env bash

cd data/
gunzip hg19.chr1.fa.gz

#Align FASTQ data to the human genome with bowtie2
bowtie2-build hg19.chr1.fa hg19.chr1

bowtie2 -x hg19.chr1 -U factorx.chr1.fq.gz | samtools sort -o factorx.sort.bam

#create bedgraph
bedtools genomecov -ibam factorx.sort.bam -g hg19.chrom.size -bg > factorx.bg

bedGraphToBigWig factorx.bg hg19.chrom.size factorx.bw

file factorx.bg
file factorx.bw

#create a branch called gh-pages
git branch gh-pages
git push origin gh-pages
git add factorx.bw
git commit -m 'bigwig' factorx.bw
git push origin gh-pages

#go to uscs website> my data> custom tracks
#track type=bigWig 
#bigDataUrl="http://vivi0526.github.io/problem-set-4/factorx.bw"
#color=255,0,0 visiblity=full name='chip data' description='chip description'

#peak calling
macs2 bdgpeakcall -i factorx.bg -o peaks.bed

#get fasta sequence from peak calls
bedtools getfasta -fi hg19.chr1.fa -bed peaks.bed -fo sequence.fa

meme sequence.fa -nmotifs 1 -maxw 20 -minw 8 -maxsize 1000000 -dna

cd meme_out

meme-get-motif -id 1 < meme.txt > motif-1.txt

#copy and paste matrix(motif1 position-specific probability matrix) on tomtom website

#match #1: CTCF


