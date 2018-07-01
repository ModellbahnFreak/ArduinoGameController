# Arduino-Game-Controller
Ein (Schul-) Projekt, dessen Ziel die Erstellung eines PC-Spielecontrollers mit dem Arduino war.

## Nutzung und Aufbau
Um den Controller zu Nutzen, müssen folgende Schritte befolg werden:
1. [Schaltplan](Bilder/Schaltplan/ControllerEndgültig_Steckplatine.png) öffnen ([Bilder/Schaltplan](Bilder/Schaltplan/ControllerEndgültig_Steckplatine.png)) und Hardware entsprechend aufbauen.
2. [Arduino-Code](Arduino/Controller_Steuerung/Controller_Steuerung.ino) herunterladen und mit der [Arduino IDE](https://www.arduino.cc/en/Main/Software) öffnen
3. Arduino-Code kompilieren und auf den Arduino hochladen
4. [Processing-Sketch](Processing/Spiele) herunterladen (ganzer Ordner) und mit [Processing](https://processing.org/download/) öffnen
5. U.U. in Zeile 1 im Processing Sketch (int serialPort = 1;) die Zahl anpassen, um den richtigen Serialport zu wählen
   - Einmal Sketch Starten
   - In Ausgabe Konsole Nummer des entspechenden Com-Ports nachlesen ([Nummer] "COMxy")
   - Nummer in Zeile 1 eintragen (1 ersetzen)
6. Arduino anschließen
7. Processing Sketch Starten

## Hinweise
- Die Autoren des Projekts übernehmen keinerlei Hauftung u.ä. für durch die Nutzung oder den Missbrauch des Projekts entstandene Schäden.
- Alle Dateien dieses Projekts sind zur privaten Nutzung freigegeben.
- Jegliche Weiterverbreitung, Veränderung und kommerzielle Nutzung ist untersagt.
- Alle Teile des Projekts sind noch in Entwicklung. Folglich können an allen Stellen noch unerwartete Fehler aufteten. Selbst wenn eine Version als "funktionierend" gekennzeichnet ist, so wurde dies lediglich auf dem Enwicklungssystem getestet und gilt dies nicht zwingend für andere Systeme.
