# Evolvania

nella cartella actors'è la logica dei personaggi. Nella scena Hero puoi vedere che ogni personaggio ha oltre al nodo sulla collision shape e lo sprite anche lo StateMachine.

I Nodi li' dentro sono gli stati possibili.
La scena pickup.tscn è il powerup. Se ad attraversarlo è il player (gruppo per la scena/nodo dell'actor) allora attiva la `add_state` che aggiunge un nuovo nodo (stato) allo state_machine del player. La logica sta tutto dentro i file del folder state_machine/states.
I pickup nodes devono chiamarsi ESATTAMENTE come il nome dello stato (nonchè il `file.gd`).

Ci sono alcuni bug ... ma dovrebbe andar bene.
Se non vogliamo far fare una cosa a uno dei personaggi, il nodo di quello stato, non deve essere presente nel suo state_machine.
