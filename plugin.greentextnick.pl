# BUCKET PLUGIN

use BucketBase qw/say config talking/;

sub signals {
    return (qw/on_public/);
}

sub settings {
    return (
        greentext_nick_chance => [ p => 30 ],
    );
}

sub route {
    my ( $package, $sig, $data ) = @_;

    if (    $data->{msg} =~ /^>(\S+)$/i
        and rand(100) < &config("greentext_nick_chance")
        and &talking( $data->{chl} ) == -1
        and $::irc->is_channel_member( $data->{chl}, $1 ) )
    {
        &say( $data->{chl} => ">$data->{who}" );

        # don't process any further
        return 1;
    }

    return 0;
}
