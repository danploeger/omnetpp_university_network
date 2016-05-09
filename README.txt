!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!																			     	   	  !!!!!!!!!!
!!!!!!!!!!  WICHTIG: Die Dateien in diesem Dropboxordner nicht direkt ändern! Immer Git benutzen  !!!!!!!!!!
!!!!!!!!!!																			              !!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ALLGEMEINER WORKFLOW:
Git nutzt drei verschiedene Ebenen:
1) ORIGIN				# Die globale Master-Version die in der Dropbox liegt und NIEMALS direkt bearbeitet wird.
2) Stage				# Lokale Zwischenstufe, in der die lokale Historisierung einer Datei hinterlegt ist 
						# (eine Version für jedes git commit).
3) Working Directory 	# Lokale Arbeitskopie, welche die echten Dateien enthält, an denen gearbeitet wird.

##########################
###  HOWTO SET-UP GIT  ###
##########################

1) Downloade und installiere Git: https://git-scm.com/
2) "Git Bash" starten.
3) Folgende Zeilen eingeben:
	git config --global user.name "John Smith"			# Dein Name.
	git config --global user.email john@example.com		# Deine Mail.

########################################
###  SET-UP UND NUTZUNG VIA GIT BASH ###
########################################

- Irgendwo AUßERHALB der Dropbox (am besten im Projektordner von OMNeT++) die Git bash öffnen.
- Lokale Version vom Repository anlegen:
	git clone  ~/Dropbox/OMNeT_Git						# Richtigen Dropbox-Pfad wählen!
	
### Jetzt könnt ihr die Dateien am LOKALEN Speicherort bearbeiten und ändern:
- In den geklonten Ordner wechseln:
	cd OMNeT_Git
- Änderungen von ORIGIN (Dropbox) herunterladen und mit lokalen Änderungen zusammenführen (merge);
  immer ausführen, falls jemand anderes Änderungen hochgeladen (pushed) hat:
	git pull											# Bei dem Fehler: "fatal: Not a git repository" 
														# seid ihr nicht im richtigen Ordner.
- Eigene Änderungen an Dateien hochladen:
	git add <filename> 									# Richtigen Pfad und Namen aller neuen 
														# und geänderten Dateien wählen.
	git commit -m "Dies und das habe ich geändert"		# Änderungen aus dem Working Directory ins Stage, 
														# mit Kommentar der Änderungen.
	git push origin master								# Push von Stage ins Remote Directory (ORIGIN / Dropbox).
- Wenn ihr mal etwas in der lokalen Kopie kaputt gemacht habt und zu der letzten commit-Version 
  (vom Server/Dropbox) zurück wollt:
	git checkout --<filename>							# Änderungen dieser Datei in der Working Directory 
														# werden überschrieben, aber Änderungen des Stage 
														# bleiben erhalten.
  # ODER
	git fetch origin
	git reset --hard origin/master						# Harter reset auf den Stand in der Dropbox, 
														# Änderungen in der Working Directory und Stage 
														# werden überschrieben.


Weitere Tutorials und Hilfen:
http://marklodato.github.io/visual-git-guide/index-en.html
https://rogerdudler.github.io/git-guide/index.de.html
https://www.atlassian.com/git/tutorials/setting-up-a-repository
