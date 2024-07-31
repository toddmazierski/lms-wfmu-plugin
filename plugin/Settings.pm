package Plugins::WFMU::Settings;

use strict;
use base qw(Slim::Web::Settings);

use Slim::Utils::Strings qw(string);
use Slim::Utils::Prefs;

my $prefs = preferences('plugin.wfmu');

sub name {
    return 'PLUGIN_WFMU';
}

sub page {
    return 'plugins/WFMU/settings.html';
}

sub beforeRender {
    my ( $class, $params ) = @_;

    $params->{programs} = $prefs->get('programs');
}

my $sanitizeProgramsInput = sub {
    my ($params) = @_;

    my $programs = [];

    foreach my $param ( sort keys %{$params} ) {
        if ( $param =~ /program_(.*)_id$/ ) {
            my $index = $1;
            my $id    = uc $params->{$param};

            if ($id) {
                push @$programs,
                  {
                    id   => $id,
                    name => $params->{ 'program_' . $index . '_name' } || $id,
                  };
            }
        }
    }

    return $programs;
};

sub handler {
    my $class = shift;
    my ( $client, $params ) = @_;

    if ( $params->{'saveSettings'} ) {
        $prefs->set( 'programs', $sanitizeProgramsInput->($params) );
    }

    return $class->SUPER::handler(@_);
}

1;
