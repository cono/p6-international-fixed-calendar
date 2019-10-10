use v6.c;
use Test;
use InternationalFixedCalendar::Date;

isa-ok(InternationalFixedCalendar::Date, Date, 'IFC::Date is a Date');

my InternationalFixedCalendar::Date $x;

$x .= new(2019, Int, 1);
is $x.Date.WHAT, Date, 'Date is a Date class';
is $x.Date.Str, "2019-12-31", "31 of December non-leap year";
is $x.month, Int, "2019-01 month undefined";
is $x.day, 1, '2019-01 day is NY day';
is ~$x, '2019-01', '2019-01.Str';

$x .= new(2000, Int, 1);
is $x.Date.Str, "2000-12-31", "31 of December leap year";
is $x.month, Int, "2000-01 month undefined";
is $x.day, 1, '2000-01 day is NY day';
is ~$x, '2000-01', '2000-01.Str';

$x .= new(2000, 6, 29);
is $x.Date.Str, "2000-06-17", "17 June leap year (29 June IFC)";
is $x.month, 6, "month for exceptional 29 of Jun";
is $x.day, 29, 'day for exceptional 29 of Jun';
is ~$x, '2000-06-29', '2000-06-29.Str';

$x .= new(2000, 13, 28);
is $x.Date.Str, "2000-12-30", "28 December in IFC";
is $x.month, 13, "December is a 13 month";
is $x.day, 28, 'day correct for 28 December';
is ~$x, '2000-13-28', '2000-13-28.Str';

$x .= new("2000-01");
is ~$x, '2000-01', '2000-01.Str for Str constructor';

$x .= new("2000-6-29");
is ~$x, '2000-06-29', '2000-06-29.Str for Str constructor';

$x .= new(Date.new(2000, 6, 17));
is ~$x, '2000-06-29', '2000-06-29 from Dateish';

my $inst = now;
$x .= new($inst);
is $x.Date, Date.new($inst), 'instant constructor';

done-testing;
