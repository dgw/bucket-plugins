# BUCKET PLUGIN

use BucketBase qw/Log/;

sub signals {
    return (qw/pre_expand/)
}

sub route {
    my ( $package, $sig, $data ) = @_;

    if ( $sig eq 'pre_expand' ) {
        my $oldmsg = "";
        my $msg = $data->{tidbit};
        while ( $oldmsg ne $$msg and $$msg =~ /(?<!\\)\{([^}]*(\|[^}]*)+)\}/ ) {
            $oldmsg = $$msg;
            my @choices = split /(?<!\\)\|/, $1, -1;
            my $choice = $choices[ rand @choices ];
            $$msg =~ s/\Q$&\E/$choice/i;
            if ( $choice =~ /\\\|/ ) {
                ( my $unesc_choice = $choice ) =~ s/\\\|/|/g;
                $$msg =~ s/\Q$choice\E/$unesc_choice/;
            }
        }
    }

    return 0;
}
