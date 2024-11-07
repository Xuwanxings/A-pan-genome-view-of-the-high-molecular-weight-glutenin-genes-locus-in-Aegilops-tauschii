#!/usr/bin/perl -w
use Bio::SeqIO;

# 输入fasta文件名
#my $input_file = 'input.fasta';

# 输出fastq文件名
#my $output_file = 'output.fastq';

# 设定测序深度
my $depth = 10;

# 打开fasta输入文件
my $seqio = Bio::SeqIO->new(-file => $ARGV[0], -format => 'fasta');

# 打开fastq输出文件
open(my $outfh, '>', "$ARGV[0].fastq") or die "Cannot open file output_file: $!";

# 处理每个序列
while (my $seq = $seqio->next_seq) {
    my $seq_length = $seq->length;
    my $read_length = int($seq_length / $depth)+1;

    # 生成reads并计算质量值
    for (my $i = 0; $i < $depth; $i++) {
        my $start = $i * $read_length;
        my $end = ($i + 1) * $read_length - 1;
        my $subseq = $seq->subseq($start + 1, $end + 1);  # BioPerl的subseq是从1开始计数的
		  if ($start >= $seq_length) {
				next;
		  } elsif ($end >= $seq_length) {
			  $end = $seq_length;
		  } else {
				$end = $end;
		  }	 
        # 假设质量值都为40，可以根据实际情况修改
        my $quality = 'I' x length($subseq);  # 使用ASCII码对应的'I'，代表质量值为40

        # 写入fastq格式的输出
        print $outfh "@" . $seq->id . "_" . ($i + 1) . "\n";
        print $outfh $subseq . "\n";
        print $outfh "+\n";
        print $outfh $quality . "\n";
    }
}

close $outfh;
`gzip $ARGV[0].fastq`;
