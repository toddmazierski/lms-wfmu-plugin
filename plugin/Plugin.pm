package Plugins::WFMU::Plugin;

use strict;
use base qw(Slim::Plugin::OPMLBased);

use Slim::Utils::Strings qw(string);
use Slim::Utils::Prefs;
use Slim::Utils::Log;

use Plugins::WFMU::FeedProvider;

my $log;

my $prefs = preferences('plugin.wfmu');
$prefs->init(
    {
        programs => [
            {
                id   => "WA",
                name => "Wake with Clay Pigeon"
            },
        ],
    }
);

BEGIN {
    $log = Slim::Utils::Log->addLogCategory(
        {
            'category'     => 'plugin.wfmu',
            'defaultLevel' => 'ERROR',
            'description'  => string('PLUGIN_WFMU'),
        }
    );
}

sub initPlugin {
    my $class = shift;

    $class->SUPER::initPlugin(
        feed => \&Plugins::WFMU::FeedProvider::call,
        tag  => 'wfmu',
        menu => 'radios',
    );

    if (main::WEBUI) {
        require Plugins::WFMU::Settings;
        Plugins::WFMU::Settings->new();
    }
}

sub getDisplayName { 'PLUGIN_WFMU' }

sub playerMenu { undef }

1;
