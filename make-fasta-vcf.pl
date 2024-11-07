#!/usr/bin/perl -w
open (IN1,'<',$ARGV[0]);
my @file_name;
my $input;
while ($input = <IN1>) {
	chomp $input;
	push (@file_name,$input);
}
close IN1;

#用参考序列文件AL878ji-reference-Dx-Dy.fa建立索引
#`bwa index AL878ji-reference-Dx-Dy.fa`;
#`samtools faidx AL878ji-reference-Dx-Dy.fa`;

my $key;
my @name_array;
#my @merge_array;
#my $sort_bam;
#my $fastq_name;
my @merge_file;
my $current_file;

#遍历数组生成每个物种的sam（带有物种ID）和bam文件
foreach $key(@file_name) {
	@name_array = split ("-",$key);
	#生成包含质量分数的10x reads 文件（fastq.gz)
#	`perl  do-better-reads-10x.pl $key`;
#	$fastq_name = "$key.fastq.gz";
#	`bwa mem -R '\@RG\\tID:$name_array[0]\\tSM:$name_array[0]\\tPL:ILLUMINA' AL878ji-reference-Dx-Dy.fa $fastq_name > $name_array[0].sam`;
#	my $cmd = "bwa mem -R '\@RG\\tID:$name_array[0]\\tSM:$name_array[0]\\tPL:ILLUMINA' AL878ji-reference-Dx-Dy.fa $fastq_name > $name_array[0].sam";
#	system($cmd) == 0 or die "Failed to execute: $cmd\n";
#	`samtools view -b -o $name_array[0].bam $name_array[0].sam`;
#	`samtools sort -o $name_array[0]_sorted.bam $name_array[0].bam`;
#	$sort_bam = "$name_array[0]_sorted.bam";
#	`bcftools mpileup -f AL878ji-reference-Dx-Dy.fa $name_array[0]_sorted.bam | bcftools call -mv -Ov -o $name_array[0]_sorted_bam.vcf`;

#压缩vcf生成$name_array[0]_sorted_bam.vcf.gz;
	`bgzip $name_array[0]_sorted_bam.vcf`;

#为压缩后的文件建立索引
	`tabix -p vcf $name_array[0]_sorted_bam.vcf.gz`;
	
	$current_file = "$name_array[0]_sorted_bam.vcf.gz";
	push (@merge_file,$current_file);	
}

$merge_input=join (" ",@merge_file);
`bcftools merge  $merge_input -o 43-scaffold-merged.vcf`;




#合并sam文件
#my $merge_input = join (" ",@merge_array);
#`samtools merge 43-scaffold-merged.bam	$merge_input`;
#`samtools rmdup 43-scaffold-merged.bam 43-scaffold_sorted_merged_rmdup.bam`;
#`samtools view -h 43-scaffold_sorted_merged_rmdup.bam > 43-scaffold_sorted_merged_rmdup.sam`;
