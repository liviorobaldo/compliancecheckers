:- encoding(utf8).

:-dynamic indent/1.
:-dynamic proved/1.
:-dynamic allege/2.
:-dynamic admission/2.
:-dynamic plausible/2.
:-dynamic plausible/1.
:-dynamic producing_of_evidence/2.

:-dynamic fact/1.
:-dynamic nonfact/1.

:-dynamic exception/2.
:-dynamic exception/3.
:-dynamic debug_flag/1.
:-dynamic dummy/1.
:-dynamic is_a/2.
:-dynamic analyze_flag/1.
:-dynamic built_in_pred/1.
:-dynamic obvious_fact/1.
:-dynamic defendant/1.
:-dynamic plaintiff/1.
:-dynamic arg_info/1.
:- set_prolog_flag(print_write_options, [portray(true), quoted(false), numbervars(true)]).

:- op(480, xfy, user:(##)).        
:- op(480, xfy, user:(#)).    
:- op(1100, xfx, user:(<=)).
:- op(1050, xfy, user:(&)).

:- op(480, xfy, user:(year)).
:- op(460, xfy, user:(month)).
:- op(440, xf, user:(day)).

:- op(440, xf, user:(euro)).
:- op(440, xf, user:(thousand_euro)).
:- op(440, xf, user:(tenthousand_euro)).
:- op(440, xf, user:(million_euro)).

:- discontiguous allege/2.
:- discontiguous allege_cond/2.
:- discontiguous allege_all/2.
:- discontiguous producing_of_evidence/2.
:- discontiguous possible_evidence/1.
:- discontiguous possible_evidence_cond/1.
:- discontiguous prove/2.
:- discontiguous prove_cond/2.
:- discontiguous defense/2.
:- discontiguous exception/2.
:- discontiguous (<=)/2.
:- discontiguous possible_instance1/1.
:- discontiguous print_message/3.

allege(X,_):- fact(X).
producing_of_evidence(X,_):- fact(X).
plausible(X,_):- fact(X).
plausible(X):- fact(X).

allege(X,_):- nonfact(X).
producing_of_evidence(X,_):- nonfact(X).

r:-reconsult('prolegEng190804.pl').

analyze:-abolish(analyze_flag/1),assert(analyze_flag(on)).
noanalyze:-abolish(analyze_flag/1),assert(analyze_flag(off)).

verbosedebug:-abolish(debug_flag/1),assert(debug_flag(on)).
noverbosedebug:-abolish(debug_flag/1),assert(debug_flag(off)).

analyze_flag(off).
debug_flag(off).

debugprint(X):-
    (debug_flag(on) -> (print(X),nl,flush);true).
%%%%%%%%%%%%%%%%%%%%%%%%%%% For Debug %%%%%%%%%%%%%%%%%%%%%%%%%%%
allege_all(X,P):-
    debugprint(announcing(X,P)),
    fail.
allege_cond(Cond,P):-
    debugprint(allege_cond(Cond,P)),
    fail.
possible_evidence(X):-
    debugprint(possible_evidence(X)),
    fail.
possible_evidence_cond(X):-
    debugprint(possible_evidence_cond(X)),
    fail.
prove_cond(Cond,P):-
    debugprint(prove_cond(Cond,P)),
    fail.
% producing_of_evidence(X,P):-
%    degugprint(producing_of_evidence(X,P)),fail.
% plausible(X,P):-
%    debugprint(plausible(X,P)),fail.
% plausible(X):-
%    debugprint(plausible(X)),fail.

prove(X,P):-
    debugprint(proving(X,P)),
    fail.
defense(X,O):-
    debugprint(defense(X,O)),
    fail.
%%%%%%%%%%%%%%%%%%%%%%%%%%% For Debug %%%%%%%%%%%%%%%%%%%%%%%%%%%
% definition: built_in_predicates

before_the_day(Y1 year _ month _ day,Y2 year _ month _ day):-Y1<Y2,!.
before_the_day(Y year M1 month _ day,Y year M2 month _ day):-M1<M2,!.
before_the_day(X year M month D1 day,X year M month D2 day):-D1<D2,!.

same_day_or_before_the_day(Y1 year _ month _ day,Y2 year _ month _ day):-Y1<Y2,!.
same_day_or_before_the_day(Y year M1 month _ day,Y year M2 month _ day):-M1<M2,!.
same_day_or_before_the_day(X year M month D1 day,X year M month D2 day):-D1<D2,!.
same_day_or_before_the_day(X year M month D day,X year M month D day):-!.

after_the_day(Y1 year _ month _ day,Y2 year _ month _ day):-Y1>Y2,!.
after_the_day(Y year M1 month _ day,Y year M2 month _ day):-M1>M2,!.
after_the_day(X year M month D1 day,X year M month D2 day):-D1>D2,!.

same_day_or_after_the_day(Y1 year _ month _ day,Y2 year _ month _ day):-Y1>Y2,!.
same_day_or_after_the_day(Y year M1 month _ day,Y year M2 month _ day):-M1>M2,!.
same_day_or_after_the_day(X year M month D1 day,X year M month D2 day):-D1>D2,!.
same_day_or_after_the_day(X year M month D day,X year M month D day):-!.

nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=31, Y=1, Xn is X, Yn is Y + 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=28, Y=2, Xn is X, Yn is Y + 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=31, Y=3, Xn is X, Yn is Y + 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=30, Y=4, Xn is X, Yn is Y + 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=31, Y=5, Xn is X, Yn is Y + 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=30, Y=6, Xn is X, Yn is Y + 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=31, Y=7, Xn is X, Yn is Y + 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=31, Y=8, Xn is X, Yn is Y + 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=30, Y=9, Xn is X, Yn is Y + 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=31, Y=10, Xn is X, Yn is Y + 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=30, Y=11, Xn is X, Yn is Y + 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Z=31, Y=12, Xn is X + 1, Yn is 1, Zn is 1,!.
nextday(X year Y month Z day,Xn year Yn month Zn day):- Xn is X, Yn is Y, Zn is Z + 1,!.

euro_compare(P):- P=..[OP,X,Y], euro2num(X,NEX), NX is NEX, euro2num(Y,NEY), NY is NEY, NP=..[OP,NX,NY], call(NP).

euro2num(P,NP):- P =.. [OP,X,Y],!,euro2num(X,NX), euro2num(Y,NY), NP =.. [OP,NX,NY].
euro2num(X euro, NX) :-!, NX is X.
euro2num(X thousand_euro, NX) :-!, NX is X * 1000.
euro2num(X tenthousand_euro,NX) :-!, NX is X * 10000.
euro2num(X million_euro, NX) :-!, NX is X * 1000000.
euro2num(X,X) :- number(X),!.

% definition: built_in_predicates

print_message(obvious,X,_):-
       indent(N), N2 is N + 2, tab(N2),
       print_proc(X),
       print('is obvious.'),nl.

print_message(builtin,_,_):-
       !.

print_message(prolegcond,_,_):-
       !.

allege_all(X,_):-
       is_a(X,built_in_pred),!,call(X).
allege_all(proleg_cond(X),_):-
       !,call(X).

answer(X):-
       abolish(indent/1),assert(indent(0)),
       finddefendant(P), prove(X,P).

finddefendant(P):-defendant(P),!.
finddefendant(plaintiff).

findplaintiff(P):-plaintiff(P),!.
findplaintiff(defendant).

% prove(X=Y,P):-!,X=Y.
prove(X,P):-
        is_a(X,built_in_pred),!,
        call(X),
        print_message(builtin,X,P).

prove(proleg_cond(X),P):-
        !,
        call(X),
        print_message(prolegcond,X,P).

allege_all(X,_):-
          is_a(X,obvious_fact),!,allege(X,_),call(X).

% producing_of_evidence(X,P):-
%         is_a(X,obvious_fact),!.
prove(X,P):-
        is_a(X,obvious_fact),!,
        call(X),
        print_message(obvious,X,P).

% admission
prove(X,P):-
    is_a(X,prerequisite),
    debugprint(is_a(X,prerequisite)),
    opposite(P,O),
    admission(X,O),!,
    print_message(fact_admission,O,X).

prove(X,P):-
    is_a(X,prerequisite),
    debugprint(is_a(X,prerequisite)),
    print_message(fact_proof_start,P,X),
  (((plausible(X,_);plausible(X)),
    print_message(plausible_evidence,P,X))->
        print_message(fact_proof_success,P,X);(print_message(fact_proof_failure,P,X),!,fail)).

prove(X,P):-
    is_a(X,legal_effect),
    allegecheck(X,_),
    evidencecheck(X),
    prove_maincheck(X,P).

prove_maincheck(X,P):-
    print_message(rule_proof_start,P,X),
%     ground(X),
    prove_main(X,P),
    opposite(P,O),
    \+defense(X,O),!,
    print_message(rule_proof_success,P,X).
% prove_maincheck(X,P):-
%     \+ground(X),print('Error: '),print(X),print(' is not ground for maincheck.'),nl,!,fail.
prove_maincheck(X,P):-
    print_message(rule_proof_failure,P,X),!,fail.

print_message(show_rules,(X,Body),_):-!,
    indent(N),
     tab(N),
     print('To prove '), print_proc(X),
     ((Body=(Theory&Cond))->(print(', by'),print(Theory));(Cond=Body)),
     print(','),nl,tab(N),print('we need to prove the following requisites:'),nl,
%    tab(N), print_proc(X), print(if),
    nl,
    N4 is N+4,
    print_cond(N4,Cond,1),
%    tab(N), print(fi),
    nl.

print_cond(N,(Atom,Rest),CondNo):-is_a(Atom,builtin),\+(Atom=before_the_day(_,_)),!,
    print_cond(N,Rest,CondNo).
print_cond(N,(Atom,Rest),CondNo):-!,
    tab(N),print('requisite'),print(CondNo),print(': '),print(Atom),nl,CondNo1 is CondNo +1,
    print_cond(N,Rest,CondNo1).
print_cond(_,Atom,_):-is_a(Atom,builtin),\+(Atom=before_the_day(_,_)),!.
print_cond(N,Atom,CondNo):-!,
    tab(N),print('requisite'),print(CondNo),print(': '),print(Atom),nl.

allege_all(X,P):-
    is_a(X,legal_effect),!,
    (X<=Body),
    allege_cond(Body,P).
allege_all(X,P):-!,
    debugprint(checking(allegeoradmission(X,P))),
    (allege(X,P);admission(X,_)),
    debugprint(checked(allegeoradmission(X,P))).

allege_cond((Cond,Rest),_):-!,
    allege_all(Cond,_), allege_cond(Rest,_).
allege_cond(Cond,_):- % \+Cond=(_,_),!,
    debugprint(checking(allege(Cond,_))),
    allege_all(Cond,_).

allege_condcheck(X,_):-
    setof(X,allege_cond(X,_),L),!,
    debugprint(allegecondpossible_instance(L)),
    member(X,L).
allege_fail_analize(X,L):-
    is_a(X,legal_effect),!,
    (X<=Cond), allege_fail_analize_cond(Cond,[X|L]).
allege_fail_analize(X,L):-
    is_a(X,prerequisite),
    ((allege(X,_);admission(X,_))->true;(indent(N),N2 is N+2, tab(N2),print(allege(X,_)),print(' not found at '),print(L),nl,!,fail)).
allege_fail_analize(X,L):-
    is_a(X,built_in_pred),!,(call(X)->true;(indent(N),N2 is N+2, tab(N2),print(X),print(' fail at '),print(L),nl,!,fail)).
allege_fail_analize(proleg_cond(X),L):-
    !,(call(X)->true;(indent(N),N2 is N+2, tab(N2),print(X),print(' fail at '),print(L),nl,!,fail)).
allege_fail_analize(X,L):-
    is_a(X,obvious_fact),!,
    (allege(X,_)->
       (call(X)->true;(indent(N),N2 is N+2, tab(N2),print(X),print(' fail at '),print(L),nl,!,fail));
       (indent(N),N2 is N+2, tab(N2),print(allege(X,_)),print(' not found at '),print(L),nl,!,fail)).
allege_fail_analize_cond((Cond,Rest),L):-!,
    allege_fail_analize(Cond,L), allege_fail_analize_cond(Rest,L).
allege_fail_analize_cond(Cond,L):- % \+Cond=(_,_),!,
    allege_fail_analize(Cond,L).

possible_evidence(X):-
    is_a(X,legal_effect),!,
    (X<=Body),
    possible_evidence_cond(Body).
possible_evidence(X):-
    is_a(X,built_in_pred),!,call(X).
possible_evidence(proleg_cond(X)):-
    !,call(X).
possible_evidence(X):-
    is_a(X,obvious_fact),!,call(X).
possible_evidence(X):-
    is_a(X,prerequisite), admission(X,_),!.
possible_evidence(X):-
    is_a(X,prerequisite), producing_of_evidence(X,_).
% possible_evidence(X):-
%     is_a(X,prerequisite), plausible(X,_),!.
possible_evidence_cond((Cond,Rest)):-!,
    possible_evidence(Cond), possible_evidence_cond(Rest).
possible_evidence_cond(Cond):-!,
    possible_evidence(Cond).

possible_evidence_condcheck(Cond):-!,
    setof(Cond,possible_evidence_cond(Cond),L),
    debugprint(possible_evidence_condcheck(Cond,L)),
    member(Cond,L).

possible_evidence_fail_analize(X,L):-
    is_a(X,legal_effect),!,
    (X<=Cond), possible_evidence_fail_analize_cond(Cond,[X|L]).
possible_evidence_fail_analize(X,L):-
    is_a(X,prerequisite),
    ((producing_of_evidence(X,_);admission(X,_))->true;(indent(N),N2 is N+2, tab(N2),print(producing_of_evidence(X,_)),print(' not found at '),print(L),nl,!,fail)).
% 以下の2つのルールが適用されることは通常ないはず。懼ﾃｸﾕallege_fail_analyzeでfailしているはずだから
possible_evidence_fail_analize(X,L):-
    is_a(X,built_in_pred),!,(call(X)->true;(indent(N),N2 is N+2, tab(N2),print(X),print(' fail at '),print(L),nl,!,fail)).
possible_evidence_fail_analize(proleg_cond(X),L):-
    !,(call(X)->true;(indent(N),N2 is N+2, tab(N2),print(X),print(' fail at '),print(L),nl,!,fail)).
possible_evidence_fail_analize(X,L):-
    is_a(X,obvious_fact),!,(call(X)->true;(indent(N),N2 is N+2, tab(N2),print(X),print(' fail at '),print(L),nl,!,fail)).
possible_evidence_fail_analize_cond((Cond,Rest),L):-!,
    possible_evidence_fail_analize(Cond,L), possible_evidence_fail_analize_cond(Rest,L).
possible_evidence_fail_analize_cond(Cond,L):- % \+Cond=(_,_),!,
    possible_evidence_fail_analize(Cond,L).

prove_main(X,P):-
%     print(prove_main(X,P)),nl,
    (X<=Body),
    allege_condcheck(Body,P),
    possible_evidence_condcheck(Body),
    print_message(show_rules,(X,Body),P),
    prove_cond(Body,P).
prove_cond((Cond,Rest),P):-!,
    prove(Cond,P), prove_cond(Rest,P).
prove_cond(Cond,P):-!,
    prove(Cond,P).

defense(X,O):-
    exception(X,Defense),
    prove_exception(X,Defense,O).

prove_exception(E,X,O):-
%    print(prove_exception(E,X,O)),nl,
    allegecheck(X,_),
    evidencecheck(X),
    print_message(exception_start,O,E,X),
    prove_exceptioncheck(X,O,E).

% allegeでpossible ground instanceを見つける。
allegecheck(X,O):-
    setof(X,allege_all(X,O),L),!,
    debugprint(allegepossible_instance(X,L)),
    member(X,L).
allegecheck(X,_):-
    analyze_flag(on),allege_fail_analize(X,[]),!,fail.

evidencecheck(X):-
    setof(X,possible_evidence(X),L),!,
    debugprint(evidencecheck(X,L)),
    member(X,L).
evidencecheck(X):-
    analyze_flag(on),possible_evidence_fail_analize(X,[]),!,fail.

prove_exceptioncheck(X,O,C):-
%     ground(X),
    prove(X,O),print_message(exception_success,O,C,X),!.
% prove_exceptioncheck(X,O,C):-
%     \+ground(X),print('Error: '),print(X),print(' is not ground for exception.'),nl,!,fail.
prove_exceptioncheck(X,O,C):-
    print_message(exception_fail,O,C,X),!,fail.

inverse(-X,X):-!.
inverse(X,-X):-!.

opposite(X,Y):-finddefendant(X),findplaintiff(Y),!.
opposite(X,Y):-findplaintiff(X),finddefendant(Y),!.

print_message(fact_proof_start,P,X):-!,
    increment_indent(N2), tab(N2),
    print(P), print(' tried to prove '), print_proc(X), print('.'), nl.
print_message(fact_proof_success,P,X):-!,
    decrement_indent(N2), tab(N2),
    print(P), print(' successfully proved '), print_proc(X), print('.'), nl.
print_message(fact_proof_failure,P,X):-!,
    decrement_indent(N2), tab(N2),
    print(P),print(' failed to prove '),print_proc(X), print('.'), nl.

print_message(rule_proof_start,P,X):-
    increment_indent(N2), tab(N2),
    print(P), print(' tried to prove '), print_proc(X), print('.'), nl.
print_message(rule_proof_success,P,X):-
    decrement_indent(N2), tab(N2),
    print(P), print(' successfully proved '), print_proc(X), print('.'), nl.
print_message(rule_proof_failure,P,X):-
    decrement_indent(N2), tab(N2),
    print(P),print(' failed to prove '),print_proc(X), print('.'), nl.

print_message(plausible_evidence,_,X):-
    is_a(X,legal_effect)->
    true;
   (indent(N), N2 is N + 2, tab(N2),
    print_proc(X), print(' is over the stringent belief level.'),nl).

print_message(exception_start,O,E,X):-!,
    ((E=(C&Theory))->true;C=E),
    increment_indent(N2), tab(N2),
    print(O),print(' alleges '),print_proc(X),nl,tab(N2),
    print(' as a defense against '), print_proc(C),
    ((E=(C&Theory))->(print(' by '), print(Theory));true),
    print('.'),nl.
print_message(exception_success,O,C,X):-!,
    decrement_indent(N2), tab(N2),
    print(O), print(' successfully proved '),
    print_proc(X), nl,tab(N2),
    print(' as a defense against '),
    print_proc(C), print('.'),nl.
print_message(exception_fail,O,C,X):-!,
    decrement_indent(N2), tab(N2),
    print(O), print(' failed to prove '),
    print_proc(X),nl,tab(N2),
    print(' as a defense against '),
    print_proc(C), print('.'),nl.

print_message(alleged,X,P):-
    indent(N), N2 is N + 2, tab(N2),
    print(P), print(' alleges '), print_proc(X),nl,flush.
print_message(fact_admission,P,X):-!,
    indent(N), N2 is N + 2, tab(N2),
    print(P), print(' admitted '), print_proc(X),print('.'),nl.

increment_indent(N2):- 
    retract(indent(N)), N2 is N+2,
    assert(indent(N2)).  decrement_indent(N2):- retract(indent(N2)),
    N is N2-2, assert(indent(N)).

print_proc(-X):-print('"-'),print(X),print('"').
print_proc(X):- print('"'),print(X),print('"').

%%%%%%%%%%%%%%%%%%%%%%%%%%% For Debug %%%%%%%%%%%%%%%%%%%%%%%%%%%
% allege(P,X):-
%    debugprint(allege_fail(P,X)),!,fail.
possible_evidence(X):-
   debugprint(possible_evidence_fail(X)),!,fail.
prove_cond(Cond,P):-
   debugprint(prove_cond_fail(Cond,P)),!,fail.
% producing_of_evidence(X,P,A):-
%    debugprint(evidence_fail(X,P,A)),!,fail.
% prove(X,P):-
%    debugprint(prove_fail(X,P)),!,fail.
%%%%%%%%%%%%%%%%%%%%%%%%%%% For Debug %%%%%%%%%%%%%%%%%%%%%%%%%%%
copy(X,Y):-
  assert(dummy(X)),
  retract(dummy(Y)).

%%%%%%%%%%%%%%%%%%%%%%%%%%% Class Knowledge %%%%%%%%%%%%%%%%%%%%%
% General Knowledge

is_a(X,legal_effect):-copy(X,Y),(Y<=_),!.
is_a(before_the_day(_,_),built_in_pred):-!.
is_a(same_day_or_before_the_day(_,_),built_in_pred):-!.
is_a(after_the_day(_,_),built_in_pred):-!.
is_a(same_day_or_after_the_day(_,_),built_in_pred):-!.
is_a(nextday(_,_),built_in_pred):-!.
is_a(not(_),built_in_pred):-!.
is_a(call(_),built_in_pred):-!.
is_a(euro_compare(_),built_in_pred):-!.
is_a(_=_,built_in_pred):-!.
is_a(_ is _,built_in_pred):-!.
is_a(print(_),built_in_pred):-!.
is_a(nl,built_in_pred):-!.
is_a(X,built_in_pred):-built_in_pred(X),!.
is_a(X,obvious_fact):-obvious_fact(X),!.
is_a(X,prerequisite):- \+(is_a(X,legal_effect);is_a(X,built_in_pred);is_a(X,obvious_fact)),!.

append([],X,X):-!.
append([X|Y],W,[X|Z]):-
  !,
  append(Y,W,Z).

newsetof(X,G,XL):-!,
  (setof(X,G,XL)->true;XL=[]).

