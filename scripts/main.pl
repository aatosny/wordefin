#!/usr/bin/perl
use strict;
use warnings;
use utf8;
use Gtk3 '-init';
use Glib 'TRUE', 'FALSE';
use Encode;

my $lst_out = qx(bash /etc/wordefin/scripts/lst.sh | sort);
my @lst_out = split(/\n/, decode('UTF-8', $lst_out));

my $window = Gtk3::Window->new('toplevel');
$window->set_title('wordefin by SNAOS Dev');
$window->set_default_size(300,200);
$window->signal_connect(delete_event => sub { Gtk3->main_quit });

# box
my $vbox = Gtk3::Box->new('vertical', 5);
$vbox->set_margin_top(10);
$vbox->set_margin_bottom(10);
$vbox->set_margin_start(10);
$vbox->set_margin_end(10);
$window->add($vbox);

#entry
my $entry = Gtk3::Entry->new();
$entry->set_placeholder_text('Search...');
$vbox->pack_start($entry, FALSE, FALSE, 0);

#scrolled window
my $scrolled_window = Gtk3::ScrolledWindow->new();
$scrolled_window->set_policy('automatic', 'automatic');
$vbox->pack_start($scrolled_window, TRUE, TRUE, 0);

#listbox
my $listbox = Gtk3::ListBox->new();
$scrolled_window->add($listbox);


sub update_listbox {
	my $term = $entry->get_text();
	my @children = $listbox->get_children();
    foreach my $child (@children) {
        $listbox->remove($child) if defined $child;
    }

	foreach my $lst_item (@lst_out) {
		if ($lst_item =~ /\Q$term\E/i) {
			my $row = Gtk3::ListBoxRow->new();
			my $label = Gtk3::Label->new($lst_item);
			$label->set_xalign(0);
			$row->add($label);
			$listbox->insert($row, -1);
			$row->show_all();
		}
	}
	$listbox->show_all();
}

$entry->signal_connect('key-release-event' => \&update_listbox);

$window->show_all();

Gtk3->main;
