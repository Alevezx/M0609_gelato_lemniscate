Progetto universitario per la programmazione in Matlab di un cobot Doosan M0609.

TASK
Raccolta e consegna al cliente di un cono gelato, la traiettoria è interpolata a partire da un insieme di waypoint, come un polinomio di quinto grado tra due punti.
Il programma si sviluppa nel seguento modo:
- lettura dei waypoint
- cinematica inversa per calcolare le posizioni dei waypoint nello spazio dei giunti
- interpolazione punto a punto (velocità e accelerazioni iniziali e finali sono nulle per ridurre la complessità del codice)
- esecuzione di un tratto interpolato per volta

ESECUZIONE
Eseguire: task_animazione.mlx
Le simulazioni includono anche il modello URDF del robot.

Per creare i grafici di velocità e accelerazione del task eseguire test_velocita.m
