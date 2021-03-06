#!/usr/bin/env perl6

use v6;

use JSON::Tiny;
use WWW;

sub MAIN(  Str $api-key, $file = "urls.json" ) {
    my $json = $file.IO.slurp();
    my $urls = from-json $json;
    my @shortened;
    my %already-shortened;
    for $urls.keys -> $i {
	my $p = $urls[$i];
	my $this-url = $p<url>;
	if ( ! %already-shortened<$this-url> ) {
	    my $response = jpost("https://www.googleapis.com/urlshortener/v1/url?key=$api-key",
				 to-json({longUrl => $this-url}),
				 :Content-Type<application/json>,
				);
	    %already-shortened{$this-url}=$response<id>;
	    push @shortened, { long => $this-url,
			       short => $response<id>,
			       text => $p<text> };
	}
    }
    say to-json @shortened;
}
