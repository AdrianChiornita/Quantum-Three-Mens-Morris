% Quantum Three Men's Morris

% Se propune o variantă cuantică a jocului "Three Men's Morris", joc
% în care doi adversari plasează și apoi mută câte trei piese pe o
% tablă cu 3x3 celule. Un jucător va avea trei piese albe, iar cel
% de-al doilea trei piese negre. Scopul fiecăruia este de a-și aranja
% piesele pe aceeași linie, pe aceeași coloană sau pe aceeași
% diagonală.
%
%  (1,1) -- (1,2) -- (1,3)
%    |    \   |    /   |
%    |     \  |   /    |
%  (2,1) -- (2,2) -- (2,3)
%    |     /  |   \    |
%    |    /   |    \   |
%  (3,1) -- (3,2) -- (3,3)
%
% Pe tablă sunt 9 celule.
%
% Jocul are două etape:
%
%  i. Plasarea pieselor
%
%     Alternativ, fiecare jucător va plasa câte o piesă în stare
%     cuantică pe tablă. Asta presupune alegerea a două celule în care
%     NU se află o piesă în stare clasică. Cele două celule vor deveni
%     legate la nivel cuantic (eng. entangled).
%
%     Atunci când se construiește un ciclu de celule legate cuantic
%     (entangled) jucătorul următor (nu cel care a creat ciclul) va
%     "măsura" ("observa") poziția ultimei piese plasate pe tablă (cea
%     care închis ciclul) și va alege în care dintre cele două celule
%     va rămâne aceasta. Observarea unei poziții duce la colapsarea
%     întregii componente a grafului din care face parte ciclul.
%
%     Etapa de plasare a pieselor se va termina atunci când fiecare
%     dintre cei doi jucători are câte trei piese indiferent în ce
%     stare.  (Se poate produce un ciclu în această etapă sau nu.)
%
% ii. Mutarea pieselor
%
%     Alternativ, fiecare jucător alege o piesă pe care să o mute
%     într-o celulă liberă (în care nu se află o piesă în stare
%     clasică). Dacă piesa se află în stare cuantică, atunci ambele
%     celule posibile se vor schimba. Dacă piesa se alfă în stare
%     clasică, atunci se va indica o pereche de celule vecine, iar
%     piesa va ajunge într-o stare cuantică. Efectul unei mutări lasă
%     piesa mutată în stare cuantică, iar cele două celule posibile
%     sunt, desigur, legate la nivel cuantic.
%
%     Atunci când se construiește un ciclu de celule legate cuantic
%     jucătorul următor (nu cel care a creat ciclul) va "măsura"
%     poziția ultimei piese mutate (cea care a închis ciclul) și va
%     alege în care dintre cele două celule posibile va rămâne
%     aceasta. Observarea unei poziții poate duce la observarea
%     pozițiilor mai multor piese.
%
%     Jocul se încheie atunci când cel puțin unul dintre jucători are
%     trei piese în stare clasică pe aceeași linie, coloană sau
%     diagonală.
%
% Reprezentări folosite:
%
%  - O celulă va fi reprezentată printr-un tuplu pos(X,Y) unde X,Y
%    sunt 1, 2 sau 3.
%
%  - O piesă va fi reprezentată diferit în funcție de starea ei:
%     classic/2   e.g.  classic(pos(2,2), white)
%     quantum/3   e.g.  quantum(pos(1,2), pos(3,1), black)
%
%  - O stare va fi o listă de piese (maximum șase)
%     e.g.: [classic(pos(2,2), white), classic(pos(1,5), black),
%            quantum(pos(1,3), pos(2,3), white)]

% ----------------------------------------------------------------------

% Rezolvați pe rând cerințele de mai jos!

% [Cerința 1] Să se scrie predicatul next_player/2 care descrie
% alternanța culorilor jucătorilor. black îi urmează lui white, iar
% white îi urmează lui black.

% next_player/2
% next_player(?Color1, ?Color2)
next_player(white, black).
next_player(black, white).

% ----------------------------------------------------------------------

% [Cerința 2] Scrieți un predicat cell(?Cell) care să fie adevărat
% pentru atunci când Cell este o structură pos(X,Y) reprezentând o
% celulă de pe tablă.

% cell/1
% cell(?Cell)
cell(pos(X,Y)) :- member(X, [1,2,3]), member(Y, [1,2,3]).

% ----------------------------------------------------------------------

% [Cerința 3] Scrieți un predicat valid_pairs(+State, +Color, -Pairs)
% care să descrie legătura dintre starea State și toate perechile de
% celule în care jucătorul Color ar putea așeza o piesă în stare
% cuantică. Celulele ocupate de piese în stare clasică nu reprezintă
% soluții valide. De asemenea, nici perechile de celule deja legate
% cuantic de o piesă a aceluiași jucător nu reprezintă perchi valide.
% Lista Pairs trebuie să NU conțină și o pereche și inversa ei.

% valid_pairs/3
% valid_pairs(+State, +Color, -Pairs)
valid_pairs(State, Color, Pairs) :- findall((X,Y), (cell(X), cell(Y), X @< Y), L), 
                                    findall( (P1,P2), (member((P1, P2), L),
                                                    \+ member(classic(P1, _), State),
                                                    \+ member(classic(P2, _), State),
                                                    \+ member(quantum(P1, P2, Color), State)
                                                    ), Pairs).

% ----------------------------------------------------------------------

% Cerința 4. Scrieți un predicat valid_moves(+State, +Color, -Moves)
% care leagă variabila Moves la lista tuturor mutărilor pe care le
% poate face jucătorul Color. O mutare poate fi de două feluri:
%
%  move(classic(pos(1,2), white), quantum(pos(1,3), pos(2,1), white))
%     sau
%  move(quantum(pos(3,3), pos(1,1), white),
%       quantum(pos(1,3), pos(2,1), white))


% valid_moves/3
% valid_moves(+State, +Color, -Moves)
valid_moves(State, Color, Moves) :- valid_pairs(State, Color, Pairs),
                                    findall(move(classic(P, Color), quantum(X, Y, Color)), 
                                                (member(classic(P, Color), State), 
                                                member((X, Y), Pairs)
                                                ), L1),
                                    findall(move(quantum(P1, P2, Color), quantum(X, Y, Color)),
                                                (member(quantum(P1, P2, Color), State),
                                                member((X, Y), Pairs),
                                                X \= P1,
                                                Y \= P1,
                                                X \= P2,
                                                Y \= P2), 
                                                L2),
                                    append([L1, L2], Moves).
                                    
% ----------------------------------------------------------------------

% Cerința 5. Scrieți un predicat winner(+State, -Winner) care produce
% legarea variabilei Winner la lista jucătorilor care au cele trei
% piese în stare clasică aliniate. Dacă nimeni nu a câștigat, winner
% eșuează (nu leagă Winner la lista vidă).


% winner/2
% winner(+State, -Colors)
winner(State, Colors) :- findall(Color, (member(Color, [white, black]),
                                 (   
                                    (member(Index, [1, 2, 3]),
                                    findall(pos(Index, X), 
                                            member(classic(pos(Index, X), Color), State), 
                                            [_, _, _])
                                    );
                                    (member(Index, [1, 2, 3]),
                                    findall(pos(X, Index), 
                                            member(classic(pos(X, Index), Color), State), 
                                            [_, _, _]));
                                    findall(pos(X, X), 
                                            member(classic(pos(X, X), Color) , State), 
                                            [_, _, _]);
                                    findall(pos(X, Y), 
                                            (member(classic(pos(X, Y), Color) , State), 
                                            Y is 4 - X), 
                                            [_, _, _])
                                )), Colors), Colors \= [].

% ----------------------------------------------------------------------
% Cerința 6. Se cere scrierea unui predicat has_cycle(+State) care să
% fie adevărat dacă starea repsectivă conține un ciclu de celule
% legate cuantic.
%
% has_cycle([quantum(pos(1,1), pos(3,2), white),
%            quantum((2,1), (3,2), black),
%            quantum(pos(1,1), pos(2,1), white)])
%   => true.
%
% has_cycle([quantum(pos(1,1), pos(3,2), black),
%            quantum(pos(3,1), pos(3,2), white)])
%   => false.

% edge/4
% edge(+State, +POS1, +POS2, -Color)
edge(State, X, Y, Color) :- member(quantum(X, Y, Color), State); 
                     member(quantum(Y, X, Color), State).


% detectcycle/4
% detectcycle(+Current, +Parent, ?Visited, +State)
detectcycle(Current, Parent, V, State) :- 
    edge(State, Current, Neigh, Color), 
    (Neigh \= Parent ; (Neigh = Parent),
                        edge(State, Current, Neigh, X),
                        next_player(Color,X)
    ),
    (member(Neigh, V) -> !, true; detectcycle(Neigh, Current, [Neigh | V], State)).


% has_cycle/1
% has_cycle(+State)
has_cycle(State) :- edge(State, X, _, _), detectcycle(X, X, [X], State), !.

% ----------------------------------------------------------------------

% Cerința 7. Se cere scrierea unui predicat collapse(+State, +Piece,
% +Cell, -NewState) care să producă starea obținută prin "măsurarea"
% piesei Piece în celula Cell. Starea NewState este rezulatul
% colapsării stării State. Piece este garantat un membru al lui State.


% quantumsfrom/4
% quantumsfrom(+State, +Cell, +Piece, -List)
quantumsfrom(State, Cell, Piece, List) :- 
    findall((quantum(Cell, X, Color), X), 
                (member(quantum(Cell, X, Color), State), 
                quantum(Cell, X, Color) \= Piece), 
            List1),
    findall((quantum(X, Cell, Color),X), 
                (member(quantum(X, Cell, Color), State), 
                quantum(X, Cell, Color) \= Piece), 
            List2),
    append([List1, List2], List).


recursive_collapse(State, [], State).

% recursive_collapse/3
% recursive_collapse(+State, +NextPieces, -NewState)
recursive_collapse(State, [(NextPiece, NextCell) | NextPieces], NewState) :-
    collapse(State, NextPiece, NextCell, IntermediateState),
    recursive_collapse(IntermediateState, NextPieces, NewState).

% collapse/4
% collapse(+State, +Piece, +Cell, -NewState)
collapse(State, quantum(X, Y, Color), Cell, NewState) :- 
    quantumsfrom(State, Cell, quantum(X, Y, Color), NextPieces),
    delete(State, quantum(X, Y, Color), L),      
    append(L, [classic(Cell, Color)], IntermediateState),
    recursive_collapse(IntermediateState, NextPieces, NewState).

% ----------------------------------------------------------------------
% ----------------------------------------------------------------------


% Un jucător trebuie să definească trei strategii:
%
%   - alegerea unei perechi de celule neocupate în care să plaseze
%     următoarea piesă (în etapa de plasare a pieselor)
%
%        place(+State, +Color, +Step, +ValidPairs, -Pair)
%
%   - alegerea unei mutări
%
%        move(+State, +Color, +Step, +ValidMoves, -Move)
%
%   - observarea unei piese într-una din cele două poziții posibile
%
%        measure(+State, +Color, +Step, +Piece, -Cell)
%
%   În toate cele trei cazuri, State reprezintă starea curentă a
%   jocului, Color culoarea jucătorului curent, iar Step numărul
%   mutării (important deoarece jocul se termină după maximum 50 de
%   mutări).
%
%
% Mai jos este descris un jucător cu strategii aleatoare.

rand_place(_State, _Color, _Step, ValidPairs, (Cell1, Cell2)):-
    random_member((Cell1, Cell2), ValidPairs), !.

rand_measure(_State, _Color, _Step, Piece, Cell):-
    Piece = quantum(Cell1, Cell2, _LastColor),
    random_member(Cell, [Cell1, Cell2]), !.

rand_move(_State, _Color, _Step, ValidMoves, Move):-
    random_member(Move, ValidMoves), !.

% ----------------------------------------------------------------------

% [Cerința 8] Definiți strategiile pentru un jucător care să câștige în
% medie mai mult de 80% dintre jocur împotriva jucătorul random.

     
smart_place(_State, _Color, _Step, ValidPairs, Pair):- 
    last(ValidPairs, Pair).

smart_measure(State, Color, Step, Piece, Cell):-
    rand_measure(State, Color, Step, Piece, Cell).

smart_move(_State, _Color, _Step, ValidMoves, Move):- 
    last(ValidMoves, Move).


% ----------------------------------------------------------------------

% [Bonus]. Definiți strategiile pentru un jucător care să câștige în
% medie mai mult de 95% dintre jocuri împotriva jucătorul random.


bonus_place(_State, _Color, _Step, ValidPairs, Pair):-
        last(ValidPairs, Pair).

bonus_measure(State, Color, Step, Piece, Cell):-
    rand_measure(State, Color, Step, Piece, Cell).

bonus_move(_State, _Color, _Step, ValidMoves, Move):-
        last(ValidMoves, Move).


% aleg ultima miscare/asezare posibilia din din validmoves/validpairs
% cautand sa faca o miscare de maestru ca in exemplul de joc din tema
% (sa pozitioneze intr-un ciclu piesele) si alegerea ultimei pozitii
% ofera rezultatul dorit datorita ordonarii crescatoare din validpairs
% ----------------------------------------------------------------------
% ----------------------------------------------------------------------

% verbose.  %% Comentați linia aceasta pentru a vedea evoluția jocurilor.
verbose:- fail.

play(Player1, Player2, State, Color, Step, LastPiece, Winner):-
    Player1 = (PPlace, PMeasure, PMove),
    ( verbose -> format('-------------------- Pas [~w]~n', [Step]),
      format('Apel has_cycle(~w)...~n', [State]); true ),
    ( has_cycle(State) ->
      ( verbose -> format('Apel ~w(~w, ~w, ~w, ~w, Cell)...~n',
	       [PMeasure, State, Color, Step, LastPiece]) ; true ),
      ( call(PMeasure, State, Color, Step, LastPiece, Cell) ->
	( verbose -> format('Apel collapse(~w, ~w, ~w, NoCycle)...~n',
		 [State, LastPiece, Cell]); true ),
        ( collapse(State, LastPiece, Cell, NoCycle) ->
	  true
	; format('collapse(~w, ~w, ~w, NoCycle) a eșuat.~n',
		 [State, LastPiece, Cell]),
	  !, fail)
      ; format('~w(~w, ~w, ~w, ~w, Cell) a eșuat.~n',
	       [PMeasure, State, Color, Step, LastPiece]),
	!, fail)
    ; NoCycle = State),
    ( winner(NoCycle, Winner), !
    ; Step =:= 50, !, Winner = [white, black],
      (   verbose -> format('Am ajuns la pasul 50.~n'); true )
    ; ( length(NoCycle, 6) ->
	( verbose -> format('Apel valid_moves(~w, ~w, ValidMoves).~n',
		 [NoCycle, Color]); true ),
        ( valid_moves(NoCycle, Color, ValidMoves)->
	  ( verbose -> format('Apel ~w(~w, ~w, ~w, ~w, Move)...~n',
		   [PMove, NoCycle, Color, Step, ValidMoves]); true ),
          ( call(PMove, NoCycle, Color, Step, ValidMoves, Move) ->
	    Move = move(OldPiece, NewPiece),
	    select(OldPiece, NoCycle, NewPiece, NextState), !
	  ; format('~w(~w, ~w, ~w, ~w, Move) a eșuat.~n',
		   [PMove, NoCycle, Color, Step, ValidMoves]),
	    !, fail)
	; format('valid_moves(~w, ~w, ValidMoves) a eșuat.~n',
		 [NoCycle, Color]),
	  !, fail)
      ; (verbose -> format('Apel valid_pairs(~w, ~w, ValidPairs)...~n',
                               [NoCycle, Color]); true),
        ( valid_pairs(NoCycle, Color, ValidPairs) ->
          ( verbose -> format('Apel ~w(~w, ~w, ~w, ~w, (Cell1, Cell2)).~n',
		   [PPlace, NoCycle, Color, Step, ValidPairs]); true),
	  ( call(PPlace, NoCycle, Color, Step, ValidPairs, (Cell1, Cell2)) ->
	    NewPiece = quantum(Cell1, Cell2, Color),
	    NextState = [NewPiece | NoCycle], !
	  ; format('~w(~w, ~w, ~w, ~w, (Cell1, Cell2)) a eșuat.~n',
		   [PPlace, NoCycle, Color, Step]),
	    !, fail)
	; format('valid_pairs(~w, ~w, ValidPairs) a eșuat.~n', [NoCycle, Color]),
	  !, fail) ),
      next_player(Color, NextColor), Step1 is Step + 1, !,
      play(Player2, Player1, NextState, NextColor, Step1, NewPiece, Winner) ).


play_against_random(Strategy, Winner):-
    %% Player is black, Rand is white
    Player = (Strategy, black),
    Random = ((rand_place, rand_measure, rand_move), white),
    random_permutation([Player, Random], [(Player1, Color1),(Player2, _)]),
    play(Player1, Player2, [], Color1, 0, none, Winner).


score_against_random(Strategy, Score):-
    score_against_random(Strategy, 1000, 0, 0, 0, WinsNo, DrawsNo, LosesNo),
    format(' Black: ~d, Draws: ~d, White: ~d. ', [WinsNo, DrawsNo, LosesNo]),
    Score is WinsNo / 1000.0.

score_against_random(_, 0, B, D, W, B, D, W):- !.
score_against_random(Strategy, N1, B1, D1, W1, B, D, W):-
    play_against_random(Strategy, Winner),
    (Winner = [black] -> B2 is B1 + 1 ; B2 = B1),
    (Winner = [white] -> W2 is W1 + 1 ; W2 = W1),
    (Winner = [_, _] -> D2 is D1 + 1 ; D2 = D1),
    N2 is N1 - 1,
    ( verbose ->
      format('>>>>>>>>>>> Mai sunt de jucat ~w jocuri. Strategia a câștigat ~w jocuri, Random ~w jocuri, ~w remize. ~n',
	     [N2, B2, W2, D2])
    ; true ),
    score_against_random(Strategy, N2, B2, D2, W2, B, D, W).
