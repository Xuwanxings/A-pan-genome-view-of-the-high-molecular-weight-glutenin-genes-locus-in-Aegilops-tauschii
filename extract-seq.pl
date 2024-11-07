#!/usr/bin/perl -w

open my $in_fh, '<', $ARGV[0] or die "Cannot open input file: $!";
open my $out_fh, '>', $ARGV[1] or die "Cannot open output file: $!";

my %pr_list;
my $name;
#读取fasta文件
while (my $line = <$in_fh>) {
    chomp $line;
    if ($line =~ /^>(\S+)/) {
        $name = $1;
    } else {
        $pr_list{$name} .= $line;#将contig名称与序列做成hash
    }
}

close $in_fh;

my $target_sequence = $pr_list{$ARGV[2]};

if (defined $target_sequence) {
    my $start_index = $ARGV[3]-1;
    my $end_index =   $ARGV[4]-1;
    my $length = $end_index - $start_index + 1;
    my $start_name = $ARGV[3];
    my $end_name = $ARGV[4];
    my $extracted_sequence = substr($target_sequence, $start_index, $length);
    print $out_fh ">$ARGV[2]\n$extracted_sequence\n";
} else {
    die "Sequence not found in input file.";
}

close $out_fh;
