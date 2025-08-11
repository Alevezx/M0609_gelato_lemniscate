Progetto universitario per la programmazione in Matlab di un cobot Doosan M0609.

Istruzioni di compilazione file Matlab.

Le funzioni sono suddivise in 3 cartelle per semplificare la comprensione delle diverse fasi del progetto.
Per agevolare il controllo sulla validità delle funzioni si consiglia di eseguire i file sotto elencati, 
i quali racchiudono le chiamate alle funzioni essenziali per il calcolo dei risultati. 
All'interno di ogni cartella sono comunque riportate tutte le sotto-funzioni necessarie.

1. Cinematica
Contiene le funzioni per il calcolo della cinematica diretta e inversa, compresa la verifica "diretta-inversa-diretta"

Eseguire: cinematica_test.mlx

2. Lemniscata
Contiene le funzioni per eseguire la traiettoria secondo la funzione della lemniscata di Gerono. 
Per questo task le simulazioni includono anche il modello URDF del robot.

Eseguire: lemniscata_test.mlx

Esempi di parametri da inserire per lemniscata di gerono:
    |  a  |  h  |  d_x  |  d_y  | theta_x | theta_y |
-----------------------------------------------------
 1  | 0.3 | 0.4 |  0.3  | -0.2  |    0    |   0.4   |
 2  | 0.5 |  0  |   0   |  0.34 |    0    |    0    |
 3  | 0.2 | 0.4 | -0.35 |  0.2  |   0.5   |    0    |

3. Task
Contiene le funzioni per eseguire il task della distribuzione del gelato. 
Le simulazioni includono anche il modello URDF del robot.

Eseguire: task_animazione.mlx

Per creare i grafici di velocità e accelerazione del task eseguire test_velocita.m
Nel caso della lemniscata questi vengono generati per l'intera traiettoria in modo automatico
all'interno della funzione lemniscata_gerono_robot.m grazie alle rispettive funzioni
calcolo_pos.m, calcolo_vel.m, calcolo_acc.m.
