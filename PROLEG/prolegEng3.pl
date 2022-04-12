:- encoding(utf8).
:- discontiguous (<=)/2. 
:- discontiguous fact/1.
:- discontiguous exception/2.

:- op(1100, xfx, user:(<=)).    
:- dynamic (<=)/2. 
:- dynamic fact/1.
:- dynamic exception/2.
:- dynamic message/1.
:- set_prolog_flag(print_write_options, [portray(true), quoted(false), numbervars(true)]).

r :- reconsult(prolegEng3).

answer(X):-
       solve(0,X).
    
messageon :- abolish(message/1),assert(message(on)).
messageoff :- abolish(messaeg/1),assert(message(off)).

message(on).
    
print_message(_,_,_):-message(off),!.
print_message(I,(P<=Q),M):-message(on),!,
    print_rule(I,(P<=Q)),print(' '),
    print(M),nl.
print_message(I,no_counter_argument(Rel),_):-message(on),!,
    tab(I),print('No Exception:'), print(Rel),nl.
print_message(I,Q,M):-message(on),!,
    tab(I),print(Q),print(' '),print(M),nl.
    
print_rule(I,(P<=Q)):-!,
    tab(I),
    print(P),print('<='),nl,
    I2 is I + 2,	      
    print_body(I2,Q).

print_body(I,(B1,B)):-!,
    tab(I),print(B1),print(','),nl,	      
    print_body(I,B).
print_body(I,B1):-!,
    tab(I),print(B1).

solve(I,(Goal,RestGoal)):-!,
    solve(I,Goal), solve(I,RestGoal).
solve(_,call(P)):-
    !,
    call(P).
solve(I,Goal):-
    I2 is I + 2,
    is_fact(Goal),!,
    fact_check(I2,Goal).
solve(I,Goal):-
    I2 is I + 2,
    print_message(I2,'Starting to prove:',Goal),fail.
solve(I,Goal):-
%     print_message(I,(Goal <= Body),'is now checked.'),
    (Goal <= Body),
    I2 is I + 2,
    print_message(I2,(Goal <= Body),'found.'),
    solve(I2,Body),
    print_message(I2,Goal,'succeeded.'),
    print_message(I2,'Exception check for',Goal),
    \+ counter_argument(I2,Goal),
    print_message(I2,'No Exception for',Goal),
    print_message(I2,no_counter_argument(Goal),'succeeded.').
solve(I,Goal):-
    I2 is I + 2,
    print_message(I2,'Failed to prove',Goal),!,fail.

fact_check(I2,Goal):-
    fact(Goal),print_message(I2,fact(Goal),'found.').
fact_check(I2,Goal):-
    print_message(I2,fact(Goal),'not found/found no more.'),!,fail.

counter_argument(I,Goal):-
    exception(Goal,Exc),
    print_message(I,'Try to deny',Exc),
    solve(I,Exc),!,
    print_message(I,'Failed to deny',Exc).

is_fact(P):-
   \+ (P<=_).
