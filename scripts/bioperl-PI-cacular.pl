#!/usr/bin/perl -w
use Bio::SeqIO;
use Bio::Tools::pICalculator;
use Bio::Seq;

open (OUT1,'>',"test-PI-cacular.txt");
my @file_array = glob "*trans.fa";
my $seq;
my $sequence;
my $seq_name;
my $calculator;
foreach $file_name(@file_array) {
	my $seq_PI = '';
	# 创建Bio::Seq对象
	my $seqio = Bio::SeqIO->new(-file => $file_name, -format => "fasta");
	while ($seq = $seqio->next_seq) {
		$seq_name = $seq->display_id;
		$sequence = $seq->seq;
		# 创建pI计算器对象
		my $bioseq = Bio::Seq->new(-seq => $sequence);
		$calculator = Bio::Tools::pICalculator->new(-seq => $bioseq);
	
		# 计算等电点
		my $pI = $calculator->iep;
		my $seq_PI = sprintf ("%.5f",$pI);
		print OUT1"$seq_name\t$seq_PI\n";
	}
}
close OUT1;
