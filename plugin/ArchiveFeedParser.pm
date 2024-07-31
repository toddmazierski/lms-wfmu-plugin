package Plugins::WFMU::ArchiveFeedParser;

use strict;

use Slim::Formats::XML;

sub parse {
    my ( $class, $http, $params ) = @_;

    my $feed = Slim::Formats::XML::parseXMLIntoFeed( $http->contentRef,
        $http->headers()->content_type );

    foreach my $item ( @{ $feed->{items} } ) {
        $item->{title} =~ s/^WFMU MP3 Archive: //;
        $item->{type} = 'audio';
        $item->{url}  = $item->{link};
    }

    $feed->{nocache}   = 1;
    $feed->{cachetime} = 0;

    return $feed;
}

1;
