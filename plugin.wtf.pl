# BUCKET PLUGIN

# Inspired by a request on IRC:
# <Panda> >expecting others to remember complicated commands
# <dgw> it's literally "Kaede, what was that"
# <Panda> too complicated!
# <dgw> would you prefer "Kaede, wtf"?
# <Panda> yes
# <Panda> unironically

use BucketBase qw/Log/;

sub signals {
    return (qw/on_msg on_public/)
}

sub route {
    my ( $package, $sig, $data ) = @_;

    if ( $sig eq 'on_msg' or $sig eq 'on_public' ) {
        if ( $data->{addressed} ) {
            Log "Plugin wtf rewriting addressed '$data->{msg}' to 'what was that?'";
            $data->{msg} =~ s/^w(?:hat|tf)\??$/what was that?/i;
        }
    }

    return 0;
}

sub commands {
    return ();
}

sub settings {
    return ();
}
