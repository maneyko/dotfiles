#!/usr/bin/env perl

$timeout    = 60;  # seconds
$sleep_time =  1;

# @files = sort { (stat($a))[9] cmp (stat($b))[9] } glob("*");
@files = sort { $a cmp $b } glob("*");


$original_last = @files[-1];
$new_last = $original_last;
$time_remaining = $timeout;

while ($new_last eq $original_last && $time_remaining > 0) {
    print(STDERR "\rLast file: $new_last, time remaining: $time_remaining ");
    sleep($sleep_time);
    $time_remaining -= $sleep_time;
    @files = sort { $a cmp $b } glob("*");
    $new_last = @files[-1];
}
print STDERR "\n";

print "${new_last}\n";
