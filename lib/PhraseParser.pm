package PhraseParser;

# $Id: /loc/web/dic/phrase/lib/PhraseParser.pm 1584 2008-05-31T06:48:00.765253Z greg  $

use strict;
use warnings;

use Lingua::LinkParser;
use Parse::RecDescent;
use Lingua::Treebank::Const;
use Ctest;

=head2 parse

	PhraseParser->parse($unclozeables, $text)

Returns database-ready strings representing phrases from individual sentences (lines) in text, differently than the parses of Ctest, etc, which return objects. 

=cut
	
sub parse
{
	my $self = shift;
	my $clozeType = shift;
	my $unclozeables = shift;
	my $lines = shift;
	my @lines = split m/\n/, $lines;
	my $n = 0;
	my (@parsers, $sentence, @linkages, @trees, @parses);
	$parsers[0] = Lingua::LinkParser->new('max_null_count' => 0);
	for my $line (@lines)
	{
		for my $i (0..$n)
		{
			$sentence = $parsers[$i]->create_sentence($line);
			@linkages = $sentence->linkages;
			last if @linkages;
		}
		until ( @linkages )
		{
			$n++;
			$parsers[$n] = Lingua::LinkParser->new('max_null_count'
							=> $n);
			$sentence = $parsers[$n]->create_sentence($line);
			@linkages = $sentence->linkages;
		}
		push @trees, $parsers[$n]->print_constituent_tree($linkages[0], 1);
	}
	my $grammar = q{
		<autotree>
		sentence: node end  {$PhraseParser::parse = $item{node}}
		node: '(' tag node(s) ')'
			{$return = PhraseParser::treebank({%item})}
			| terminal 
		tag: m/[A-Z]+/ 
		terminal: word  |
			punctuation 
		word: m/\\w+/ 
		punctuation: m/[:;,.?'"-]/ 
		end: /^\\Z/
	};
	my $parser = Parse::RecDescent->new( $grammar );
	for my $sentence ( @trees )
	{	
		$PhraseParser::parse = '';
		defined $parser->sentence($sentence) or die
						"bad sentence: $sentence";
		push @parses, $PhraseParser::parse;
	}
	my @phrases;
	my $lineN = 0;
	for my $line ( @parses )
	{
		my $children = $line->children;
		my $childN = 0;
		for my $child ( @$children )
		{	
			my $text = $child->text;
			my $words = $clozeType->parse( $unclozeables, $text );
			my $cloze = $words->cloze;
			my @rendered = map { ref($_)? $_->asUnderline: $_ } @$cloze;
			my $rendered = join '', @rendered;
			my $phrase =
				{ line => $lineN,
				position => $childN,
				tag => $child->tag,
				text => $text,
				rendered => $rendered,
				clozeline => $cloze,
				};
			push @phrases, $phrase;
			$childN++;
		}
		$lineN++;
	}
	return \@phrases;
}

sub treebank {
	my $args = shift;
	my $object = Lingua::Treebank::Const->new;
	$object->tag( $args->{tag}->{__VALUE__} || 'TERM' );
	if ($args->{__RULE__} eq 'node')
	{
		for my $node (@{$args->{'node(s)'}})
		{		
			if (ref $node eq 'Lingua::Treebank::Const')
			{
				$object->append( $node );
			}
			else {		
				my $child = Lingua::Treebank::Const->new;
				$child->tag($node->{tag}->{__VALUE__});
				if (exists $node->{terminal}->{word})
				{			
					$child->tag('WORD');
					$child->word(
					$node->{terminal}->{word}->{__VALUE__});
				}
				elsif (exists $node->{terminal}->{punctuation})
				{				
					$child->tag('PUNCTUATION');
					$child->word(
					$node->{terminal}->{punctuation}->
					{__VALUE__});
				}
				$object->append( $child );
			}
		}
	}
	return $object;
}

1;
