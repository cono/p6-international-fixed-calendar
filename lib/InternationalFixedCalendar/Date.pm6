use v6.c;
unit class InternationalFixedCalendar::Date:ver<0.0.1>:auth<github:cono> is Date;

sub ifc-to-date(Int:D $year, Int $month, Int:D $day --> Date) {
    my $jan-first     = Date.new($year, 1, 1);
    my $leap-modifier = $jan-first.is-leap-year.Int;
    my $day-of-year   = 365 + $leap-modifier;

    if $month.defined {
        $day-of-year = ($month - 1) * 28 + $day;
        $day-of-year += $leap-modifier if $month > 6;
    }

    return Date.new-from-daycount($jan-first.daycount + $day-of-year - 1);
}

sub default-formatter($self) {
    .month ?? sprintf('%04d-%02d-%02d', .year, .month, .day) !! sprintf('%04d-%02d', .year, .day) given $self;
}

multi method new(Int:D(Any:D) $year, Int(Any) $month, Int:D(Any:D) $day, :&formatter = &default-formatter) {
    self.Date::new(.year, .month, .day, :&formatter) given ifc-to-date($year, $month, $day);
}

multi method new(Int:D(Any:D) $year, Int:D(Any:D) $month, Int:D(Any:D) $day, :&formatter = &default-formatter) {
    self.Date::new(.year, .month, .day, :&formatter) given ifc-to-date($year, $month, $day);
}

multi method new(Int:D :$year!, Int :$month, Int:D :$day = 1) {
    self.Date::new($year, $month, $day);
}

multi method new(Str:D $date, :&formatter = &default-formatter) {
    my @parts = $date.split("-");

    return samewith(@parts[0], Int, @parts[1], :&formatter) if @parts.elems == 2;
    return samewith(@parts[0], @parts[1], @parts[2], :&formatter);
}

multi method new(Dateish $d, :&formatter = &default-formatter) {
    nextwith($d, :&formatter);
}

multi method new(Instant $i, :&formatter = &default-formatter) {
    nextwith($i, :&formatter);
}

method Date {
    return Date.new(.Date::year, .Date::month, .Date::day) given self;
}

method day {
    my $day-of-year = self.day-of-year;

    # exception for New Year Day (month is not defined)
    return 1 if $day-of-year == 366 || $day-of-year == 365 && !self.is-leap-year;

    # exception for 29 Jun in leap year
    return 29 if $day-of-year == 28 * 6 + 1 && self.is-leap-year;

    my $day = $day-of-year % 28 || 28;
    return $day unless self.is-leap-year;
    return $day if $day-of-year <= 28 * 6;

    $day-of-year -= 28 * 6 + 1;

    return $day-of-year % 28 || 28;
}

method month {
    my $day-of-year = self.day-of-year;

    # exception for New Year Day (month is not defined)
    return Int if $day-of-year == 366 || $day-of-year == 365 && !self.is-leap-year;

    # exception for 29 Jun in leap year
    return 6 if $day-of-year == 28 * 6 + 1 && self.is-leap-year;

    my $month = ($day-of-year / 28).ceiling;
    return $month unless self.is-leap-year;
    return $month if $month <= 6;

    $day-of-year -= 28 * 6 + 1;

    return ($day-of-year / 28).ceiling + 6;
}

=begin pod

=head1 NAME

InternationalFixedCalendar::Date - blah blah blah

=head1 SYNOPSIS

=begin code :lang<perl6>

use InternationalFixedCalendar::Date;

=end code

=head1 DESCRIPTION

InternationalFixedCalendar::Date is ...

=head1 AUTHOR

cono <q@cono.org.ua>

=head1 COPYRIGHT AND LICENSE

Copyright 2019 cono

This library is free software; you can redistribute it and/or modify it under the Artistic License 2.0.

=end pod

# vim: ft=perl6
