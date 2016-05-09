!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!!!!!!!!!!																			     	   	  !!!!!!!!!!
!!!!!!!!!!  WICHTIG: Die Dateien in diesem Dropboxordner nicht direkt �ndern! Immer Git benutzen  !!!!!!!!!!
!!!!!!!!!!																			              !!!!!!!!!!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

ALLGEMEINER WORKFLOW:
Git nutzt drei verschiedene Ebenen:
1) ORIGIN				# Die globale Master-Version die in der Dropbox liegt und NIEMALS direkt bearbeitet wird.
2) Stage				# Lokale Zwischenstufe, in der die lokale Historisierung einer Datei hinterlegt ist 
						# (eine Version f�r jedes git commit).
3) Working Directory 	# Lokale Arbeitskopie, welche die echten Dateien enth�lt, an denen gearbeitet wird.

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

- Irgendwo AU�ERHALB der Dropbox (am besten im Projektordner von OMNeT++) die Git bash �ffnen.
- Lokale Version vom Repository anlegen:
	git clone  ~/Dropbox/OMNeT_Git						# Richtigen Dropbox-Pfad w�hlen!
	
### Jetzt k�nnt ihr die Dateien am LOKALEN Speicherort bearbeiten und �ndern:
- In den geklonten Ordner wechseln:
	cd OMNeT_Git
- �nderungen von ORIGIN (Dropbox) herunterladen und mit lokalen �nderungen zusammenf�hren (merge);
  immer ausf�hren, falls jemand anderes �nderungen hochgeladen (pushed) hat:
	git pull											# Bei dem Fehler: "fatal: Not a git repository" 
														# seid ihr nicht im richtigen Ordner.
- Eigene �nderungen an Dateien hochladen:
	git add <filename> 									# Richtigen Pfad und Namen aller neuen 
														# und ge�nderten Dateien w�hlen.
	git commit -m "Dies und das habe ich ge�ndert"		# �nderungen aus dem Working Directory ins Stage, 
														# mit Kommentar der �nderungen.
	git push origin master								# Push von Stage ins Remote Directory (ORIGIN / Dropbox).
- Wenn ihr mal etwas in der lokalen Kopie kaputt gemacht habt und zu der letzten commit-Version 
  (vom Server/Dropbox) zur�ck wollt:
	git checkout --<filename>							# �nderungen dieser Datei in der Working Directory 
														# werden �berschrieben, aber �nderungen des Stage 
														# bleiben erhalten.
  # ODER
	git fetch origin
	git reset --hard origin/master						# Harter reset auf den Stand in der Dropbox, 
														# �nderungen in der Working Directory und Stage 
														# werden �berschrieben.


Weitere Tutorials und Hilfen:
http://marklodato.github.io/visual-git-guide/index-en.html
https://rogerdudler.github.io/git-guide/index.de.html
https://www.atlassian.com/git/tutorials/setting-up-a-repository
