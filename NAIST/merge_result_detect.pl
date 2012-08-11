#!/bin/perl
#======================================================#
# Tomoya MIZUMOTO
# 2012/08/11
#======================================================#
#使い方
#perl merge_result_detect.pl -a オープンの結果(<gen>)  -p 前置詞の結果(<prp>) -v 動詞の一致の結果(<v_agr>) 
#======================================================#
use strict;
use Encode;
use List::Util qw/min/;
use utf8;
use Getopt::Long;
#======================================================#
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
	my ($all_file, $prp_file, $vagr_file) = &get_opt();
	my @file = split(/\//,$all_file);
	my $output = "../" . $file[-1];

	if($all_file eq ""){
		exit;
	}
	my $all_text = &input_text($all_file);
	my $prp_text = &input_text($prp_file);
	my $vagr_text = &input_text($vagr_file);
	my @OUTPUT;

	for(my $i = 0; $i < @$all_text; $i++){
		$all_text->[$i] =~ s/$Htag$Ttag $Htag$Ttag( $Htag$Ttag)*/$Htag$Ttag/g;
		$prp_text->[$i] =~ s/<prp( crr="\w*")*>([\d\w]*?)<\/prp>/$Htag$2$Ttag/g;
		$vagr_text->[$i] =~ s/<v\_agr>([\d\w?;:'"%]*)<\/v\_agr>/$Htag$1$Ttag/g;
		my ($res) = &text_compalison($all_text->[$i], $prp_text->[$i], $vagr_text->[$i], " ");
		push(@OUTPUT, $res);
	}
	&output(\@OUTPUT, $output);
}
#---------------------------------------------------------#
#---------------------------------------------------------#
sub text_compalison{
	my ($all_text, $prp_text, $vagr_text, $part) = @_;
	
	my @all = split(/$part/,$all_text);
	my @prp = split(/$part/,$prp_text);
	my @vagr = split(/$part/,$vagr_text);

	my $all_num = 0;

	for(my $i = 0; $all_num < @all; $i++){
		if($all[$all_num] eq "$Htag$Ttag"){
			$all_num += 1;
		}
		elsif($prp[$i] =~ /$Htag/){
			$all[$all_num] = $prp[$i];
		}
		elsif($vagr[$i] =~ /$Htag/){
			$all[$all_num] = $vagr[$i];
		}
		$all_num += 1;
	}
	my $result = join(" ", @all);
	return ($result);
}
#---------------------------------------------------------#
#---------------------------------------------------------#
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
	my ($output_data, $output) = @_;
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
		print "USAGE: perl merge_result_detect.pl -a all_res  -p prp_res -v vagr_res\n";
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
#------------------------------------------------------#
#------------------------------------------------------#
sub get_opt{
	my $all_file = "";
	my $prp_file = "";
	my $vagr_file = "";

	GetOptions('--all=s' => \$all_file, '--prp=s' => \$prp_file, '--vagr=s' => \$vagr_file);

	return($all_file, $prp_file, $vagr_file);
}
#------------------------------------------------------#
#------------------------------------------------------#
