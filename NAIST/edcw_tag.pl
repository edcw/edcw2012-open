#!/bin/perl
#======================================================#
# Tomoya MIZUMOTO
# 2012/08/11
#======================================================#
#使い方
#perl edcw_tag.pl テストデータ　システム出力結果
#======================================================#
use strict;
use Encode;
use List::Util qw/min/;
use utf8;
use Getopt::Long;
#======================================================#
my $tst_file = $ARGV[0];	#テストデータ
my $sys_file = $ARGV[1];	#システム出力結果ファイル
my @file = split(/\//,$sys_file);
my $output = $file[-1] . ".sys";
my $Htag = "<gen>";
my $Ttag = "</gen>";
#======================================================#
#------------------------------------------------------#
#------------------------------------------------------#
&argument_check();
&main();
#------------------------------------------------------#
#------------------------------------------------------#
sub main{
	my $tst_text = &input_text($tst_file);
	my $sys_text = &input_text($sys_file);
	my @OUTPUT;

	for(my $i = 0; $i < @$tst_text; $i++){
		$tst_text->[$i] =~ s/^\s//;
		$sys_text->[$i] =~ s/^\s//;
		my ($tst, $sys) = &ld_and_compalison($tst_text->[$i], $sys_text->[$i], " ");
#		print "$tst\n";
		push(@OUTPUT, $tst);
	}
	&output(\@OUTPUT);
}
#---------------------------------------------------------#
#---------------------------------------------------------#
sub ld_and_compalison{
	my ($src_text, $tgt_text, $part) = @_;
	
	my @ld = &levenshtein_distance($src_text, $tgt_text, $part);
	my @src = split(/$part/,$src_text);
	my @tgt = split(/$part/,$tgt_text);
	($src_text, $tgt_text) = &text_compalison(\@ld, \@src, \@tgt);

	return ($src_text, $tgt_text);
}
#---------------------------------------------------------#
#---------------------------------------------------------#
sub levenshtein_distance{
	my ($src, $tgt, $part) = @_;
	my @ld;

	my @src_word = split(/$part/,$src);
	my @tgt_word = split(/$part/,$tgt);

	for (my $i = 0; $i <= @src_word; $i++) {
		$ld[$i][0] = $i;
	}

	for (my $j = 0; $j <= @tgt_word; $j++) {
		$ld[0][$j] = $j;
	}

	for (my $i = 1; $i <= @src_word; $i++) {
		for (my $j = 1; $j <= @tgt_word; $j++) {
			my $diff = (&delete_punctuation(&lower($src_word[$i - 1])) eq &delete_punctuation(&lower($tgt_word[$j - 1]))) ? 0 : 2;
			$ld[$i][$j] = min($ld[$i - 1][$j - 1] + $diff, $ld[$i - 1][$j] + 1, $ld[$i][$j - 1] + 1);
		}
	}
	return @ld;
}
#---------------------------------------------------------#
#---------------------------------------------------------#
sub text_compalison{
	my ($ed, $src_text, $tgt_text) = @_;
 
	my $src_num = @$ed - 1;
	my $tgt_num = $#{$ed->[0]};
	my $del_num = 0;
	my $ins_num = 0;

	my $min = 100000;
	my $route = 0;
	while($tgt_num > 0){
		my $crrnt = $ed->[$src_num]->[$tgt_num];
		my $m1m1 = $ed->[$src_num - 1]->[$tgt_num - 1];
		my $pm0m1 = $ed->[$src_num]->[$tgt_num - 1];
		my $m1pm0 = $ed->[$src_num - 1]->[$tgt_num];

		$min = ($m1m1 < $m1pm0) ? $m1m1 : $m1pm0;
		$route = ($m1m1 < $m1pm0) ? 0 : 1;
		$min = ($min < $pm0m1) ? $min : $pm0m1;
		$route = ($min < $pm0m1) ? $route : 2;
		if($src_num > 1 and $tgt_num > 1){
			if($route == 0){	# substitution
				$src_num = $src_num - 1;
				$tgt_num = $tgt_num - 1;
				if($crrnt != $min){
					$del_num += 1;
					$ins_num += 1;
					splice(@$src_text, $src_num, 1, "$Htag$src_text->[$src_num]$Ttag");
				}
			}
			elsif($route == 1){	# deletion
				$src_num = $src_num - 1;
				$del_num += 1;
				splice(@$src_text, $src_num, 1, "$Htag$src_text->[$src_num]$Ttag");
			}
			else{	# insertion
				$tgt_num = $tgt_num - 1;
				$ins_num += 1;
				splice(@$src_text, $src_num, 0, "$Htag$Ttag");
			}
		}
		elsif($src_num == 1 and $tgt_num > 1){
			$tgt_num = $tgt_num - 1;
			if($route != 0){
				splice(@$src_text, $src_num, 0, "$Htag$Ttag");
			}
			$ins_num += 1;
		}
		elsif($tgt_num == 1 and $src_num > 1){
			$src_num = $src_num - 1;
			if($route != 0){
				splice(@$src_text, $src_num, 1, "$Htag$src_text->[$src_num]$Ttag");
			}
			$del_num += 1;
		}
		else{
			if($crrnt != 0){
				$src_num = $src_num - 1;
				$tgt_num = $tgt_num - 1;
				$del_num += 1;
				$ins_num += 1;
				splice(@$src_text, $src_num, 1, "$Htag$src_text->[$src_num]$Ttag");
			}
			$tgt_num = $tgt_num - 1; # while終了条件に使用
		}
	}
#	print "del: $del_num,  ins: $ins_num\n$tgt_text\t$src_text\n\n";
	my $src = join(" ",@$src_text);
	my $tgt = join(" ",@$tgt_text);
#	print "$src, $tgt\n";
	return ($src, $tgt);
}
#---------------------------------------------------------------------#
#---------------------------------------------------------------------#
sub split{
	my ($sent) = @_;
	my @newtext;

	for(my $i = 0; $i < @$sent; $i++){
		$sent->[$i] =~ s/\s//g;
		my @text = split(//,$sent->[$i]);
		$newtext[$i] = join(" ",@text);
		utf8::encode($newtext[$i]);
#		print "$newtext[$i]\n";
	}
	return \@newtext;
}
#------------------------------------------------------#
#------------------------------------------------------#
sub output{
	my ($output_data) = @_;
	my @text;

	open(OUT,">$output");
	foreach my $text(@$output_data){
		chomp $text;
		print OUT "$text\n";
	}
	close(OUT);
}
#------------------------------------------------------#
#ファイルのインプット
#------------------------------------------------------#
sub input_text{
	my $FileName = @_[0];
	my @text;

	open(IN,$FileName);
	while(my $input = <IN>){
		chomp $input;
		$input =~ s/^\s+//;
		utf8::decode($input);
		push(@text, $input);
	}
	close(IN);
	return \@text;
}
#-------------------------------------------------------#
#-------------------------------------------------------#
sub argument_check{
	if($#ARGV < 1){
		print "USAGE: test system\n";
		exit;
	}
}
#------------------------------------------------------#
#------------------------------------------------------#
sub lower{
	my ($word) = @_; # to store a word to be the lowercase
		
	$word =~ y/A-Z/a-z/;
	return($word);
}
#------------------------------------------------------#
#------------------------------------------------------#
sub delete_punctuation{
	my ($word) = @_;

	$word =~ s/[,\.]$//;
	return $word;
}
