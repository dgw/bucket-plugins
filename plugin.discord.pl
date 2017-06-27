# BUCKET PLUGIN

use BucketBase qw/say config talking/;

sub signals {
    return (qw/on_public/);
}

sub settings {
    return (
        discord_chance => [ p => 15 ],
    );
}

sub route {
    my ( $package, $sig, $data ) = @_;

    if (    $data->{msg} =~ /\b(?<!>)Discord(?:\b|$)/i
        and rand(100) < &config("discord_chance")
        and &talking( $data->{chl} ) == -1 )
    {
        &say( $data->{chl} => ">Discord" );

        # don't process any further
        return 1;
    }

    return 0;
}
