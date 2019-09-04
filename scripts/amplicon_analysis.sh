# predicted amplicon analysis

cd /Users/mann/github/mockcommunity/genomes
# get predicted amplicon sequences from reference genomes using primer sequences
tntblast -i primers.txt -d all_genomes.fa -l 300 -e 40 -x 75 > tntblast.results.txt
# how many sequences are generated?
grep ">" tntblast.results.txt | wc -l
# filter out predicted amplicons and clean up headers
grep ">" tntblast.results.txt -A 1 | sed 's/--//' | sed '/^$/d' > predicted_amplicons.fa
sed -i 's/ /_/g' predicted_amplicons.fa
# dereplicate sequences
vsearch --derep_fulllength predicted_amplicons.fa --output predicted_amplicons.uniq.fa
# blast against 16S rRNA reference database, discard any that fall below 90PID
blastn -evalue 1e-10 -max_target_seqs 1 -perc_identity 0.97 -db /Users/mann/refDB/ezbiocloud/ezbiocloud_qiime_full.db -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend sstart send evalue bitscore qlen" -query predicted_amplicons.uniq.fa -out blast.out

# try with rnammer
perl /Users/mann/rnammer1.2/rnammer -S bac -m lsu,ssu,tsu -gff - < all_genomes.fa > rnammer_results.txt
grep "16s" rnammer_results.txt > rnammer_16s.txt

# get predicted 16S regions from rnammer
python /Users/mann/github/mockcommunity/scripts/slice_fasta.py > rnammer_16s.fa 

# dereplicate
vsearch --derep_fulllength rnammer_16s.fa --output rnammer_16s.uniq.fa 

# how many sequence variants per species?
grep ">" rnammer_16s.uniq.fa | awk -F"_" '{print $3, $4}' | sort | uniq -c