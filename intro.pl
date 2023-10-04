=pod
 
=head1 Content
 
=over 4
 
=item    Was ist Embperl?
 
=item    Perl Code in HTML Dokumente einfügen
 
=item    Meta-Commands
 
=item    Dynamische Tabellen
 
=item    Formularfelder
 
=item    Persistente Daten (Sessions)
 
=item    Aufteilen des Codes in mehrere Komponenten
 
=item    Debugging
 
=item    Datenbankzugriff 
 
=item    Sicherheit
 
=item    Escaping/Unescaping
 
=back
 
=head1 Was ist Embperl?
 
=head2 Perl Code in HTML Dokumente einfügen
 
Die Hauptanwendung von HTML::Embperl ist Perlcode in HTML Dokumente
einzufügen. Embperl kann zwar ebenfalls mit nicht HTML Dokumenten benutzt
werden, hat jedoch einige Features speziell für HTML.
 
=head2 Zusätzliche HTML Features
 
Einer der Vorteile von Embperl ist, daß es speziell auf HTML
zugeschnitten ist. Es stellt u.a. Funktionen zur Formularbehandlung und für
HTML Tabellen zur Verfügung, einhergehend mit der Fähigkeit Logdateien
und Fehlerseiten in HTML darzustellen. Ebenso erledigt es die
HTML und URL Kodierung. Dies verhindet jedoch nicht das Embperl mit allen
Arten von Textdateien umgehen kann.
 
=head2 Integration mit Apache und mod_perl
 
Embperl kann offline (als normales CGI Skript oder als Modul dessen
Funktionen sich von anderem Perlprogrammen/-modulen aufrufen lassen) benutzt werden,
aber die meisten Möglichkeiten und beste Performance entwickelt es
unter mod_perl und Apache. Dort werden
direkt die Funktionen der Apache API genutzt und mod_perl erlaubt
es den Code vorzukompilieren, um dadurch den Compilierungsvorgang
bei jedem weiterem Request einzusparen.
 
=head2 Embperl arbeitet mit HTML Editoren
 
Embperl ist entworfen worden um direkt mit dem von HTML Editoren erzeugten
Code zu arbeiten. Der Perlcode wird dabei als normaler Text eingeben.
Es ist nicht nötig, das der HTML Editor spezielle HTML Tags kennt, noch
müssen diese über umständliche Dialoge eingegeben werden. Embperl
kümmert sich darum, z.B. ein vom HTML Editor erzeugtes &lt; in < umzuwandeln,
bevor es dem Perlinterpreter übergeben wird. Außerdem
entfernt es unerwünschte HTML Tags, z.B. ein <BR>, das der Editor
eingefügt hat, weil man eine neue Zeile anfängt, aus dem Perlcode.
 
=head1 Perl Code in HTML Dokumente einfügen
 
Perlcode kann auf drei Arten eingebettet werden:
 
=head2 1.)    [- ... -]    Führt den Code aus
 
    [- $a = 5 -]  [- $b = 6 if ($a == 5) -]
 
Der Code zwischen [- und -] wird ausgeführt, dabei wird keine Ausgabe
erzeugt. Diese Form eignet sich für Zuweisungen, Funktionsaufrufe,
Datenbankanfrage, usw.
 
=head2 2.)    [+ ... +] Das Ergebnis ausgeben
 
    [+ $a +]  [+ $array[$b] +] [+ "A is $a" +]
 
Der Code zwischen dem [+ und dem +] wird ausgeführt und der Rückgabewert
(der Wert des letzten Perlausdruckes welcher berechnet wurde) wird
ausgegeben (zum Browser gesandt)
 
=head2 3.)    [! ... !]    Code nur einmal ausführen
 
    [! sub foo { my ($a, $b) = @_ ; $a * $b + 7 } !]
 
Genauso wie [- ... -], der Code wird jedoch nur einmal, für den
ersten Request, ausgeführt. Dies ist hauptsächlich für Funktionsdefinitionen
und einmalige Initialisierungen.
 
=head1 Meta-Commands
 
Embperl unterstützt einige Meta-Commands um dem "Programmablauf"
innerhalb des Embperldokuments zu steuern. Dies kann mit einem
Preprozessor in  C verglichen werden. Die Meta-Commands haben folgende
Form:
 
    [$ <cmd> <arg> $]
 
 
=over 8
 
=item if, elsif, else, endif
 
Der if Befehl hat die selben Auswirkungen wie in Perl. Er kann genutzt
werden um Teile des Dokuments nur unter bestimmten Bedingungen auszugeben/auszuführen.
Beispiel:
 
 [$ if $ENV{REQUEST_METHOD} eq 'GET' $]
    <p>Dies ist ein GET Request</p>
 [$ elsif $ENV{REQUEST_METHOD} eq 'POST' $]
    <p>Dies ist ein POST Request</p>
 [$ else $]
    <p>Dies ist weder ein GET noch ein POST Request</p>
 [$ endif $]
 
Dieses Beispiel gibt eine der drei Absätze in Abhänigkeit von dem Wert
von $ENV{REQUEST_METHOD} aus.
 
 
=item while, endwhile
 
Der while Befehl wird dazu benutzt, um eine Schleife innerhalb des
HTML Dokuments zu erzeugen. Beispiel:
 
 [$ while ($k, $v) = each (%ENV) $]
    [+ $k +] = [+ $v +] <BR>
 [$ endwhile $]
 
Das Beispiel zeigt alle Environementvariablen, jede abgeschlossen
mit einem Zeilenumbruch (<BR>).
 
=item do, until
 
C<do> C<until> erzeugt ebenso eine Schleife, jedoch mit der Bedingung am Ende.
Beispiel:
 
 [- @arr = (3, 5, 7); $i = 0 -]
 [$ do $]
    [+ $arr[ $i++ ] +]
 [$ until $i > $#arr $]
 
=item foreach, endforeach
 
Erzeugt eine Schleife, die über jedes Element einer Liste/Arrays iteriert.
Beispiel:
 
 [$ foreach $v (1..10) $]
    [+ $v +]
 [$ endforeach $]
 
 
=item var <var1> <var2> ...
 
Standartmäßig ist es nicht nötig irgenwelche Variablen innerhalb einer
Embperlseite zu deklarieren. Embperl kümmert sich darum nach jedem Request
wieder aufzuräumen. Manchmal möchte man jedoch die zu benutzenden Variablen
explizit deklarieren. Dies ist mit var möglich:
 
 [$ var $a @b %c $]
 
Hat den selben Effekt wie der Perlcode:
 
 use strict ; use vars qw {$a @b %c} ;
 
=item hidden
 
hidden ermöglicht es versteckte Formularfelder zu erzeugen und wird weiter unten
im Abschnitt über Formularfelder beschrieben.
 
=back
 
=head1 Dynamische Tabellen
 
Ein sehr leistungsfähiges Feature von Embperl ist das Erzeugen von
dynamischen Tabellen. Am einfachsten lassen sich auf diesem Weg
Perlarrays in Tabellen umwandeln (ein- oder zweidimensional, gleich-
und ungleichmäßige), aber auch andere Datenquellen sind möglich.
 
=head2 Anzeigen eines Perlarrays 
 
 [- @a = ( 'A', 'B', 'C') ; -]
 <TABLE BORDER=1>
   <TR>
        <TD> [+ $a[$row] +] </TD>
   </TR>
 </TABLE>
 
Das obige Beispiel gibt einfach eine Tabelle mit drei Zeilen, welche A, B und
C enthalten aus.
 
Der Trick dabei ist die Benutzung der magischen Variable B<$row>, welche die
Zeilennummer innerhalb der Tabelle enthält und automatisch für jede Zeile um
eins erhöht wird. Die Tabelle ist zu Ende, wenn der Block, in dem B<$row> auftaucht,
B<undef> zurückgibt. Das funktioniert auch mit B<$col> für Spalten und B<$cnt> kann
benutzt werden, wenn die Elemente, nach einer bestimmten Anzahl, in die nächste
Reihe rutschen sollen.
 
Dies funktioniert ebenso mit C<table>/C<select>/C<menu>/C<ol>/C<dl>/C<dir>
 
=head2 Einfaches DBI Beispiel
 
Hier ist ein einfaches DBI Beispiel, welches das Ergebnis einer Anfrage
in einer zwei dimensionalen Tabelle anzeigt, mit den Feldnamen als Überschrift
in der ersten Zeile:
 
 [-
 # Verbinden mit Datenbank
  $dbh = DBI->connect($DSN) ;
 
 # SQL Select vorbereiten
 $sth = $dbh -> prepare ("SELECT * from $table") ;
 
 # Datenbankanfrage ausführen
 $sth -> execute ;
 
 # $head erhält die Feldnamen für die Tabellenüberschrift
 $head = $sth -> {NAME} ;
 
 # $dat erhält die Datensätze
 $dat = $sth -> fetchall_arrayref ;
 -]
 
 <table>
    <tr><th>[+ $head->[$col] +]</th></tr>
    <tr><td>[+ $dat -> [$row][$col] +]</td></tr>
 </table>
 
 
=head1 Formularfelder
 
=head2 Gesendete Formulardaten sind in %fdat/@Z<>ffld verfügbar
 
Der Hash B<%fdat> enthält alle Werte der Formularfelder. Das Array
B<@>Z<>B<ffld> enthält die Namen in der Reihenfolge wie sie gesendet wurden.
 
=head2 Input/Textarea/Select tags erhalten ihre Werte aus %fdat
 
Wenn innerhalb des HTML Codes kein Wert für ein Inputtag angegeben ist
und Daten in B<%fdat> dafür verfügbar sind, fügt Embperl automatisch den
Wert aus B<%fdat> ein. Dies ist ähnlich dem Verhalten von CGI.pm. Das
bedeutet, daß wenn man die Daten eines Formular (in einer Embperlseite) an
sich selbst schickt, automatisch die Daten wieder angezeigt werden, die gerade
eingegeben wurden.
 
=head2 [$ hidden $]
 
[$ hidden $] erzeugt versteckte Formularfelder für alle Werte aus B<%fdat>, die
bis dahin nicht in einem anderem Formularfeld ausgegeben wurden. Dies ist
hilfreich, wenn Daten über mehere Formulare hinweg transportiert werden müssen.
 
=head2 Ein einfaches Texteingabe/Bestätigungs Formular 
 
Das folgende Beispiel zeigt viele der Möglichkeiten von Embperl.
Es ist ein einfaches Formular, in dem man seinen Namen, seine Email Adresse,
sowie eine Nachricht eingeben kann. Wenn man es absendet,
werden die Daten zunächst noch einmal angezeigt.
Von dort kann man zum vorherigen Formular zurückkehren, um die Daten zu
korrigieren oder der Benutzer bestätigt die Daten, wodurch sie zu einer vordefinierten
Email Adresse gesandt werden. Das Beispiel zeigt auch wie eine Fehlerüberprüfung
implementiert werden kann. Wenn der Name oder die Email Adresse weggelassen wird,
wird eine entsprechende Fehlermeldung angezeigt und das Eingabeformular erscheint wieder.
 
Der erste Teil ist die Fehlerüberprüfung; der zweite Teil die Bestätigungsseite;
der dritte Teil versendet die Email, wenn die Eingaben bestätigt wurden und der
letzte Teil ist das Eingabeformular.
 
In Abhängigkeit der Werte von C<$fdat{check}>, C<$fdat{send}> und ob C<$fdat{name}> und
C<$fdat{email}> Daten enthalten, entscheidet das Dokument welcher Teil zur
Ausführung kommt.
 
 
 [-  $MailTo = 'richter\@ecos.de' ;
 
  @errors = () ;
  if (defined($fdat{check}) || defined($fdat{send}))
    {
    push @errors, "**Bitte Namen eingeben" if (!$fdat{name}) ;
    push @errors, "**Bitte E-Mail Adresse eingeben" if (!$fdat{email}) ;
    }
 -]
 
 [$if (defined($fdat{check}) and $#errors == -1)$]
 [-
  delete $fdat{input} ;
  delete $fdat{check} ;
  delete $fdat{send}
 -]
 
 <hr><h3> Sie haben folgende Daten eingegeben:</h3>
 <table>
  <tr><td><b>Name</b></td><td>[+$fdat{name}+]</td></tr>
  <tr><td><b>E-Mail</b></td><td>[+$fdat{email}+]</td></tr>
  <tr><td><b>Nachricht</b></td><td>[+$fdat{msg}+]</td></tr>
  <tr><td align="center" colspan="2">
     <form action="input.htm" method="GET">
       <input type="submit" name="send"
              value="Send to [+ $MailTo +]">
       <input type="submit" name="input" value="Daten abändern">
       [$hidden$]
    </form>
    </td></tr>
 </table>
 
 [$elsif defined($fdat{send}) and $#errors == -1$]
 
 [- MailFormTo ($MailTo,'Formdata','email') -]
 <hr><h3>Ihre Nachricht wurde abgeschickt</h3>
 
 [$else$]
 
 <hr><h3>Bitte geben Sie Ihre Daten ein</h3>
 
 <form action="input.htm" method="GET">
  <table>
    [$if $#errors != -1 $]
      <tr><td colspan="2">
      <table>
    <tr><td>[+$errors[$row]+]</td></tr>
      </table>
      </td></tr>
    [$endif$]
    <tr><td><b>Name</b></td> <td><input type="text"
                                        name="name"></td></tr>
    <tr><td><b>E-Mail</b></td> <td><input type="text"
                                          name="email"></td></tr>
    <tr><td><b>Nachricht</b></td> <td><input type="text"
                                           name="msg"></td></tr>
    <tr><td colspan=2><input type="submit"
                             name="check" value="Send"></td></tr>  </table>
 </form>
 
 [$endif$]
 
=head1 Persistente Daten (Sessions)
 
 (Embperl 1.2 oder neuer)
 
Während versteckte Felder gut innerhalb Formularen einsetzbar sind, ist es
oft notwendig B<Daten persistent> auf eine allgemeinere Art und Weise zu
speichern. Embperl benutzt I<Apache::Session> um dies durchzuführen.
I<Apache::Session> ermöglicht die Daten im Speicher, in einem Textfile 
oder in einer Datenbank abzuspeichern. Weitere Speichermöglichkeiten sind
für die Zukunft zu erwarten. Man kann zwar einfach I<Apache::Session> aus
Embperl Seiten herausaufrufen, aber Embperl ist in der Lage dies für den
Benutzer transparent durchzuführen. Es genügt einfach seine Daten in dem
Hash B<%udat> abzuspeichern, sobald der selbe Benutzer wieder eine Embperl
Seite aufruft, stehen in %udat wieder die selben Daten. Dies ermöglicht auf
eine einfache Art und Weise Zustandsinformationen für einen Benutzer zu speichern.
In Abhängigkeit vom Ablaufzeitpunkt können so Benutzerspezifische Daten
auch über einen längeren Zeitraum hinweg gespeichert werden. Ein zweiter Hash, B<%mdat>,
dient dazu, Daten, die zu einer bestimmten Seite gehören, zu speichern. Ein einfaches
Beispiel ist z.B. ein Zähler der Anzahl der Seitenaufrufe:
 
 
  Die Seite wurde seit dem [+ $mdat{date} ||= localtime +]
  [+ $mdat{counter}++ +] mal abgerufen
 
 
Das obige Beispiel zählt die Anzahl der Abrufe und zeigt die Zeit, wann die
Seite zum ersten Mal aufgerufen wurde.
Embperl sorgt dafür, dass die Daten nur dann wieder abgespeichert
werden, wenn sie auch geändert wurden.
 
 
=head1 Aufteilen des Codes in mehrere Komponenten
 
 (Embperl 1.2 oder neuer)
 
=head2 Funktionen
 
Wächst ein Programm, teilt man es in mehere Funktionen auf. Dies ist mit
Embperlseiten ebenfalls möglich. Folgendes Beispiel zeigt dies an Hand
von beschrifteten Texteingabefeldern:
 
 [$ sub textinput $]
    [- ($label, $name) = @_ -]
    [+ $label +]<input type=text name=[+ $name +]>
 [$ endsub $]
 
 
 <form>
    [- textinput ('Nachname', 'lname')  -]<p>
    [- textinput ('Vorname', 'fname') -]<p>
 </form>
 
Das C<sub> Meta-Command kennzeichnet den Anfang der Funktion und die Parameter werden
im Array C<@_> übergeben. Man kann innerhalb der Funktion alles tun, was auch in
einer normalen I<Embperl> Seite möglich ist. Aufgerufen wird die Funktion, wie
jede andere Perlfunktion auch, einfach durch Schreiben des
Namens und ggf. der Parameterliste.
 
=head2 Execute
 
Wenn man an einer ganzen Website arbeitet, kommt es meistens vor, daß es
Elemente gibt, die in jeder oder vielen Seiten immer wieder vorkommen.
Anstatt den Quellencode nun in jede Seite zu kopieren, ist es möglich
B<Embperl Module> in die Seite einzufügen, so daß der Quellencode nur
einmal existieren muß. So ein Modul könnte z.B. ein Kopf, ein Fuß,
eine Navigationsleiste usw. sein. Es können dabei nicht nur Teile
einer Seite eingefügt, sondern auch, ähnlich einem
Unterprogramm, Argumente übergeben werden - z.B. um der Navigationsleiste
mitzuteilen, welches Element hervorzuheben ist.
 
Beispiel für eine einfache Navigationsleiste
 
 [- @buttons = ('Index', 'Infos', 'Suchen') -]
 <table><tr><td>
     [$if $buttons[$col] eq $param[0]$] <bold> [$endif$]
     <a href="[+ $buttons[$col] +].html"> [+ $buttons[$col] +] </a>
     [$if $buttons[$col] eq $param[0]$] </bold> [$endif$]
 </td></tr></table>
 <hr>
 
 
Wenn man nun auf der Info-Seite ist, kann die Navigationsleiste wie
folgt eingefügt werden:
 
 [- Execute ('navbar.html', 'Infos') -]
 
 
Dies fügt die Navigationsleiste, welche in der Datei navbar.html gespeichert ist,
an entsprechender Stelle ein und übergibt ihr als Parameter die Zeichenkette 'Infos'.
Das Navigationsleistenmodul selbst benutzt eine dynamische Tabelle um die
Spalten anzuzeigen, welche den Text und einen entsprechenden Link enthalten. Die Texte
werden dabei dem Array @buttons entnommen. Wenn der Text gleich dem übergebenen Parameter ist,
wird er fett dargestellt.
Weiterhin gibt es noch eine ausführliche Form des Executeaufrufes, welche es erlaubt
sehr detailiert die Ausführung des Moduls zu kontrollieren.
 
=head2 Erstellen von Komponenten Libraries
 
Statt eine extra Datei für jedes bischen HTML Code zu erstellen, welches in
eine andere Seite eingefügt werden soll, ist es möglich diesen in eine 
HTML Datei zusammenzufassen. Um dies zuerreichen muß jedes einzelne 
Codestück eine eigene I<Embperl> Funktion sein. Mittels des C<import>
Parameters der C<Execute> Funktion können nun alle I<Embperl> Funktionen in 
den Namensraum der aktuellen Seite importiert werden und fortan
wie normale Perlfunktionen aufgerufen werden.
 
Weiterhin ist es möglich die I<Embperl> Funktionen (zusammen mit normalen Perl Code)
als ein Perl Modul (.pm Datei) zu installieren. Dadurch stehen sie systemweit zur
Verfügung und können wie jedes andere Perl Modul mittels C<use> genutzt werden.
 
=head1 EmbperlObject
 
 (ab Embperl 1.3)
 
Einen Schritt weiter als das einfache Einbetten von anderen Dateien mittels C<Execute> geht
I<EmbperlObject>. I<EmbperlObject> ist ein I<mod_perl> handler,
der es erlaubt eine Website in konsistenter Weise aus einzelnen Komponenten zusammenzusetzen.
Dabei definiert man ein Rahmenlayout, welches "Platzhalter" für einzelne Elemente der Site
(z.B. Kopf, Fuß, Navigation etc.) enthält. Diese "Platzhalter" können nun für unterschiedliche
Bereiche (Unterverzeichnisse) der Site mit verschiedenen Inhalten gefüllt werden. Definiert ein
Bereich (Unterverzeichnis) keinen eigenen Inhalt, wird automatisch der Inhalt des 
übergeordneten Verzeichnisses eingefügt. Konkret heißt das, man identifiziert Bereiche,
die auf allen/vielen Seiten gleich aussehen sollen, macht daraus eine eigenständige Komponente
(HTML Datei) und fügt diese dann nur noch an passender Stelle ein. Es leuchtet ein, dass dies
das Design und Änderungen wesentlich vereinfacht, da eine Änderung in der Komponente sich auf
alle Seiten auswirkt. Hier ein einfaches Beispiel, um zu verdeutlichen wie EmbperlObject arbeitet; dabei
definert base.htm das Rahmenlayout, head.htm enthält den Kopf und foot.htm den Fuß für die Seite:
 
B<Anordnung der Dateien:>
 
 /foo/base.htm
 /foo/head.htm
 /foo/foot.htm
 /foo/page1.htm
 /foo/sub/head.htm
 /foo/sub/page2.htm
 
B</foo/base.htm:>
 
 <html>
 <head>
 <title>Beispiel</title>
 </head>
 <body>
 [- Execute ('head.htm') -]
 [- Execute ('*') -]
 [- Execute ('foot.htm') -]
 </body>
 </html>
 
B</foo/head.htm:>
 
 <h1>Kopf aus foo</h1>
 
B</foo/sub/head.htm:>
 
 <h1>Hier ein anderer Kopf aus dem Verzeichnis sub</h1>
 
B</foo/foot.htm:>
 
 <hr> Fußzeile <hr>
 
 
B</foo/page1.htm:>
 
 Hier steht der Inhalt von Seite 1
 
B</foo/sub/page2.htm:>
 
 Hier steht der Inhalt von Seite 2
 
B</foo/sub/index.htm:>
 
 Index im Verzeichnis /foo/sub
 
Der Request B<http://host/foo/page1.htm> führt dann zu folgender Seite:
 
   
 <html>
 <head>
 <title>Beispiel</title>
 </head>
 <body>
 <h1>Kopf aus foo</h1>
 Hier steht der Inhalt von Seite 1
 <hr> Fußzeile <hr>
 </body>
 </html>
 
 
Der Request B<http://host/foo/sub/page2.htm> führt dann zu folgender Seite:
 
   
 <html>
 <head>
 <title>Beispiel</title>
 </head>
 <body>
 <h1>Hier ein anderer Kopf aus dem Verzeichnis sub</h1>
 Hier steht der Inhalt von Seite 2
 <hr> Fußzeile <hr>
 </body>
 </html>
 
 
Der Request B<http://host/foo/sub/> führt dann zu folgender Seite:
 
   
 <html>
 <head>
 <title>Beispiel</title>
 </head>
 <body>
 <h1>Hier ein anderer Kopf aus dem Verzeichnis sub</h1>
 Index im Verzeichnis /foo/sub
 <hr> Fußzeile <hr>
 </body>
 </html>
 
 
 
 
 
=head1 Debugging
 
=head2 Embperl Logdatei
 
Das Logfile ist die Hauptinformationsquelle zum Debuggen. Es zeichnet auf, was mit
der Seite geschieht, während sie von Embperl bearbeitet wird. In Abhängigkeit
von den Debugflags, logged Embperl folgende Dinge:
 
=over 4
 
=item    Quellencode
 
=item    Umgebungsvariablen
 
=item    Formular daten
 
=item    Perlcode (Quelle + Ergebnis)
 
=item    Tabellenbearbeitung
 
=item    Eingabe-Tag-Bearbeitung
 
=item    HTTP headers
 
=back
 
=head2 Embperl Logdatei kann direkt im Browser angezeigt werden
 
Zur Fehlersuche kann Embperl veranlasst werden, an jedem Seitenanfang
einen Link zur Logdatei anzuzeigen. Wenn man dem Link folgt, wird der
Teil der Logdatei, welcher zu dem entsprechenden Request gehört angezeigt.
Dabei werden unterschiedliche Einträge zur leichteren Orientierung verschiedenfarbig dargestellt.
 
=head2 Embperl Fehlerseite enthält Links zum Logfile
 
Wenn die Links zur Logdatei freigeschaltet sind, werden auch in jeder Fehlerseite
die Fehler direkt als Link dargestellt, die direkt auf die richtige Position im
Logfile verweisen. So läßt sich einfach feststellen, was an dieser Stelle schief
gelaufen ist.
 
=head1 Datenbankzugriff 
 
=head2 DBI
 
Dies ist ein weiteres Beispiel für den Datenbankzugriff mittels DBI.
Im Gegensatz zum vorhergehenden Beispiel arbeitet es aber mit expliziten
Schleifen.
 
 [-
 # Mit der Datenbank verbinden
 $dbh = DBI->connect($DSN) ;
 # Vorbereiten des SQL Select
 $sth = $dbh -> prepare ("SELECT * from $table") ;
 
 # Abfrage ausführen
 $sth -> execute ;
 
 # Ermitteln der Feldnamen für die Überschrift in $head
 $head = $sth -> {NAME} ;
 -]
 
 <table>
    <tr>
    [$ foreach $h @$head $]
        <th>[+ $h +]</th>
    [$ endforeach $]
    </tr>
    [$ while $dat = $sth -> fetchrow_arrayref $]
        <tr>
            [$ foreach $v @$dat $]
                <td>[+ $v +]</td>
            [$ endforeach $]   
        </tr>
    [$ endwhile $]
 </table>
 
 
=head2 DBIx::Recordset
 
 
DBIx::Recordset ist ein Modul welches den Datenbankzugriff vereinfachen soll.
Eine weiterführende Einführung zu DBIx::Recordset und Embperl findet sich in der iX 9/1999 
unter http://www.heise.de/ix/artikel/1999/09/137/ .
 
 
=head2 Datenbankabfrage Beispiel
 
 [-*set = DBIx::Recordset -> Search ({%fdat,
                                     ('!DataSource'   => $DSN,
                                      '!Table' => $table,
                                      '$max'   => 5,)}) ; -]
 <table>
  <tr><th>ID</th><th>NAME</th></tr>
  <tr>
    <td>[+ $set[$row]{id} +]</td>
    <td>[+ $set[$row]{name} +]</td>
  </tr>
 </table>
 [+ $set -> PrevNextForm ('Previous Records',
                          'Next Records',
                          \%fdat) +]
 
 
=head2 Search erzeugt ein Recordsetobjekt
 
Search nimmt die Werte aus %fdat und benutzt diese um einen SQL WHERE
Ausdruck zu erzeugen. Auf diese Weise hängt es davon ab, was an das
Dokument für Daten gesandt werden, welche Anfrage ausgeführt wird.
z.B. wenn man das Dokument mit http://host/mydoc.html?id=5 aufruft,
werden alle Datensätze deren Feld id den Wert 5 enthält angezeigt.
 
=head2 Die Daten können als Array oder mittels eines aktuellen Datensatzzeigers angesprochen werden
 
Das Ergebnis der Abfrage kann wie ein Array angesprochen werden (was nicht
heißt, daß das ganze Array auch tatsächlich von der Datenbank angefordert wird).
Alternativ können die Felder des aktuellen Record angesprochen werden.
 
    set[5]{id}   Zugriff auf das Feld 'id' des sechsten gefundenen Datensatzes
    set{id}      Zugriff auf das Feld 'id' des aktuellen Datensatzes
 
=head2 Felder können mit ihren Namen angesprochen werden
 
Während bei DBI Feldinhalte hauptsächlich über ihre Spaltennummern angesprochen
werden, benutzt DBIx::Recordset Spaltennamen. Dies macht das Programm einfacher
zu schreiben, leichter verständlich und unabhäniger von Veränderungen in der 
Datenbankstruktur.
 
=head2 PrevNextForm erzeugt keinen/einen/zwei Schaltflächen je nachdem ob
weitere Datensätze angezeigt werden müssen
 
Die PrevNextButtons Funktion kann dazu benutzt werden um Schaltflächen
zum Anzeigen der vorhergehenden bzw. folgenden Datensätze zu erzeugen.
C<PrevNextForm> generiert ein kleines Formular welches alle nötigen
Daten als versteckte Felder enthält.
 
=head2 Wie fürs Suchen, gibt es auch Funktionen für Insert/Update/Delete
 
Beispiel für Insert
 
Wenn C<%fdat> die Daten für einen neuen Datensatz enthält, fügt der
folgende Code einen diesen der angegebenen Tabelle hinzu.
 
 [-*set = DBIx::Recordset -> Insert ({%fdat,
                                      ('!DataSource'   => $DSN,
                                       '!Table' => $table)}) ; -]
 
 
=head2 Datenbanktabellen können ebenso an einen Hash gebunden werden
 
DBIx::Recordset kann ebenfalls eine Datenbanktabelle an einen Hash
binden. Man muß lediglich den Primärschlüssel der Tabelle angeben und
kann dann auf die Tabelle mittels eines Perl Hashs zugreifen.
 
    $set{5}{name}    Zugriff auf Feld 'name' mit id=5
                     (id ist Primärschlüssel)
 
=head2 Arbeiten mit mehreren Tabellen
 
DBIx::Recordset bietet zahlreiche Möglichkeiten um einfach mit mehreren
Tabellen umgehen zu können. DBIx::Recordset versucht auf Grund der
Namen innerhalb der Datenbank selbstständig Zusammenhänge zwischen
Tabellen zu erkennen.
Weitere Zusammenhänge können manuell angegeben werden.
Mit diesen Informationen kann DBIx::Recordset automatisch Unterobjekte
erzeugen, die die zum entsprechenden Datensatz zugehörigen Datensätze der
verbundenen Tabelle enthalten. Ebenso ist es möglich das DBIx::Recordset
einer Abfrage automatisch Felder hinzufügt, die den referenzierten
Datensatz beschreiben. So ist es z.B. möglich, wenn in einer Tabelle
die Kundennr enthalten ist, aus dem Kundenstammsatz automatisch den Namen
des Kunden hinzuzufügen, ohne das diese jedesmal explizit angeben werden
müßte.
 
 
=head1 Sicherheit
 
Bei der Ausführung unter mod_perl, teilt sich jeglicher Perlcode
einen Perlinterpreter. Das bedeutet, das jede Applikation auf alle Daten
aller anderen Applikationen zugreifen kann. Embperl verwaltet einen
separaten Namensraum für jedes Embperl Dokument, was ausreicht um
versehentliches Überschreiben von Daten anderer Applikationen zu verhindern.
Dieses Verfahren bietet jedoch keine wirkliche Sicherheit.
Der Zugriff auf alle Daten ist möglich durch die explizite Angabe eines
Package Namens.
 
=head2 Safe namespaces
 
Deshalb kann Embperl Safe.pm nutzen, um den Zugriff auf alle Namensräume
außerhalb des eigentlichen Skripts zu unterbinden. Dadurch wird es
z.B. möglich, Berechnungen innerhalb eines Perlmoduls durchzuführen und
die Ergebnisse an ein Embperl Dokument zu übergeben. Wenn dieses in
einem sicheren Namensraum läuft, kann es diese Ergebnisse darstellen,
jedoch auf keine anderen Daten zugreifen. Dadurch wird es sicher,
verschiedene Personen am Layout arbeiteten zu lassen.
 
 
=head2 Operatoren Einschränkungen
 
Safe.pm erlaubt es dem Administrator jeden Perl Opcode zu sperren.
Dadurch wird es möglich zu kontrollieren, welche Perl Opcodes
innerhalb der Seiten genutzt werden dürfen.
 
=head1 Escaping/Unescaping
 
=head2 Quellendaten: Unescaping
 
(sperren mit optRawInput)
 
 
 - konvertiert HTML escapes zu Zeichen (z.B. &lt; zu <)
 
 - entfernt HTML tags aus dem Perlcode (z.B. <br> welches durch einen
   HTML Editor eingefügt wurde)
 
 
 
=head2 Ausgabe: Escaping
 
(sperren mit escmode)
 
 
 - konvertiert Sonderzeichen nach HTML (z.B. < zu &lt;)