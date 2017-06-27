# BUCKET PLUGIN

sub signals {
    return (qw/empty_lookup/)
}

sub route {
    my ( $package, $sig, $data ) = @_;

    if ( $data->{type} eq 'irc_msg' ) {
        return 1;
    }

    return 0;
}
