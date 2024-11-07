#!/usr/bin/perl -w

# 导入BioPerl库
use Bio::SeqIO;
use List::Util qw(sum);
my $seq_name;
my $file;
# 输入fasta文件名
my @file_array = glob "../2-scaffold-Dx-Dy-translate.dir/*trans.fa";
foreach $file(@file_array) {	
	my $fasta_file = $file;
	open (OUT1,'>',"$file-aa-classify.txt");
	# 用于存储氨基酸数量的哈希表
	my %amino_acid_counts;
	my %amino_acid_percentages;
	# 读取fasta文件
	my $seqio = Bio::SeqIO->new(-file => $fasta_file, -format => "fasta");
	while (my $seq = $seqio->next_seq) {
   	 my $sequence = $seq->seq;
       $seq_name = $seq->display_id;
    	# 统计氨基酸数量
    	$amino_acid_counts{$_} += () = $sequence =~ /$_/g for qw(A C D E F G H I K L M N P Q R S T V W Y );
	}

	# 计算总氨基酸数量
	my $total_count = sum (values %amino_acid_counts);
	my $Aliphatic = ($amino_acid_counts{G}+$amino_acid_counts{A}+$amino_acid_counts{V}+$amino_acid_counts{L}+$amino_acid_counts{I});
	my $Aromatic  = ($amino_acid_counts{F}+$amino_acid_counts{W}+$amino_acid_counts{Y});
	my $Sulphur   = ($amino_acid_counts{C}+$amino_acid_counts{M});
	my $Basic     = ($amino_acid_counts{K}+$amino_acid_counts{R}+$amino_acid_counts{H});
	my $Acidic    = ($amino_acid_counts{D}+$amino_acid_counts{E}+$amino_acid_counts{N}+$amino_acid_counts{Q});
	my $Aliphatic_hydroxyl = ($amino_acid_counts{S}+$amino_acid_counts{T}+$amino_acid_counts{Y});

	print OUT1"seq_name\t$seq_name\n";	
	print OUT1"total\t$total_count\n";
	print OUT1"Aliphatic\t$Aliphatic\n";
	print OUT1"Aromatic\t$Aromatic\n";
	print OUT1"Sulphur\t$Sulphur\n";
	print OUT1"Basic\t$Basic\n";
	print OUT1"Acidic\t$Acidic\n";
	print OUT1"Aliphatic_hydroxyl\t$Aliphatic_hydroxyl\n";
	close OUT1;
}
