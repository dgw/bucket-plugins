# BUCKET PLUGIN

# Mostly boilerplate code from my nosay plugin - dgw

use BucketBase qw/config Log/;

sub signals {
    return (qw/on_public on_msg/)
}

sub route {
    my ( $package, $sig, $data ) = @_;
    my $nick = &config('nick') || "Bucket";

    if ( $sig eq 'on_public' or $sig eq 'on_msg' ) {
        # first check if the line looks like teaching a factoid
        if ( $data->{msg} =~ /(.*?) (?:is ?|are ?)(<\w+>)\s*(.*)()/i
             or $data->{msg} =~ /(.*?)\s+(<\w+(?:'t)?>)\s*(.*)()/i
             or $data->{msg} =~ /(.*?)(<'s>)\s+(.*)()/i
             or $data->{msg} =~ /(.*?)\s+(is(?: also)?|are)\s+(.*)/i ) {
            return 0;  # if it looks like teaching, let processing continue
        # then if not, check if it looks like the "puts ___ in Bucket" item interaction
        } elsif ( $data->{msg} =~ /^(?:puts \s (\S.+) \s in \s (the \s)? $nick\b)/ix ) {
            Log "$data->{who} tried to lewd the bot and insert an item IN her in $data->{chl}; ignoring.";
            return 1;  # Halting core prevents default behavior, but plugins should (probably?) be allowed to continue
        }
    }

    return 0;
}
