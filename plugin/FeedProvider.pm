package Plugins::WFMU::FeedProvider;

use strict;

use Slim::Utils::Strings qw(string);
use Slim::Utils::Prefs;

my $prefs = preferences('plugin.wfmu');

my $liveStreamItems = [
    {
        name  => string('PLUGIN_WFMU_STREAMS_WFMU'),
        type  => 'audio',
        url   => 'http://stream0.wfmu.org/freeform-128k.mp3',
        image => 'plugins/WFMU/html/images/streams-wfmu.jpg'
    },
    {
        name  => string('PLUGIN_WFMU_STREAMS_ROCK_N_SOUL'),
        type  => 'audio',
        url   => 'https://wfmu.org/wfmu_rock.pls',
        image => 'plugins/WFMU/html/images/streams-rock-n-soul.jpg'
    },
    {
        name  => string('PLUGIN_WFMU_STREAMS_DRUMMER'),
        type  => 'audio',
        url   => 'https://wfmu.org/wfmu_drummer.pls',
        image => 'plugins/WFMU/html/images/streams-drummer.jpg'

    },
    {
        name  => string('PLUGIN_WFMU_STREAMS_SHEENA'),
        type  => 'audio',
        url   => 'https://wfmu.org/wfmu_sheena.pls',
        image => 'plugins/WFMU/html/images/streams-sheena.jpg'
    },
];

my $liveStreamsRoot = {
    name  => 'Live Streams',
    items => $liveStreamItems,
    image => 'html/images/radiofeeds.png'
};

my $latestShowsItem = sub {
    return {
        name   => 'Latest Shows',
        type   => 'playlist',
        url    => 'https://www.wfmu.org/archivefeed/mp3?t=' . time, # HACK to avoid caching
        parser => 'Plugins::WFMU::ArchiveFeedParser',
        image  => 'html/images/newmusic.png'
    };
};

my $getMyProgramsRoot = sub {
    my $items = [];

    foreach my $program ( @{ $prefs->get('programs') } ) {
        push @$items,
          {
            name => $program->{name},
            type => 'playlist',
            url  => 'https://www.wfmu.org/archivefeed/mp3/'
              . $program->{id} . '.xml',
            parser => 'Plugins::WFMU::ArchiveFeedParser',
          };
    }

    return {
        name  => 'My Programs',
        items => $items,
        image => 'html/images/favorites.png'
    };
};

sub call {
    my ( $client, $callback ) = @_;

    $callback->(
        {
            items => [
                $liveStreamsRoot, $latestShowsItem->(), $getMyProgramsRoot->()
            ]
        }
    );
}

1;
