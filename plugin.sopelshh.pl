# BUCKET PLUGIN

use BucketBase qw/config Log/;
use Config::Tiny;

our $prefix = '';

sub signals {
    return (qw/empty_lookup/)
}

sub settings {
    return (
        sopel_config => [ f => '/var/lib/sopel/default.cfg' ],
    );
}

sub start {
    &load_config();
}

sub commands {
    return (
        {
            label     => 'refresh sopel config',
            addressed => 1,
            operator  => 1,
            editable  => 0,
            re        => qr/^refresh sopel config$/i,
            callback  => \&load_config
        },
    );
}

sub route {
    my ( $package, $sig, $data ) = @_;

    return 0 if $::prefix eq '';

    if ( $data->{msg} =~ /^(?:$::prefix)/ ) {
        return -1;
    }

    return 0;
}

sub load_config {
    my $config = Config::Tiny->read( &config('sopel_config') );

    if ( exists $config->{core}->{prefix} ) {
        $::prefix = $config->{core}->{prefix};
    } else {
        $::prefix = '\.';
    }

    &Log( "Loaded Sopel prefix: '$::prefix'" );
}
