# Wordefin
### By SNAOS Dev

Wordefin is a simple GUI/TUI studying tool, programmed in perl and bash. It allows you to find word definitions based on .txt/.md/.lst word lists.

## Getting Started

### Dependencies

Tested on Fedora 40 and MacOS 10.15. Should work on any GNU/Linux Distribution.

**Required:**
* Perl
* Gtk3 (the Gtk3 perl module)
* Make
* Git

### Installing

1.
```
git clone https://github.com/aatosny/wordefin.git
```
2.
```
cd wordefin
```
3.
```
./build.sh
```


To uninstall, run
```
wordefin --uninstall
```
### Executing program

To launch GUI app, either open it as an app or run 
```
wordefin -g
```

To launch in your current terminal session, simply run
```
wordefin
```
To quit, simply type :q. No other commands are available

## Help

You can have up to 9 wordlists at the same time. The default directory for wordlists is ~/Wordefin/.

Wordlists must be in a format 
"word
definition
word
definition
word
definition ..." See example.txt.

Run ```wordefin --help``` for helper info.

## License

This project is licensed under the GNU General Public License - see the LICENSE file for details.