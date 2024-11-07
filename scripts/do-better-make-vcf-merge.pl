#!/usr/bin/perl -w
open (IN1,'<',$ARGV[0]);#合并后的vcf文件
my @species_file = glob "*.vcf";
print @species_file."\n";
open (OUT1,'>',"$ARGV[0]-between.vcf");#输出文件
my @total_pos;
my %hash;
my $line;
my @line_array;
my $line_before;
while ($line = <IN1>) {
	chomp $line;
	if ($line =~/#/) {
		print OUT1"$line\n";
	} elsif ($line =~/^AL878/) {
		@line_array = split ("\t",$line);
		$line_before = join ("\t",@line_array[0..8]);
		print OUT1"$line_before\n";
	} else {
		next;
	}
}
close IN1;

close OUT1;

my $file;

foreach $file(@species_file) {
	#为每个文件创建hash;
	my $file_line;
	my $file_pos;
	my @file_info;
	my $GT;
	my %file_hash;
	open (IN2,'<', $file) or die "Cannot open $file: $!";
	while ($file_line = <IN2>) {	
		chomp $file_line;
		if ($file_line =~ /#/) {
			next;
		} else {
			@file_info = split ("\t",$file_line);
			$file_pos = $file_info[1];
			$GT = $file_info[9];
			$file_hash{$file_pos} = $GT;
		}
	}
	close IN2; 		

	my $out_pos;
	my @out_info;
	#遍历只含有前九行的vcf文件	
	open (IN3,'<',"$ARGV[0]-between.vcf");
	open (OUT2,'>',"$ARGV[0]-final.vcf");
	my $before_data;
	my $before_pos;
	my @before_array;
	while ($before_data = <IN3> ) {
		chomp $before_data;
		if ($before_data =~ /#/) {
			print OUT2"$before_data\n";
		} else {
			@before_array = split ("\t",$before_data);
			$before_pos = $before_array[1];
			if ($file_hash{$before_pos}) {
					print OUT2"$before_data\t$file_hash{$before_pos}\n";
			} else {
				print OUT2"$before_data\t0\/0\:0\,3\,60\n";
			}
		}
	}
	close IN3;
	close OUT2;
	`mv  $ARGV[0]-final.vcf $ARGV[0]-between.vcf`;
}
