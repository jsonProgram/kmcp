# Benchmarks on 16 mock virome communities from Roux et al

## Softwares

- KMCP [v0.8.0](https://github.com/shenwei356/kmcp/releases/tag/v0.8.0)
- MetaPhlAn [3.0.13 (2021-07-27)](https://github.com/biobakery/MetaPhlAn/releases/tag/3.0.13)
- Kraken [v2.1.2 (2021-05-10)](https://github.com/DerrickWood/kraken2/releases/tag/v2.1.2),
  Bracken [v2.6.2 (2021-03-22)](https://github.com/jenniferlu717/Bracken/releases/tag/v2.6.2)
- Centrifuge [v1.0.4 (2021-08-17)](https://github.com/DaehwanKimLab/centrifuge/releases/tag/v1.0.4)
- Ganon [1.1.2](https://github.com/pirovc/ganon/releases/tag/1.1.2)

## Databases and taxonomy version

- KMCP,  GTDB-RS202 (2021-04-27) + Genbank-viral (r246, 2021-12-06) + Refseq-fungi (r208, 2021-09-30), 2021-12-06
- Centrifuge, built with the genomes same to KMCP.
- MetaPhlAn, mpa_v30_CHOCOPhlAn_201901 (?), 2019-01
- Kraken, PlusPF (2021-05-17), 2021-05-17
- Kraken, built with the genomes same to KMCP.
- Ganon, built with the genomes same to KMCP.

In this benchmark, we generate metagenomic profiles with the same NCBI Taxonomy version 2021-12-06,
including the gold-standard profiles.

## Datasets

> Here we designed mock viral communities including both ssDNA and dsDNA viruses to evaluate
the capability of a sequencing library preparation approach including an Adaptase step prior
to Linker Amplification for quantitative amplification of both dsDNA and ssDNA templates.

> Two mock communities were designed (A and B) corresponding to two contrasting
> situations with either low abundance of ssDNA viruses (MCA, total ssDNA ∼2% of 
> community) or high abundance of ssDNA viruses (MCB, total ssDNA ∼66% of community)

> Roux S, Solonenko NE, Dang VT, Poulos BT, Schwenck SM, Goldsmith DB, Coleman ML, Breitbart M, Sullivan MB. 2016. Towards quantitative viromics for both double-stranded and single-stranded DNA viruses. PeerJ 4:e2777 https://doi.org/10.8.07/peerj.2777

Phages (rank is based on NCBI taxonomy 2021-12-06)

|phage      |taxid  |name                       |rank   |
|:----------|:------|:--------------------------|:------|
|PSA-HM1    |1357705|Pseudoalteromonas phage HM1|species|
|PSA-HP1    |1357706|Pseudoalteromonas phage HP1|no rank|
|PSA-HS1    |1357707|Pseudoalteromonas phage HS1|species|
|PSA-HS2    |1357708|Pseudoalteromonas phage HS2|species|
|PSA-HS6    |1357710|Pseudoalteromonas phage HS6|species|
|Cba phi38:1|1327977|Cellulophaga phage phi38:1 |species|
|Cba phi18:3|1327983|Cellulophaga phage phi18:3 |species|
|Cba phi38:2|1327999|Cellulophaga phage phi38:2 |species|
|Cba phi13:1|1327992|Cellulophaga phage phi13:1 |no rank|
|Cba phi18:1|1327982|Cellulophaga phage phi18:1 |no rank|
|phix174    |2886930|Escherichia phage phiX174  |no rank|
|alpha3     |10849  |Escherichia phage alpha3   |no rank|

The abundance of phages in every sample is listed in [Table S2](https://dfzljdn9uc3pi.cloudfront.net/2016/2777/1/ssDNA_dsDNA_viromes_2.0_Supplementary_Tables.xls).
We converted the abundance table to CAMI format, available at [Github](https://github.com/shenwei356/roux2016-mock-virome-cami-profile/releases/tag/v2021-12-06)

Mock communities A and B are available at: http://datacommons.cyverse.org/browse/iplant/home/shared/iVirus/DNA_Viromes_library_comparison.

> the 3 different protocols are indicated with a one-letter code: "S" for A-LA, "N" for TAG, and "G" for MDA.
For mock communities, replicates are indicated with a number next to the library code.

There are 16 samples in total:

    MCA-G1
    MCA-G2
    MCA-N1
    MCA-N2
    MCA-S1
    MCA-S2
    MCA-S3
    MCB-G1
    MCB-G2
    MCB-G3
    MCB-N1
    MCB-N2
    MCB-N3
    MCB-S1
    MCB-S2
    MCB-S3
    
But we found some name inconsistencies between the abundance table and FASTQ files.
After carefully checking, we renamed samples as below:

    old      new
    MCA-G1   MCA-G2
    MCA-G2   MCA-G3
    MCA-N2   MCA-N3

We manually download the paired-end and single-end reads for every sample, for example:

    $ ls reads/ | head -n 8
    MCA-G2_GGACTCCT-GCGTAAGA_L002_R1_001_t_paired.fastq.gz
    MCA-G2_GGACTCCT-GCGTAAGA_L002_R1_001_t_unpaired.fastq.gz
    MCA-G2_GGACTCCT-GCGTAAGA_L002_R2_001_t_paired.fastq.gz
    MCA-G2_GGACTCCT-GCGTAAGA_L002_R2_001_t_unpaired.fastq.gz
    MCA-G3_TAGGCATG-GCGTAAGA_L002_R1_001_t_paired.fastq.gz
    MCA-G3_TAGGCATG-GCGTAAGA_L002_R1_001_t_unpaired.fastq.gz
    MCA-G3_TAGGCATG-GCGTAAGA_L002_R2_001_t_paired.fastq.gz
    MCA-G3_TAGGCATG-GCGTAAGA_L002_R2_001_t_unpaired.fastq.g

**Note that some files of MCA-S1 and MCA-S2 are corrupted even after re-download, so we do not include these two samples.**

## KMCP

We search against GTDB, Genbank-viral, and Refseq-fungi respectively, and merge the results.


    # ------------------------------------------------------------------------
    # prepare folder and files
    
    reads=kmcp-pese
    
    # prepare folder and files.
    mkdir -p $reads
    cd $reads
    fd fastq.gz$ ../reads | rush 'ln -s {}'
    cd ..

   
    # ------------------------------------------------------------------------
    # search
      
    reads=kmcp-pese
    j=4
    J=40
    
    # -------------------------------------
    # gtdb

    db=gtdb.kmcp/
    X=taxdump/
    T=gtdb.kmcp/taxid.map    
    dbname=gtdb
    
    fd R1_001_t_paired.fastq.gz$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -v db=$db -v dbname=$dbname -j $j -v j=$J -v 'p={@^(.+)_R1_}' \
            'kmcp search -d {db} {p}_R1_001_t_paired.fastq.gz {p}_R2_001_t_paired.fastq.gz \
                {p}_R1_001_t_unpaired.fastq.gz {p}_R2_001_t_unpaired.fastq.gz \
                -o {p}.kmcp@{dbname}.tsv.gz \
                --log {p}.kmcp@{dbname}.tsv.gz.log -j {j}' \
            -c -C $reads@$dbname.rush
 
    # -------------------------------------
    # genbank-viral

    # genbank-viral
    db=genbank-viral.kmcp/
    X=taxdump/
    T=genbank-viral.kmcp/taxid.map    
    dbname=genbank-viral
    
    fd R1_001_t_paired.fastq.gz$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -v db=$db -v dbname=$dbname -j $j -v j=$J -v 'p={@^(.+)_R1_}' \
            'kmcp search -d {db} {p}_R1_001_t_paired.fastq.gz {p}_R2_001_t_paired.fastq.gz \
                {p}_R1_001_t_unpaired.fastq.gz {p}_R2_001_t_unpaired.fastq.gz \
                -o {p}.kmcp@{dbname}.tsv.gz \
                --log {p}.kmcp@{dbname}.tsv.gz.log -j {j}' \
            -c -C $reads@$dbname.rush
    
    # -------------------------------------
    # refseq-fungi
    
    # refseq-fungi
    db=refseq-fungi.kmcp/
    X=taxdump/
    T=refseq-fungi.kmcp/taxid.map    
    dbname=refseq-fungi
    
    fd R1_001_t_paired.fastq.gz$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -v db=$db -v dbname=$dbname -j $j -v j=$J -v 'p={@^(.+)_R1_}' \
            'kmcp search -d {db} {p}_R1_001_t_paired.fastq.gz {p}_R2_001_t_paired.fastq.gz \
                {p}_R1_001_t_unpaired.fastq.gz {p}_R2_001_t_unpaired.fastq.gz \
                -o {p}.kmcp@{dbname}.tsv.gz \
                --log {p}.kmcp@{dbname}.tsv.gz.log -j {j}' \
            -c -C $reads@$dbname.rush
    
    
    # ------------------------------------------------------------------------
    # merge results
    
    reads=kmcp-pese
    j=16
    fd R1_001_t_paired.fastq.gz$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j $j -v 'p={@^(.+)_R1_}' \
            'kmcp merge {p}.kmcp@*.tsv.gz -o {p}.kmcp.tsv.gz --log {p}.kmcp.tsv.gz.log'
  
    
    # ------------------------------------------------------------------------
    # [for merged search results] multiple profiling modes
    
    X=taxdump/
    cat genbank-viral.kmcp/taxid.map gtdb.kmcp/taxid.map refseq-fungi.kmcp/taxid.map > taxid.map
    cat genbank-viral.kmcp/name.map gtdb.kmcp/name.map refseq-fungi.kmcp/name.map > name.map
    T=taxid.map
    
    for m in $(seq 1 5); do
        fd kmcp.tsv.gz$ $reads/ \
            | csvtk sort -H -k 1:N \
            | rush -v X=$X -v T=$T -v m=$m \
                'kmcp profile -m {m} -X {X} -T {T} {} -o {}.k-m{m}.profile -C {}.c-m{m}.profile -s {%@(^......)} \
                    --show-rank superkingdom,phylum,class,order,family,genus,species \
                    --log {}.k-m{m}.profile.log' 
        
        profile=$reads.c-m$m.profile
        fd kmcp.tsv.gz.c-m$m.profile$ $reads/ \
            | csvtk sort -H -k 1:N \
            | rush -j 1 'cat {}' \
            > $profile
    done

    
## MetaPhlAn
    
    reads=mpa3-pese
    
    # prepare folder and files.
    mkdir -p $reads
    cd $reads
    fd fastq.gz$ ../reads | rush 'ln -s {}'
    cd ..
    
    reads=mpa3-pese
    j=4
    J=40
    
    dbdir=~/ws/db/mpa3/
    db=mpa_v30_CHOCOPhlAn_201901
    
    /bin/rm -rf $reads/*.bz2
    fd R1_001_t_paired.fastq.gz$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j $j -v j=$J -v 'p={@^(.+)_R1_}' -v db=$db -v dbdir=$dbdir \
            'memusg -t -s "metaphlan --add_viruses --input_type fastq {p}_R1_001_t_paired.fastq.gz,{p}_R2_001_t_paired.fastq.gz,{p}_R1_001_t_unpaired.fastq.gz,{p}_R2_001_t_unpaired.fastq.gz \
                 -o {p}.mpa3.profile -x {db} --bowtie2db {dbdir} \
                --bowtie2out {p}.bowtie2.bz2 --nproc {j} --CAMI_format_output" >{p}.log 2>&1 '

    profile=$reads.profile
    fd mpa3.profile$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j 1 'cat {}' \
        > $profile
        

    # ------------------------------------------------------
    # change taxonomy version
    
    taxdump=taxdump/
    fd mpa3.profile$ $reads/ \
        | rush -v taxdump=$taxdump \
            'grep -E "^#|@" -v {} \
                | csvtk grep -Ht -f 2 -p species \
                | csvtk cut -Ht -f 1,5 \
                | taxonkit profile2cami --data-dir {taxdump} -s {%@(^......)} \
                > {.}.new.profile'
                
    newprofile=$reads.new.profile
    fd mpa3.new.profile$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j 1 'cat {}' \
        > $newprofile
    
## Bracken

We use the [read_merger.pl](https://github.com/DerrickWood/kraken/blob/master/scripts/read_merger.pl)
from Kraken1 to merge paired-end reads, then feed Kraken2 with the merged PE reads and unpaired reads,
following:

- https://github.com/DerrickWood/kraken2/issues/214
- https://github.com/DerrickWood/kraken/issues/52

Two lines are modified in the script:

- Line 94, We change the default delimiter from `|` to `x`:

        $delimiter = 'x';

- Line 35, We initialize the `$output_format` with `""`, to mute the warning message:

        my $output_format = "";


Preparing tocami.py which convert Bracken output to CAMI format

    # wget https://raw.githubusercontent.com/hzi-bifo/cami2_pipelines/master/bin/tocami.py
    chmod a+x tocami.py

    # install pacakge ete3
    pip install ete3
    
    # preparing taxdump.tar.gz for tocami.py
    tar -zcvf taxdump.tar.gz taxdump/*
    
    # creating database for ete3 (don't worry the error reports, just ignore):
    tocami.py -t taxdump.tar.gz -f bracken -s 1 -d . bracken-pe/Build_sample1.bracken

Steps

    # --------------------------------------------------
    # using kraken's PLUSPF database

    reads=bracken-pese
    
    # prepare folder and files.
    mkdir -p $reads
    cd $reads
    fd fastq.gz$ ../reads | rush 'ln -s {}'
    cd ..

    reads=bracken-pese
    j=4
    J=40
    
    db=/home/shenwei/ws/db/kraken/pluspf    
    readlen=150
    threshold=10
    
    
    # --------------------------------------------------
    # using kraken database built with GTDB, Genbank-viral, Refseq-fungi
    
    reads=bracken-kmcp-pese
    
    # prepare folder and files.
    mkdir -p $reads
    cd $reads
    fd fastq.gz$ ../reads | rush 'ln -s {}'
    cd ..

    reads=bracken-kmcp-pese
    j=4
    J=40
    
    db=/home/shenwei/ws/db/kraken/kmcp/kmcp
    readlen=150
    threshold=10
    
    # time and memory are not recorded with memusg here
    fd R1_001_t_paired.fastq.gz$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j $j -v j=$J -v 'p={@^(.+)_R1_}' -v db=$db -v db=$db -v readlen=$readlen -v threshold=$threshold \
            'kraken2 --db {db} --threads {j} --memory-mapping  \
                    <(zcat {p}_R1_001_t_unpaired.fastq.gz {p}_R2_001_t_unpaired.fastq.gz && read_merger.pl --fq --gz {p}_R1_001_t_paired.fastq.gz {p}_R2_001_t_paired.fastq.gz ) \
                    --report {p}.kreport > /dev/null; \
                for r in S G F O C P D; do \
                    est_abundance.py -k {db}/database${readlen}mers.kmer_distrib -l $r -t {threshold} \
                    -i {p}.kreport -o {p}.bracken.level-$r ; \
                done; \
                cat {p}.bracken.level-* > {p}.bracken '

    # ------------------------------------------------------
    # convert to CAMI format
    fd .bracken$ $reads/ \
        | rush -j 12 'python3 ./tocami.py -d ./ -f bracken {} -s {%@(^......)} -o {}.profile'
    
    profile=$reads.profile
    fd bracken.profile$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j 1 'cat {}' \
        > $profile

## Centrifuge

    # --------------------------------------------------
    # using centrifuge database built with GTDB, Genbank-viral, Refseq-fungi

    reads=centrifuge-pese
    
    # prepare folder and files.
    mkdir -p $reads
    cd $reads
    fd fastq.gz$ ../reads | rush 'ln -s {}'
    cd ..

    reads=centrifuge-pese
    j=4
    J=40
    
    db=~/ws/db/centrifuge/kmcp  
    

    fd R1_001_t_paired.fastq.gz$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j $j -v j=$J -v 'p={@^(.+)_R1_}' -v db=$db \
            'memusg -t -s \
                "centrifuge -t -p {j} --mm -x {db} \
                    -q -1 {p}_R1_001_t_paired.fastq.gz -2 {p}_R2_001_t_paired.fastq.gz \
                    -U {p}_R1_001_t_unpaired.fastq.gz,{p}_R2_001_t_unpaired.fastq.gz \
                    --report-file {p}.cf-report.tsv -S {}.cf.tsv" \
                >{p}.log 2>&1 '

    # Kraken-style report
    fd R1_001_t_paired.fastq.gz$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j $j -v j=$J -v 'p={@^(.+)_R1_}' -v db=$db \
            'centrifuge-kreport -x {db} {}.cf.tsv > {}.kreport'
                
    # ------------------------------------------------------
    # convert to CAMI format
    fd .kreport$ $reads/ \
        | rush -j 12 'python3 ./tocami.py -d ./ -f centrifuge {} -s {%@(^......)} -o {}.profile'
    
    profile=$reads.profile
    fd kreport.profile$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j 1 'cat {}' \
        > $profile
        
## ganon

    # --------------------------------------------------
    # using ganon database built with GTDB, Genbank-viral, Refseq-fungi

    reads=ganon-pe
    
    # prepare folder and files.
    mkdir -p $reads
    cd $reads
    fd fastq.gz$ ../reads | rush 'ln -s {}'
    cd ..

    reads=ganon-pe    
    j=4
    J=40
    
    db=~/ws/db/ganon/ganon-kmcp    
    
    fd R1_001_t_paired.fastq.gz$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j $j -v j=$J -v 'p={@^(.+)_R1_}' -v db=$db \
            'memusg -t -s \
                "ganon classify -d {db} -t {j} \
                    -o {p} -s {p}_R1_001_t_paired.fastq.gz -2 {p}_R2_001_t_paired.fastq.gz \
                    {p}_R1_001_t_unpaired.fastq.gz,{p}_R2_001_t_unpaired.fastq.gz; \
                ganon table -l percentage --header taxid -r species -i {p}.tre -o {p}.tsv " \
                >{p}.log 2>&1 '
    
    # ------------------------------------------------------
    # convert profile table to cami format
    
    taxdump=taxdump/
    fd R1_001_t_paired.fastq.gz$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j $j -v j=$J -v 'p={@^(.+)_R1_}' -v db=$db -v taxdump=$taxdump \
            'sed 1d {p}.tsv \
                | taxonkit profile2cami --data-dir {taxdump} -s {%@(^......)} \
                | taxonkit cami-filter \
                > {:}.profile'
                
    newprofile=$reads.profile
    fd profile$ $reads/ \
        | csvtk sort -H -k 1:N \
        | rush -j 1 'cat {}' \
        > $newprofile
 
