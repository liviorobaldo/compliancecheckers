%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_0 to evaluate the product only with a licence; otherwise, it is prohibited_0.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_0 for the licencee to evaluate the product

prohibited_0(Ev) <= evaluate_f_0(Ev), hasAgent_f_0(Ev,X), licensee_f_0(X), hasTheme_f_0(Ev,P), product_f_0(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_0. Art.1b is an exception of Art1.a.
permitted_0(Ev) <= evaluate_f_0(Ev), hasAgent_f_0(Ev,X), licensee_f_0(X), hasTheme_f_0(Ev,P), product_f_0(P), isLicenceOf_f_0(L,P), licence_f_0(L), grant_f_0(Eg), rexist_f_0(Eg), hasTheme_f_0(Eg,L), hasAgent_f_0(Eg,Y), licensor_f_0(Y), hasReceiver_f_0(Eg,X).

exception(prohibited_0(Ev), permitted_0(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_0 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_0. If the licencee publish the results of the evaluation 
% even if this was prohibited_0, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_0 for the licencee to publish the results of the evaluation of the product
prohibited_0(Ep) <= condition_2_0(Ep,X,R).
condition_2_0(Ep,X,R) <= publish_f_0(Ep), hasAgent_f_0(Ep,X), licensee_f_0(X), hasTheme_f_0(Ep,R), result_f_0(R), hasResult_f_0(Ev,R), evaluate_f_0(Ev), rexist_f_0(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_0. Art.2b is an exception of Art2.a.
permitted_0(Ep) <= publish_f_0(Ep), hasAgent_f_0(Ep,X), licensee_f_0(X), hasTheme_f_0(Ep,R), result_f_0(R), hasResult_f_0(Ev,R), evaluate_f_0(Ev), rexist_f_0(Ev), approve_f_0(Ea), rexist_f_0(Ea), hasTheme_f_0(Ea,Ep), licensor_f_0(Y), hasAgent_f_0(Ea,Y).

exception(condition_2_0(Ep,X,R),permitted_0(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_0 to do so, he is obliged to remove them. The removal compensate_0s the violation_0 of the prohibition.
obligatory_0(ca(Ep,X,R)) <= rexist_f_0(Ep), condition_2_0(Ep,X,R).
remove_0(ca(Ep,X,R)) <= rexist_f_0(Ep), condition_2_0(Ep,X,R).
hasTheme_0(ca(Ep,X,R),R) <= rexist_f_0(Ep), condition_2_0(Ep,X,R).
hasAgent_0(ca(Ep,X,R),X) <= rexist_f_0(Ep), condition_2_0(Ep,X,R).
compensate_0(ca(Ep,X,R),Ep) <= rexist_f_0(Ep), condition_2_0(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_0 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_0.
prohibited_0(Ep) <= publish_f_0(Ep), hasAgent_f_0(Ep,X), licensee_f_0(X), hasTheme_f_0(Ep,C), comment_f_0(C), evaluate_f_0(Ev), rexist_f_0(Ev), isCommentOf_f_0(C,Ev).

% Art.3b: if publishing the result is permitted_0, also publishing the comments is permitted_0; this overrides the above prohibition.
permitted_0(Ep) <= publish_f_0(Ep), hasAgent_f_0(Ep,X), licensee_f_0(X), hasTheme_f_0(Ep,C), comment_f_0(C), isCommentOf_f_0(C,Ev), evaluate_f_0(Ev), rexist_f_0(Ev), hasResult_f_0(Ev,R), publish_f_0(Epr), hasAgent_f_0(Epr,X), hasTheme_f_0(Epr,R), permitted_0(Epr).

exception(prohibited_0(Ep),permitted_0(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_0. Art.4a is an exception of Art2.a.

obligatory_0(Ep) <= publish_f_0(Ep), hasAgent_f_0(Ep,X), licensee_f_0(X), hasTheme_f_0(Ep,R), result_f_0(R), hasResult_f_0(Ev,R), evaluate_f_0(Ev), rexist_f_0(Ev), commission_f_0(Ec), rexist_f_0(Ec), hasTheme_f_0(Ec,Ev).
exception(condition_2_0(Ep,X,R),obligatory_0(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_0 action x and, at the same time, x does not really exist => violation_0; 
%(2) if there is some prohibited_0 action x and, at the same time, x really exists => violation_0

rexist_0(ca(Ep,X,R)) <= remove_0(ca(Ep,X,R)), hasAgent_0(ca(Ep,X,R),X), hasTheme_0(ca(Ep,X,R),R), rexist_f_0(Er), remove_f_0(Er), hasTheme_f_0(Er,R), hasAgent_f_0(Er,X).

violation_0(viol(X)) <= obligatory_0(X).
-violation_0(viol(X)) <= obligatory_0(X), rexist_0(X).
exception(violation_0(X),-violation_0(X)).

violation_0(viol(X)) <= prohibited_0(X), rexist_0(X).

referTo_0(viol(X),X) <= violation_0(viol(X)).

compensate_0d_0(X) <= compensate_0(Y,X), rexist_0(Y).
exception(violation_0(viol(X)),compensate_0d_0(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_0(X) <= rexist_f_0(X).
licensee_0(X) <= licensee_f_0(X).
licensor_0(X) <= licensor_f_0(X).
product_0(X) <= product_f_0(X).
result_0(X) <= result_f_0(X).
licence_0(X) <= licence_f_0(X).
comment_0(X) <= comment_f_0(X).
isLicenceOf_0(X,Y) <= isLicenceOf_f_0(X,Y).
                
approve_0(X) <= approve_f_0(X).
commission_0(X) <= commission_f_0(X).
evaluate_0(X) <= evaluate_f_0(X).
grant_0(X) <= grant_f_0(X).
publish_0(X) <= publish_f_0(X).
remove_0(X) <= remove_f_0(X).
                
hasAgent_0(X,Y) <= hasAgent_f_0(X,Y).
hasTheme_0(X,Y) <= hasTheme_f_0(X,Y).
hasResult_0(X,Y) <= hasResult_f_0(X,Y).
hasReceiver_0(X,Y) <= hasReceiver_f_0(X,Y).
isCommentOf_0(X,Y) <= isCommentOf_f_0(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_1 to evaluate the product only with a licence; otherwise, it is prohibited_1.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_1 for the licencee to evaluate the product

prohibited_1(Ev) <= evaluate_f_1(Ev), hasAgent_f_1(Ev,X), licensee_f_1(X), hasTheme_f_1(Ev,P), product_f_1(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_1. Art.1b is an exception of Art1.a.
permitted_1(Ev) <= evaluate_f_1(Ev), hasAgent_f_1(Ev,X), licensee_f_1(X), hasTheme_f_1(Ev,P), product_f_1(P), isLicenceOf_f_1(L,P), licence_f_1(L), grant_f_1(Eg), rexist_f_1(Eg), hasTheme_f_1(Eg,L), hasAgent_f_1(Eg,Y), licensor_f_1(Y), hasReceiver_f_1(Eg,X).

exception(prohibited_1(Ev), permitted_1(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_1 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_1. If the licencee publish the results of the evaluation 
% even if this was prohibited_1, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_1 for the licencee to publish the results of the evaluation of the product
prohibited_1(Ep) <= condition_2_1(Ep,X,R).
condition_2_1(Ep,X,R) <= publish_f_1(Ep), hasAgent_f_1(Ep,X), licensee_f_1(X), hasTheme_f_1(Ep,R), result_f_1(R), hasResult_f_1(Ev,R), evaluate_f_1(Ev), rexist_f_1(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_1. Art.2b is an exception of Art2.a.
permitted_1(Ep) <= publish_f_1(Ep), hasAgent_f_1(Ep,X), licensee_f_1(X), hasTheme_f_1(Ep,R), result_f_1(R), hasResult_f_1(Ev,R), evaluate_f_1(Ev), rexist_f_1(Ev), approve_f_1(Ea), rexist_f_1(Ea), hasTheme_f_1(Ea,Ep), licensor_f_1(Y), hasAgent_f_1(Ea,Y).

exception(condition_2_1(Ep,X,R),permitted_1(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_1 to do so, he is obliged to remove them. The removal compensate_1s the violation_1 of the prohibition.
obligatory_1(ca(Ep,X,R)) <= rexist_f_1(Ep), condition_2_1(Ep,X,R).
remove_1(ca(Ep,X,R)) <= rexist_f_1(Ep), condition_2_1(Ep,X,R).
hasTheme_1(ca(Ep,X,R),R) <= rexist_f_1(Ep), condition_2_1(Ep,X,R).
hasAgent_1(ca(Ep,X,R),X) <= rexist_f_1(Ep), condition_2_1(Ep,X,R).
compensate_1(ca(Ep,X,R),Ep) <= rexist_f_1(Ep), condition_2_1(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_1 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_1.
prohibited_1(Ep) <= publish_f_1(Ep), hasAgent_f_1(Ep,X), licensee_f_1(X), hasTheme_f_1(Ep,C), comment_f_1(C), evaluate_f_1(Ev), rexist_f_1(Ev), isCommentOf_f_1(C,Ev).

% Art.3b: if publishing the result is permitted_1, also publishing the comments is permitted_1; this overrides the above prohibition.
permitted_1(Ep) <= publish_f_1(Ep), hasAgent_f_1(Ep,X), licensee_f_1(X), hasTheme_f_1(Ep,C), comment_f_1(C), isCommentOf_f_1(C,Ev), evaluate_f_1(Ev), rexist_f_1(Ev), hasResult_f_1(Ev,R), publish_f_1(Epr), hasAgent_f_1(Epr,X), hasTheme_f_1(Epr,R), permitted_1(Epr).

exception(prohibited_1(Ep),permitted_1(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_1. Art.4a is an exception of Art2.a.

obligatory_1(Ep) <= publish_f_1(Ep), hasAgent_f_1(Ep,X), licensee_f_1(X), hasTheme_f_1(Ep,R), result_f_1(R), hasResult_f_1(Ev,R), evaluate_f_1(Ev), rexist_f_1(Ev), commission_f_1(Ec), rexist_f_1(Ec), hasTheme_f_1(Ec,Ev).
exception(condition_2_1(Ep,X,R),obligatory_1(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_1 action x and, at the same time, x does not really exist => violation_1; 
%(2) if there is some prohibited_1 action x and, at the same time, x really exists => violation_1

rexist_1(ca(Ep,X,R)) <= remove_1(ca(Ep,X,R)), hasAgent_1(ca(Ep,X,R),X), hasTheme_1(ca(Ep,X,R),R), rexist_f_1(Er), remove_f_1(Er), hasTheme_f_1(Er,R), hasAgent_f_1(Er,X).

violation_1(viol(X)) <= obligatory_1(X).
-violation_1(viol(X)) <= obligatory_1(X), rexist_1(X).
exception(violation_1(X),-violation_1(X)).

violation_1(viol(X)) <= prohibited_1(X), rexist_1(X).

referTo_1(viol(X),X) <= violation_1(viol(X)).

compensate_1d_1(X) <= compensate_1(Y,X), rexist_1(Y).
exception(violation_1(viol(X)),compensate_1d_1(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_1(X) <= rexist_f_1(X).
licensee_1(X) <= licensee_f_1(X).
licensor_1(X) <= licensor_f_1(X).
product_1(X) <= product_f_1(X).
result_1(X) <= result_f_1(X).
licence_1(X) <= licence_f_1(X).
comment_1(X) <= comment_f_1(X).
isLicenceOf_1(X,Y) <= isLicenceOf_f_1(X,Y).
                
approve_1(X) <= approve_f_1(X).
commission_1(X) <= commission_f_1(X).
evaluate_1(X) <= evaluate_f_1(X).
grant_1(X) <= grant_f_1(X).
publish_1(X) <= publish_f_1(X).
remove_1(X) <= remove_f_1(X).
                
hasAgent_1(X,Y) <= hasAgent_f_1(X,Y).
hasTheme_1(X,Y) <= hasTheme_f_1(X,Y).
hasResult_1(X,Y) <= hasResult_f_1(X,Y).
hasReceiver_1(X,Y) <= hasReceiver_f_1(X,Y).
isCommentOf_1(X,Y) <= isCommentOf_f_1(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_2 to evaluate the product only with a licence; otherwise, it is prohibited_2.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_2 for the licencee to evaluate the product

prohibited_2(Ev) <= evaluate_f_2(Ev), hasAgent_f_2(Ev,X), licensee_f_2(X), hasTheme_f_2(Ev,P), product_f_2(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_2. Art.1b is an exception of Art1.a.
permitted_2(Ev) <= evaluate_f_2(Ev), hasAgent_f_2(Ev,X), licensee_f_2(X), hasTheme_f_2(Ev,P), product_f_2(P), isLicenceOf_f_2(L,P), licence_f_2(L), grant_f_2(Eg), rexist_f_2(Eg), hasTheme_f_2(Eg,L), hasAgent_f_2(Eg,Y), licensor_f_2(Y), hasReceiver_f_2(Eg,X).

exception(prohibited_2(Ev), permitted_2(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_2 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_2. If the licencee publish the results of the evaluation 
% even if this was prohibited_2, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_2 for the licencee to publish the results of the evaluation of the product
prohibited_2(Ep) <= condition_2_2(Ep,X,R).
condition_2_2(Ep,X,R) <= publish_f_2(Ep), hasAgent_f_2(Ep,X), licensee_f_2(X), hasTheme_f_2(Ep,R), result_f_2(R), hasResult_f_2(Ev,R), evaluate_f_2(Ev), rexist_f_2(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_2. Art.2b is an exception of Art2.a.
permitted_2(Ep) <= publish_f_2(Ep), hasAgent_f_2(Ep,X), licensee_f_2(X), hasTheme_f_2(Ep,R), result_f_2(R), hasResult_f_2(Ev,R), evaluate_f_2(Ev), rexist_f_2(Ev), approve_f_2(Ea), rexist_f_2(Ea), hasTheme_f_2(Ea,Ep), licensor_f_2(Y), hasAgent_f_2(Ea,Y).

exception(condition_2_2(Ep,X,R),permitted_2(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_2 to do so, he is obliged to remove them. The removal compensate_2s the violation_2 of the prohibition.
obligatory_2(ca(Ep,X,R)) <= rexist_f_2(Ep), condition_2_2(Ep,X,R).
remove_2(ca(Ep,X,R)) <= rexist_f_2(Ep), condition_2_2(Ep,X,R).
hasTheme_2(ca(Ep,X,R),R) <= rexist_f_2(Ep), condition_2_2(Ep,X,R).
hasAgent_2(ca(Ep,X,R),X) <= rexist_f_2(Ep), condition_2_2(Ep,X,R).
compensate_2(ca(Ep,X,R),Ep) <= rexist_f_2(Ep), condition_2_2(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_2 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_2.
prohibited_2(Ep) <= publish_f_2(Ep), hasAgent_f_2(Ep,X), licensee_f_2(X), hasTheme_f_2(Ep,C), comment_f_2(C), evaluate_f_2(Ev), rexist_f_2(Ev), isCommentOf_f_2(C,Ev).

% Art.3b: if publishing the result is permitted_2, also publishing the comments is permitted_2; this overrides the above prohibition.
permitted_2(Ep) <= publish_f_2(Ep), hasAgent_f_2(Ep,X), licensee_f_2(X), hasTheme_f_2(Ep,C), comment_f_2(C), isCommentOf_f_2(C,Ev), evaluate_f_2(Ev), rexist_f_2(Ev), hasResult_f_2(Ev,R), publish_f_2(Epr), hasAgent_f_2(Epr,X), hasTheme_f_2(Epr,R), permitted_2(Epr).

exception(prohibited_2(Ep),permitted_2(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_2. Art.4a is an exception of Art2.a.

obligatory_2(Ep) <= publish_f_2(Ep), hasAgent_f_2(Ep,X), licensee_f_2(X), hasTheme_f_2(Ep,R), result_f_2(R), hasResult_f_2(Ev,R), evaluate_f_2(Ev), rexist_f_2(Ev), commission_f_2(Ec), rexist_f_2(Ec), hasTheme_f_2(Ec,Ev).
exception(condition_2_2(Ep,X,R),obligatory_2(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_2 action x and, at the same time, x does not really exist => violation_2; 
%(2) if there is some prohibited_2 action x and, at the same time, x really exists => violation_2

rexist_2(ca(Ep,X,R)) <= remove_2(ca(Ep,X,R)), hasAgent_2(ca(Ep,X,R),X), hasTheme_2(ca(Ep,X,R),R), rexist_f_2(Er), remove_f_2(Er), hasTheme_f_2(Er,R), hasAgent_f_2(Er,X).

violation_2(viol(X)) <= obligatory_2(X).
-violation_2(viol(X)) <= obligatory_2(X), rexist_2(X).
exception(violation_2(X),-violation_2(X)).

violation_2(viol(X)) <= prohibited_2(X), rexist_2(X).

referTo_2(viol(X),X) <= violation_2(viol(X)).

compensate_2d_2(X) <= compensate_2(Y,X), rexist_2(Y).
exception(violation_2(viol(X)),compensate_2d_2(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_2(X) <= rexist_f_2(X).
licensee_2(X) <= licensee_f_2(X).
licensor_2(X) <= licensor_f_2(X).
product_2(X) <= product_f_2(X).
result_2(X) <= result_f_2(X).
licence_2(X) <= licence_f_2(X).
comment_2(X) <= comment_f_2(X).
isLicenceOf_2(X,Y) <= isLicenceOf_f_2(X,Y).
                
approve_2(X) <= approve_f_2(X).
commission_2(X) <= commission_f_2(X).
evaluate_2(X) <= evaluate_f_2(X).
grant_2(X) <= grant_f_2(X).
publish_2(X) <= publish_f_2(X).
remove_2(X) <= remove_f_2(X).
                
hasAgent_2(X,Y) <= hasAgent_f_2(X,Y).
hasTheme_2(X,Y) <= hasTheme_f_2(X,Y).
hasResult_2(X,Y) <= hasResult_f_2(X,Y).
hasReceiver_2(X,Y) <= hasReceiver_f_2(X,Y).
isCommentOf_2(X,Y) <= isCommentOf_f_2(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_3 to evaluate the product only with a licence; otherwise, it is prohibited_3.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_3 for the licencee to evaluate the product

prohibited_3(Ev) <= evaluate_f_3(Ev), hasAgent_f_3(Ev,X), licensee_f_3(X), hasTheme_f_3(Ev,P), product_f_3(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_3. Art.1b is an exception of Art1.a.
permitted_3(Ev) <= evaluate_f_3(Ev), hasAgent_f_3(Ev,X), licensee_f_3(X), hasTheme_f_3(Ev,P), product_f_3(P), isLicenceOf_f_3(L,P), licence_f_3(L), grant_f_3(Eg), rexist_f_3(Eg), hasTheme_f_3(Eg,L), hasAgent_f_3(Eg,Y), licensor_f_3(Y), hasReceiver_f_3(Eg,X).

exception(prohibited_3(Ev), permitted_3(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_3 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_3. If the licencee publish the results of the evaluation 
% even if this was prohibited_3, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_3 for the licencee to publish the results of the evaluation of the product
prohibited_3(Ep) <= condition_2_3(Ep,X,R).
condition_2_3(Ep,X,R) <= publish_f_3(Ep), hasAgent_f_3(Ep,X), licensee_f_3(X), hasTheme_f_3(Ep,R), result_f_3(R), hasResult_f_3(Ev,R), evaluate_f_3(Ev), rexist_f_3(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_3. Art.2b is an exception of Art2.a.
permitted_3(Ep) <= publish_f_3(Ep), hasAgent_f_3(Ep,X), licensee_f_3(X), hasTheme_f_3(Ep,R), result_f_3(R), hasResult_f_3(Ev,R), evaluate_f_3(Ev), rexist_f_3(Ev), approve_f_3(Ea), rexist_f_3(Ea), hasTheme_f_3(Ea,Ep), licensor_f_3(Y), hasAgent_f_3(Ea,Y).

exception(condition_2_3(Ep,X,R),permitted_3(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_3 to do so, he is obliged to remove them. The removal compensate_3s the violation_3 of the prohibition.
obligatory_3(ca(Ep,X,R)) <= rexist_f_3(Ep), condition_2_3(Ep,X,R).
remove_3(ca(Ep,X,R)) <= rexist_f_3(Ep), condition_2_3(Ep,X,R).
hasTheme_3(ca(Ep,X,R),R) <= rexist_f_3(Ep), condition_2_3(Ep,X,R).
hasAgent_3(ca(Ep,X,R),X) <= rexist_f_3(Ep), condition_2_3(Ep,X,R).
compensate_3(ca(Ep,X,R),Ep) <= rexist_f_3(Ep), condition_2_3(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_3 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_3.
prohibited_3(Ep) <= publish_f_3(Ep), hasAgent_f_3(Ep,X), licensee_f_3(X), hasTheme_f_3(Ep,C), comment_f_3(C), evaluate_f_3(Ev), rexist_f_3(Ev), isCommentOf_f_3(C,Ev).

% Art.3b: if publishing the result is permitted_3, also publishing the comments is permitted_3; this overrides the above prohibition.
permitted_3(Ep) <= publish_f_3(Ep), hasAgent_f_3(Ep,X), licensee_f_3(X), hasTheme_f_3(Ep,C), comment_f_3(C), isCommentOf_f_3(C,Ev), evaluate_f_3(Ev), rexist_f_3(Ev), hasResult_f_3(Ev,R), publish_f_3(Epr), hasAgent_f_3(Epr,X), hasTheme_f_3(Epr,R), permitted_3(Epr).

exception(prohibited_3(Ep),permitted_3(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_3. Art.4a is an exception of Art2.a.

obligatory_3(Ep) <= publish_f_3(Ep), hasAgent_f_3(Ep,X), licensee_f_3(X), hasTheme_f_3(Ep,R), result_f_3(R), hasResult_f_3(Ev,R), evaluate_f_3(Ev), rexist_f_3(Ev), commission_f_3(Ec), rexist_f_3(Ec), hasTheme_f_3(Ec,Ev).
exception(condition_2_3(Ep,X,R),obligatory_3(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_3 action x and, at the same time, x does not really exist => violation_3; 
%(2) if there is some prohibited_3 action x and, at the same time, x really exists => violation_3

rexist_3(ca(Ep,X,R)) <= remove_3(ca(Ep,X,R)), hasAgent_3(ca(Ep,X,R),X), hasTheme_3(ca(Ep,X,R),R), rexist_f_3(Er), remove_f_3(Er), hasTheme_f_3(Er,R), hasAgent_f_3(Er,X).

violation_3(viol(X)) <= obligatory_3(X).
-violation_3(viol(X)) <= obligatory_3(X), rexist_3(X).
exception(violation_3(X),-violation_3(X)).

violation_3(viol(X)) <= prohibited_3(X), rexist_3(X).

referTo_3(viol(X),X) <= violation_3(viol(X)).

compensate_3d_3(X) <= compensate_3(Y,X), rexist_3(Y).
exception(violation_3(viol(X)),compensate_3d_3(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_3(X) <= rexist_f_3(X).
licensee_3(X) <= licensee_f_3(X).
licensor_3(X) <= licensor_f_3(X).
product_3(X) <= product_f_3(X).
result_3(X) <= result_f_3(X).
licence_3(X) <= licence_f_3(X).
comment_3(X) <= comment_f_3(X).
isLicenceOf_3(X,Y) <= isLicenceOf_f_3(X,Y).
                
approve_3(X) <= approve_f_3(X).
commission_3(X) <= commission_f_3(X).
evaluate_3(X) <= evaluate_f_3(X).
grant_3(X) <= grant_f_3(X).
publish_3(X) <= publish_f_3(X).
remove_3(X) <= remove_f_3(X).
                
hasAgent_3(X,Y) <= hasAgent_f_3(X,Y).
hasTheme_3(X,Y) <= hasTheme_f_3(X,Y).
hasResult_3(X,Y) <= hasResult_f_3(X,Y).
hasReceiver_3(X,Y) <= hasReceiver_f_3(X,Y).
isCommentOf_3(X,Y) <= isCommentOf_f_3(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_4 to evaluate the product only with a licence; otherwise, it is prohibited_4.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_4 for the licencee to evaluate the product

prohibited_4(Ev) <= evaluate_f_4(Ev), hasAgent_f_4(Ev,X), licensee_f_4(X), hasTheme_f_4(Ev,P), product_f_4(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_4. Art.1b is an exception of Art1.a.
permitted_4(Ev) <= evaluate_f_4(Ev), hasAgent_f_4(Ev,X), licensee_f_4(X), hasTheme_f_4(Ev,P), product_f_4(P), isLicenceOf_f_4(L,P), licence_f_4(L), grant_f_4(Eg), rexist_f_4(Eg), hasTheme_f_4(Eg,L), hasAgent_f_4(Eg,Y), licensor_f_4(Y), hasReceiver_f_4(Eg,X).

exception(prohibited_4(Ev), permitted_4(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_4 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_4. If the licencee publish the results of the evaluation 
% even if this was prohibited_4, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_4 for the licencee to publish the results of the evaluation of the product
prohibited_4(Ep) <= condition_2_4(Ep,X,R).
condition_2_4(Ep,X,R) <= publish_f_4(Ep), hasAgent_f_4(Ep,X), licensee_f_4(X), hasTheme_f_4(Ep,R), result_f_4(R), hasResult_f_4(Ev,R), evaluate_f_4(Ev), rexist_f_4(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_4. Art.2b is an exception of Art2.a.
permitted_4(Ep) <= publish_f_4(Ep), hasAgent_f_4(Ep,X), licensee_f_4(X), hasTheme_f_4(Ep,R), result_f_4(R), hasResult_f_4(Ev,R), evaluate_f_4(Ev), rexist_f_4(Ev), approve_f_4(Ea), rexist_f_4(Ea), hasTheme_f_4(Ea,Ep), licensor_f_4(Y), hasAgent_f_4(Ea,Y).

exception(condition_2_4(Ep,X,R),permitted_4(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_4 to do so, he is obliged to remove them. The removal compensate_4s the violation_4 of the prohibition.
obligatory_4(ca(Ep,X,R)) <= rexist_f_4(Ep), condition_2_4(Ep,X,R).
remove_4(ca(Ep,X,R)) <= rexist_f_4(Ep), condition_2_4(Ep,X,R).
hasTheme_4(ca(Ep,X,R),R) <= rexist_f_4(Ep), condition_2_4(Ep,X,R).
hasAgent_4(ca(Ep,X,R),X) <= rexist_f_4(Ep), condition_2_4(Ep,X,R).
compensate_4(ca(Ep,X,R),Ep) <= rexist_f_4(Ep), condition_2_4(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_4 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_4.
prohibited_4(Ep) <= publish_f_4(Ep), hasAgent_f_4(Ep,X), licensee_f_4(X), hasTheme_f_4(Ep,C), comment_f_4(C), evaluate_f_4(Ev), rexist_f_4(Ev), isCommentOf_f_4(C,Ev).

% Art.3b: if publishing the result is permitted_4, also publishing the comments is permitted_4; this overrides the above prohibition.
permitted_4(Ep) <= publish_f_4(Ep), hasAgent_f_4(Ep,X), licensee_f_4(X), hasTheme_f_4(Ep,C), comment_f_4(C), isCommentOf_f_4(C,Ev), evaluate_f_4(Ev), rexist_f_4(Ev), hasResult_f_4(Ev,R), publish_f_4(Epr), hasAgent_f_4(Epr,X), hasTheme_f_4(Epr,R), permitted_4(Epr).

exception(prohibited_4(Ep),permitted_4(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_4. Art.4a is an exception of Art2.a.

obligatory_4(Ep) <= publish_f_4(Ep), hasAgent_f_4(Ep,X), licensee_f_4(X), hasTheme_f_4(Ep,R), result_f_4(R), hasResult_f_4(Ev,R), evaluate_f_4(Ev), rexist_f_4(Ev), commission_f_4(Ec), rexist_f_4(Ec), hasTheme_f_4(Ec,Ev).
exception(condition_2_4(Ep,X,R),obligatory_4(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_4 action x and, at the same time, x does not really exist => violation_4; 
%(2) if there is some prohibited_4 action x and, at the same time, x really exists => violation_4

rexist_4(ca(Ep,X,R)) <= remove_4(ca(Ep,X,R)), hasAgent_4(ca(Ep,X,R),X), hasTheme_4(ca(Ep,X,R),R), rexist_f_4(Er), remove_f_4(Er), hasTheme_f_4(Er,R), hasAgent_f_4(Er,X).

violation_4(viol(X)) <= obligatory_4(X).
-violation_4(viol(X)) <= obligatory_4(X), rexist_4(X).
exception(violation_4(X),-violation_4(X)).

violation_4(viol(X)) <= prohibited_4(X), rexist_4(X).

referTo_4(viol(X),X) <= violation_4(viol(X)).

compensate_4d_4(X) <= compensate_4(Y,X), rexist_4(Y).
exception(violation_4(viol(X)),compensate_4d_4(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_4(X) <= rexist_f_4(X).
licensee_4(X) <= licensee_f_4(X).
licensor_4(X) <= licensor_f_4(X).
product_4(X) <= product_f_4(X).
result_4(X) <= result_f_4(X).
licence_4(X) <= licence_f_4(X).
comment_4(X) <= comment_f_4(X).
isLicenceOf_4(X,Y) <= isLicenceOf_f_4(X,Y).
                
approve_4(X) <= approve_f_4(X).
commission_4(X) <= commission_f_4(X).
evaluate_4(X) <= evaluate_f_4(X).
grant_4(X) <= grant_f_4(X).
publish_4(X) <= publish_f_4(X).
remove_4(X) <= remove_f_4(X).
                
hasAgent_4(X,Y) <= hasAgent_f_4(X,Y).
hasTheme_4(X,Y) <= hasTheme_f_4(X,Y).
hasResult_4(X,Y) <= hasResult_f_4(X,Y).
hasReceiver_4(X,Y) <= hasReceiver_f_4(X,Y).
isCommentOf_4(X,Y) <= isCommentOf_f_4(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_5 to evaluate the product only with a licence; otherwise, it is prohibited_5.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_5 for the licencee to evaluate the product

prohibited_5(Ev) <= evaluate_f_5(Ev), hasAgent_f_5(Ev,X), licensee_f_5(X), hasTheme_f_5(Ev,P), product_f_5(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_5. Art.1b is an exception of Art1.a.
permitted_5(Ev) <= evaluate_f_5(Ev), hasAgent_f_5(Ev,X), licensee_f_5(X), hasTheme_f_5(Ev,P), product_f_5(P), isLicenceOf_f_5(L,P), licence_f_5(L), grant_f_5(Eg), rexist_f_5(Eg), hasTheme_f_5(Eg,L), hasAgent_f_5(Eg,Y), licensor_f_5(Y), hasReceiver_f_5(Eg,X).

exception(prohibited_5(Ev), permitted_5(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_5 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_5. If the licencee publish the results of the evaluation 
% even if this was prohibited_5, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_5 for the licencee to publish the results of the evaluation of the product
prohibited_5(Ep) <= condition_2_5(Ep,X,R).
condition_2_5(Ep,X,R) <= publish_f_5(Ep), hasAgent_f_5(Ep,X), licensee_f_5(X), hasTheme_f_5(Ep,R), result_f_5(R), hasResult_f_5(Ev,R), evaluate_f_5(Ev), rexist_f_5(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_5. Art.2b is an exception of Art2.a.
permitted_5(Ep) <= publish_f_5(Ep), hasAgent_f_5(Ep,X), licensee_f_5(X), hasTheme_f_5(Ep,R), result_f_5(R), hasResult_f_5(Ev,R), evaluate_f_5(Ev), rexist_f_5(Ev), approve_f_5(Ea), rexist_f_5(Ea), hasTheme_f_5(Ea,Ep), licensor_f_5(Y), hasAgent_f_5(Ea,Y).

exception(condition_2_5(Ep,X,R),permitted_5(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_5 to do so, he is obliged to remove them. The removal compensate_5s the violation_5 of the prohibition.
obligatory_5(ca(Ep,X,R)) <= rexist_f_5(Ep), condition_2_5(Ep,X,R).
remove_5(ca(Ep,X,R)) <= rexist_f_5(Ep), condition_2_5(Ep,X,R).
hasTheme_5(ca(Ep,X,R),R) <= rexist_f_5(Ep), condition_2_5(Ep,X,R).
hasAgent_5(ca(Ep,X,R),X) <= rexist_f_5(Ep), condition_2_5(Ep,X,R).
compensate_5(ca(Ep,X,R),Ep) <= rexist_f_5(Ep), condition_2_5(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_5 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_5.
prohibited_5(Ep) <= publish_f_5(Ep), hasAgent_f_5(Ep,X), licensee_f_5(X), hasTheme_f_5(Ep,C), comment_f_5(C), evaluate_f_5(Ev), rexist_f_5(Ev), isCommentOf_f_5(C,Ev).

% Art.3b: if publishing the result is permitted_5, also publishing the comments is permitted_5; this overrides the above prohibition.
permitted_5(Ep) <= publish_f_5(Ep), hasAgent_f_5(Ep,X), licensee_f_5(X), hasTheme_f_5(Ep,C), comment_f_5(C), isCommentOf_f_5(C,Ev), evaluate_f_5(Ev), rexist_f_5(Ev), hasResult_f_5(Ev,R), publish_f_5(Epr), hasAgent_f_5(Epr,X), hasTheme_f_5(Epr,R), permitted_5(Epr).

exception(prohibited_5(Ep),permitted_5(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_5. Art.4a is an exception of Art2.a.

obligatory_5(Ep) <= publish_f_5(Ep), hasAgent_f_5(Ep,X), licensee_f_5(X), hasTheme_f_5(Ep,R), result_f_5(R), hasResult_f_5(Ev,R), evaluate_f_5(Ev), rexist_f_5(Ev), commission_f_5(Ec), rexist_f_5(Ec), hasTheme_f_5(Ec,Ev).
exception(condition_2_5(Ep,X,R),obligatory_5(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_5 action x and, at the same time, x does not really exist => violation_5; 
%(2) if there is some prohibited_5 action x and, at the same time, x really exists => violation_5

rexist_5(ca(Ep,X,R)) <= remove_5(ca(Ep,X,R)), hasAgent_5(ca(Ep,X,R),X), hasTheme_5(ca(Ep,X,R),R), rexist_f_5(Er), remove_f_5(Er), hasTheme_f_5(Er,R), hasAgent_f_5(Er,X).

violation_5(viol(X)) <= obligatory_5(X).
-violation_5(viol(X)) <= obligatory_5(X), rexist_5(X).
exception(violation_5(X),-violation_5(X)).

violation_5(viol(X)) <= prohibited_5(X), rexist_5(X).

referTo_5(viol(X),X) <= violation_5(viol(X)).

compensate_5d_5(X) <= compensate_5(Y,X), rexist_5(Y).
exception(violation_5(viol(X)),compensate_5d_5(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_5(X) <= rexist_f_5(X).
licensee_5(X) <= licensee_f_5(X).
licensor_5(X) <= licensor_f_5(X).
product_5(X) <= product_f_5(X).
result_5(X) <= result_f_5(X).
licence_5(X) <= licence_f_5(X).
comment_5(X) <= comment_f_5(X).
isLicenceOf_5(X,Y) <= isLicenceOf_f_5(X,Y).
                
approve_5(X) <= approve_f_5(X).
commission_5(X) <= commission_f_5(X).
evaluate_5(X) <= evaluate_f_5(X).
grant_5(X) <= grant_f_5(X).
publish_5(X) <= publish_f_5(X).
remove_5(X) <= remove_f_5(X).
                
hasAgent_5(X,Y) <= hasAgent_f_5(X,Y).
hasTheme_5(X,Y) <= hasTheme_f_5(X,Y).
hasResult_5(X,Y) <= hasResult_f_5(X,Y).
hasReceiver_5(X,Y) <= hasReceiver_f_5(X,Y).
isCommentOf_5(X,Y) <= isCommentOf_f_5(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_6 to evaluate the product only with a licence; otherwise, it is prohibited_6.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_6 for the licencee to evaluate the product

prohibited_6(Ev) <= evaluate_f_6(Ev), hasAgent_f_6(Ev,X), licensee_f_6(X), hasTheme_f_6(Ev,P), product_f_6(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_6. Art.1b is an exception of Art1.a.
permitted_6(Ev) <= evaluate_f_6(Ev), hasAgent_f_6(Ev,X), licensee_f_6(X), hasTheme_f_6(Ev,P), product_f_6(P), isLicenceOf_f_6(L,P), licence_f_6(L), grant_f_6(Eg), rexist_f_6(Eg), hasTheme_f_6(Eg,L), hasAgent_f_6(Eg,Y), licensor_f_6(Y), hasReceiver_f_6(Eg,X).

exception(prohibited_6(Ev), permitted_6(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_6 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_6. If the licencee publish the results of the evaluation 
% even if this was prohibited_6, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_6 for the licencee to publish the results of the evaluation of the product
prohibited_6(Ep) <= condition_2_6(Ep,X,R).
condition_2_6(Ep,X,R) <= publish_f_6(Ep), hasAgent_f_6(Ep,X), licensee_f_6(X), hasTheme_f_6(Ep,R), result_f_6(R), hasResult_f_6(Ev,R), evaluate_f_6(Ev), rexist_f_6(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_6. Art.2b is an exception of Art2.a.
permitted_6(Ep) <= publish_f_6(Ep), hasAgent_f_6(Ep,X), licensee_f_6(X), hasTheme_f_6(Ep,R), result_f_6(R), hasResult_f_6(Ev,R), evaluate_f_6(Ev), rexist_f_6(Ev), approve_f_6(Ea), rexist_f_6(Ea), hasTheme_f_6(Ea,Ep), licensor_f_6(Y), hasAgent_f_6(Ea,Y).

exception(condition_2_6(Ep,X,R),permitted_6(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_6 to do so, he is obliged to remove them. The removal compensate_6s the violation_6 of the prohibition.
obligatory_6(ca(Ep,X,R)) <= rexist_f_6(Ep), condition_2_6(Ep,X,R).
remove_6(ca(Ep,X,R)) <= rexist_f_6(Ep), condition_2_6(Ep,X,R).
hasTheme_6(ca(Ep,X,R),R) <= rexist_f_6(Ep), condition_2_6(Ep,X,R).
hasAgent_6(ca(Ep,X,R),X) <= rexist_f_6(Ep), condition_2_6(Ep,X,R).
compensate_6(ca(Ep,X,R),Ep) <= rexist_f_6(Ep), condition_2_6(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_6 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_6.
prohibited_6(Ep) <= publish_f_6(Ep), hasAgent_f_6(Ep,X), licensee_f_6(X), hasTheme_f_6(Ep,C), comment_f_6(C), evaluate_f_6(Ev), rexist_f_6(Ev), isCommentOf_f_6(C,Ev).

% Art.3b: if publishing the result is permitted_6, also publishing the comments is permitted_6; this overrides the above prohibition.
permitted_6(Ep) <= publish_f_6(Ep), hasAgent_f_6(Ep,X), licensee_f_6(X), hasTheme_f_6(Ep,C), comment_f_6(C), isCommentOf_f_6(C,Ev), evaluate_f_6(Ev), rexist_f_6(Ev), hasResult_f_6(Ev,R), publish_f_6(Epr), hasAgent_f_6(Epr,X), hasTheme_f_6(Epr,R), permitted_6(Epr).

exception(prohibited_6(Ep),permitted_6(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_6. Art.4a is an exception of Art2.a.

obligatory_6(Ep) <= publish_f_6(Ep), hasAgent_f_6(Ep,X), licensee_f_6(X), hasTheme_f_6(Ep,R), result_f_6(R), hasResult_f_6(Ev,R), evaluate_f_6(Ev), rexist_f_6(Ev), commission_f_6(Ec), rexist_f_6(Ec), hasTheme_f_6(Ec,Ev).
exception(condition_2_6(Ep,X,R),obligatory_6(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_6 action x and, at the same time, x does not really exist => violation_6; 
%(2) if there is some prohibited_6 action x and, at the same time, x really exists => violation_6

rexist_6(ca(Ep,X,R)) <= remove_6(ca(Ep,X,R)), hasAgent_6(ca(Ep,X,R),X), hasTheme_6(ca(Ep,X,R),R), rexist_f_6(Er), remove_f_6(Er), hasTheme_f_6(Er,R), hasAgent_f_6(Er,X).

violation_6(viol(X)) <= obligatory_6(X).
-violation_6(viol(X)) <= obligatory_6(X), rexist_6(X).
exception(violation_6(X),-violation_6(X)).

violation_6(viol(X)) <= prohibited_6(X), rexist_6(X).

referTo_6(viol(X),X) <= violation_6(viol(X)).

compensate_6d_6(X) <= compensate_6(Y,X), rexist_6(Y).
exception(violation_6(viol(X)),compensate_6d_6(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_6(X) <= rexist_f_6(X).
licensee_6(X) <= licensee_f_6(X).
licensor_6(X) <= licensor_f_6(X).
product_6(X) <= product_f_6(X).
result_6(X) <= result_f_6(X).
licence_6(X) <= licence_f_6(X).
comment_6(X) <= comment_f_6(X).
isLicenceOf_6(X,Y) <= isLicenceOf_f_6(X,Y).
                
approve_6(X) <= approve_f_6(X).
commission_6(X) <= commission_f_6(X).
evaluate_6(X) <= evaluate_f_6(X).
grant_6(X) <= grant_f_6(X).
publish_6(X) <= publish_f_6(X).
remove_6(X) <= remove_f_6(X).
                
hasAgent_6(X,Y) <= hasAgent_f_6(X,Y).
hasTheme_6(X,Y) <= hasTheme_f_6(X,Y).
hasResult_6(X,Y) <= hasResult_f_6(X,Y).
hasReceiver_6(X,Y) <= hasReceiver_f_6(X,Y).
isCommentOf_6(X,Y) <= isCommentOf_f_6(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_7 to evaluate the product only with a licence; otherwise, it is prohibited_7.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_7 for the licencee to evaluate the product

prohibited_7(Ev) <= evaluate_f_7(Ev), hasAgent_f_7(Ev,X), licensee_f_7(X), hasTheme_f_7(Ev,P), product_f_7(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_7. Art.1b is an exception of Art1.a.
permitted_7(Ev) <= evaluate_f_7(Ev), hasAgent_f_7(Ev,X), licensee_f_7(X), hasTheme_f_7(Ev,P), product_f_7(P), isLicenceOf_f_7(L,P), licence_f_7(L), grant_f_7(Eg), rexist_f_7(Eg), hasTheme_f_7(Eg,L), hasAgent_f_7(Eg,Y), licensor_f_7(Y), hasReceiver_f_7(Eg,X).

exception(prohibited_7(Ev), permitted_7(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_7 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_7. If the licencee publish the results of the evaluation 
% even if this was prohibited_7, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_7 for the licencee to publish the results of the evaluation of the product
prohibited_7(Ep) <= condition_2_7(Ep,X,R).
condition_2_7(Ep,X,R) <= publish_f_7(Ep), hasAgent_f_7(Ep,X), licensee_f_7(X), hasTheme_f_7(Ep,R), result_f_7(R), hasResult_f_7(Ev,R), evaluate_f_7(Ev), rexist_f_7(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_7. Art.2b is an exception of Art2.a.
permitted_7(Ep) <= publish_f_7(Ep), hasAgent_f_7(Ep,X), licensee_f_7(X), hasTheme_f_7(Ep,R), result_f_7(R), hasResult_f_7(Ev,R), evaluate_f_7(Ev), rexist_f_7(Ev), approve_f_7(Ea), rexist_f_7(Ea), hasTheme_f_7(Ea,Ep), licensor_f_7(Y), hasAgent_f_7(Ea,Y).

exception(condition_2_7(Ep,X,R),permitted_7(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_7 to do so, he is obliged to remove them. The removal compensate_7s the violation_7 of the prohibition.
obligatory_7(ca(Ep,X,R)) <= rexist_f_7(Ep), condition_2_7(Ep,X,R).
remove_7(ca(Ep,X,R)) <= rexist_f_7(Ep), condition_2_7(Ep,X,R).
hasTheme_7(ca(Ep,X,R),R) <= rexist_f_7(Ep), condition_2_7(Ep,X,R).
hasAgent_7(ca(Ep,X,R),X) <= rexist_f_7(Ep), condition_2_7(Ep,X,R).
compensate_7(ca(Ep,X,R),Ep) <= rexist_f_7(Ep), condition_2_7(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_7 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_7.
prohibited_7(Ep) <= publish_f_7(Ep), hasAgent_f_7(Ep,X), licensee_f_7(X), hasTheme_f_7(Ep,C), comment_f_7(C), evaluate_f_7(Ev), rexist_f_7(Ev), isCommentOf_f_7(C,Ev).

% Art.3b: if publishing the result is permitted_7, also publishing the comments is permitted_7; this overrides the above prohibition.
permitted_7(Ep) <= publish_f_7(Ep), hasAgent_f_7(Ep,X), licensee_f_7(X), hasTheme_f_7(Ep,C), comment_f_7(C), isCommentOf_f_7(C,Ev), evaluate_f_7(Ev), rexist_f_7(Ev), hasResult_f_7(Ev,R), publish_f_7(Epr), hasAgent_f_7(Epr,X), hasTheme_f_7(Epr,R), permitted_7(Epr).

exception(prohibited_7(Ep),permitted_7(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_7. Art.4a is an exception of Art2.a.

obligatory_7(Ep) <= publish_f_7(Ep), hasAgent_f_7(Ep,X), licensee_f_7(X), hasTheme_f_7(Ep,R), result_f_7(R), hasResult_f_7(Ev,R), evaluate_f_7(Ev), rexist_f_7(Ev), commission_f_7(Ec), rexist_f_7(Ec), hasTheme_f_7(Ec,Ev).
exception(condition_2_7(Ep,X,R),obligatory_7(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_7 action x and, at the same time, x does not really exist => violation_7; 
%(2) if there is some prohibited_7 action x and, at the same time, x really exists => violation_7

rexist_7(ca(Ep,X,R)) <= remove_7(ca(Ep,X,R)), hasAgent_7(ca(Ep,X,R),X), hasTheme_7(ca(Ep,X,R),R), rexist_f_7(Er), remove_f_7(Er), hasTheme_f_7(Er,R), hasAgent_f_7(Er,X).

violation_7(viol(X)) <= obligatory_7(X).
-violation_7(viol(X)) <= obligatory_7(X), rexist_7(X).
exception(violation_7(X),-violation_7(X)).

violation_7(viol(X)) <= prohibited_7(X), rexist_7(X).

referTo_7(viol(X),X) <= violation_7(viol(X)).

compensate_7d_7(X) <= compensate_7(Y,X), rexist_7(Y).
exception(violation_7(viol(X)),compensate_7d_7(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_7(X) <= rexist_f_7(X).
licensee_7(X) <= licensee_f_7(X).
licensor_7(X) <= licensor_f_7(X).
product_7(X) <= product_f_7(X).
result_7(X) <= result_f_7(X).
licence_7(X) <= licence_f_7(X).
comment_7(X) <= comment_f_7(X).
isLicenceOf_7(X,Y) <= isLicenceOf_f_7(X,Y).
                
approve_7(X) <= approve_f_7(X).
commission_7(X) <= commission_f_7(X).
evaluate_7(X) <= evaluate_f_7(X).
grant_7(X) <= grant_f_7(X).
publish_7(X) <= publish_f_7(X).
remove_7(X) <= remove_f_7(X).
                
hasAgent_7(X,Y) <= hasAgent_f_7(X,Y).
hasTheme_7(X,Y) <= hasTheme_f_7(X,Y).
hasResult_7(X,Y) <= hasResult_f_7(X,Y).
hasReceiver_7(X,Y) <= hasReceiver_f_7(X,Y).
isCommentOf_7(X,Y) <= isCommentOf_f_7(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_8 to evaluate the product only with a licence; otherwise, it is prohibited_8.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_8 for the licencee to evaluate the product

prohibited_8(Ev) <= evaluate_f_8(Ev), hasAgent_f_8(Ev,X), licensee_f_8(X), hasTheme_f_8(Ev,P), product_f_8(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_8. Art.1b is an exception of Art1.a.
permitted_8(Ev) <= evaluate_f_8(Ev), hasAgent_f_8(Ev,X), licensee_f_8(X), hasTheme_f_8(Ev,P), product_f_8(P), isLicenceOf_f_8(L,P), licence_f_8(L), grant_f_8(Eg), rexist_f_8(Eg), hasTheme_f_8(Eg,L), hasAgent_f_8(Eg,Y), licensor_f_8(Y), hasReceiver_f_8(Eg,X).

exception(prohibited_8(Ev), permitted_8(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_8 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_8. If the licencee publish the results of the evaluation 
% even if this was prohibited_8, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_8 for the licencee to publish the results of the evaluation of the product
prohibited_8(Ep) <= condition_2_8(Ep,X,R).
condition_2_8(Ep,X,R) <= publish_f_8(Ep), hasAgent_f_8(Ep,X), licensee_f_8(X), hasTheme_f_8(Ep,R), result_f_8(R), hasResult_f_8(Ev,R), evaluate_f_8(Ev), rexist_f_8(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_8. Art.2b is an exception of Art2.a.
permitted_8(Ep) <= publish_f_8(Ep), hasAgent_f_8(Ep,X), licensee_f_8(X), hasTheme_f_8(Ep,R), result_f_8(R), hasResult_f_8(Ev,R), evaluate_f_8(Ev), rexist_f_8(Ev), approve_f_8(Ea), rexist_f_8(Ea), hasTheme_f_8(Ea,Ep), licensor_f_8(Y), hasAgent_f_8(Ea,Y).

exception(condition_2_8(Ep,X,R),permitted_8(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_8 to do so, he is obliged to remove them. The removal compensate_8s the violation_8 of the prohibition.
obligatory_8(ca(Ep,X,R)) <= rexist_f_8(Ep), condition_2_8(Ep,X,R).
remove_8(ca(Ep,X,R)) <= rexist_f_8(Ep), condition_2_8(Ep,X,R).
hasTheme_8(ca(Ep,X,R),R) <= rexist_f_8(Ep), condition_2_8(Ep,X,R).
hasAgent_8(ca(Ep,X,R),X) <= rexist_f_8(Ep), condition_2_8(Ep,X,R).
compensate_8(ca(Ep,X,R),Ep) <= rexist_f_8(Ep), condition_2_8(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_8 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_8.
prohibited_8(Ep) <= publish_f_8(Ep), hasAgent_f_8(Ep,X), licensee_f_8(X), hasTheme_f_8(Ep,C), comment_f_8(C), evaluate_f_8(Ev), rexist_f_8(Ev), isCommentOf_f_8(C,Ev).

% Art.3b: if publishing the result is permitted_8, also publishing the comments is permitted_8; this overrides the above prohibition.
permitted_8(Ep) <= publish_f_8(Ep), hasAgent_f_8(Ep,X), licensee_f_8(X), hasTheme_f_8(Ep,C), comment_f_8(C), isCommentOf_f_8(C,Ev), evaluate_f_8(Ev), rexist_f_8(Ev), hasResult_f_8(Ev,R), publish_f_8(Epr), hasAgent_f_8(Epr,X), hasTheme_f_8(Epr,R), permitted_8(Epr).

exception(prohibited_8(Ep),permitted_8(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_8. Art.4a is an exception of Art2.a.

obligatory_8(Ep) <= publish_f_8(Ep), hasAgent_f_8(Ep,X), licensee_f_8(X), hasTheme_f_8(Ep,R), result_f_8(R), hasResult_f_8(Ev,R), evaluate_f_8(Ev), rexist_f_8(Ev), commission_f_8(Ec), rexist_f_8(Ec), hasTheme_f_8(Ec,Ev).
exception(condition_2_8(Ep,X,R),obligatory_8(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_8 action x and, at the same time, x does not really exist => violation_8; 
%(2) if there is some prohibited_8 action x and, at the same time, x really exists => violation_8

rexist_8(ca(Ep,X,R)) <= remove_8(ca(Ep,X,R)), hasAgent_8(ca(Ep,X,R),X), hasTheme_8(ca(Ep,X,R),R), rexist_f_8(Er), remove_f_8(Er), hasTheme_f_8(Er,R), hasAgent_f_8(Er,X).

violation_8(viol(X)) <= obligatory_8(X).
-violation_8(viol(X)) <= obligatory_8(X), rexist_8(X).
exception(violation_8(X),-violation_8(X)).

violation_8(viol(X)) <= prohibited_8(X), rexist_8(X).

referTo_8(viol(X),X) <= violation_8(viol(X)).

compensate_8d_8(X) <= compensate_8(Y,X), rexist_8(Y).
exception(violation_8(viol(X)),compensate_8d_8(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_8(X) <= rexist_f_8(X).
licensee_8(X) <= licensee_f_8(X).
licensor_8(X) <= licensor_f_8(X).
product_8(X) <= product_f_8(X).
result_8(X) <= result_f_8(X).
licence_8(X) <= licence_f_8(X).
comment_8(X) <= comment_f_8(X).
isLicenceOf_8(X,Y) <= isLicenceOf_f_8(X,Y).
                
approve_8(X) <= approve_f_8(X).
commission_8(X) <= commission_f_8(X).
evaluate_8(X) <= evaluate_f_8(X).
grant_8(X) <= grant_f_8(X).
publish_8(X) <= publish_f_8(X).
remove_8(X) <= remove_f_8(X).
                
hasAgent_8(X,Y) <= hasAgent_f_8(X,Y).
hasTheme_8(X,Y) <= hasTheme_f_8(X,Y).
hasResult_8(X,Y) <= hasResult_f_8(X,Y).
hasReceiver_8(X,Y) <= hasReceiver_f_8(X,Y).
isCommentOf_8(X,Y) <= isCommentOf_f_8(X,Y).
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted_9 to evaluate the product only with a licence; otherwise, it is prohibited_9.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited_9 for the licencee to evaluate the product

prohibited_9(Ev) <= evaluate_f_9(Ev), hasAgent_f_9(Ev,X), licensee_f_9(X), hasTheme_f_9(Ev,P), product_f_9(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted_9. Art.1b is an exception of Art1.a.
permitted_9(Ev) <= evaluate_f_9(Ev), hasAgent_f_9(Ev,X), licensee_f_9(X), hasTheme_f_9(Ev,P), product_f_9(P), isLicenceOf_f_9(L,P), licence_f_9(L), grant_f_9(Eg), rexist_f_9(Eg), hasTheme_f_9(Eg,L), hasAgent_f_9(Eg,Y), licensor_f_9(Y), hasReceiver_f_9(Eg,X).

exception(prohibited_9(Ev), permitted_9(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted_9 to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited_9. If the licencee publish the results of the evaluation 
% even if this was prohibited_9, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited_9 for the licencee to publish the results of the evaluation of the product
prohibited_9(Ep) <= condition_2_9(Ep,X,R).
condition_2_9(Ep,X,R) <= publish_f_9(Ep), hasAgent_f_9(Ep,X), licensee_f_9(X), hasTheme_f_9(Ep,R), result_f_9(R), hasResult_f_9(Ev,R), evaluate_f_9(Ev), rexist_f_9(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted_9. Art.2b is an exception of Art2.a.
permitted_9(Ep) <= publish_f_9(Ep), hasAgent_f_9(Ep,X), licensee_f_9(X), hasTheme_f_9(Ep,R), result_f_9(R), hasResult_f_9(Ev,R), evaluate_f_9(Ev), rexist_f_9(Ev), approve_f_9(Ea), rexist_f_9(Ea), hasTheme_f_9(Ea,Ep), licensor_f_9(Y), hasAgent_f_9(Ea,Y).

exception(condition_2_9(Ep,X,R),permitted_9(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited_9 to do so, he is obliged to remove them. The removal compensate_9s the violation_9 of the prohibition.
obligatory_9(ca(Ep,X,R)) <= rexist_f_9(Ep), condition_2_9(Ep,X,R).
remove_9(ca(Ep,X,R)) <= rexist_f_9(Ep), condition_2_9(Ep,X,R).
hasTheme_9(ca(Ep,X,R),R) <= rexist_f_9(Ep), condition_2_9(Ep,X,R).
hasAgent_9(ca(Ep,X,R),X) <= rexist_f_9(Ep), condition_2_9(Ep,X,R).
compensate_9(ca(Ep,X,R),Ep) <= rexist_f_9(Ep), condition_2_9(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted_9 to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited_9.
prohibited_9(Ep) <= publish_f_9(Ep), hasAgent_f_9(Ep,X), licensee_f_9(X), hasTheme_f_9(Ep,C), comment_f_9(C), evaluate_f_9(Ev), rexist_f_9(Ev), isCommentOf_f_9(C,Ev).

% Art.3b: if publishing the result is permitted_9, also publishing the comments is permitted_9; this overrides the above prohibition.
permitted_9(Ep) <= publish_f_9(Ep), hasAgent_f_9(Ep,X), licensee_f_9(X), hasTheme_f_9(Ep,C), comment_f_9(C), isCommentOf_f_9(C,Ev), evaluate_f_9(Ev), rexist_f_9(Ev), hasResult_f_9(Ev,R), publish_f_9(Epr), hasAgent_f_9(Epr,X), hasTheme_f_9(Epr,R), permitted_9(Epr).

exception(prohibited_9(Ep),permitted_9(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory_9. Art.4a is an exception of Art2.a.

obligatory_9(Ep) <= publish_f_9(Ep), hasAgent_f_9(Ep,X), licensee_f_9(X), hasTheme_f_9(Ep,R), result_f_9(R), hasResult_f_9(Ev,R), evaluate_f_9(Ev), rexist_f_9(Ev), commission_f_9(Ec), rexist_f_9(Ec), hasTheme_f_9(Ec,Ev).
exception(condition_2_9(Ep,X,R),obligatory_9(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory_9 action x and, at the same time, x does not really exist => violation_9; 
%(2) if there is some prohibited_9 action x and, at the same time, x really exists => violation_9

rexist_9(ca(Ep,X,R)) <= remove_9(ca(Ep,X,R)), hasAgent_9(ca(Ep,X,R),X), hasTheme_9(ca(Ep,X,R),R), rexist_f_9(Er), remove_f_9(Er), hasTheme_f_9(Er,R), hasAgent_f_9(Er,X).

violation_9(viol(X)) <= obligatory_9(X).
-violation_9(viol(X)) <= obligatory_9(X), rexist_9(X).
exception(violation_9(X),-violation_9(X)).

violation_9(viol(X)) <= prohibited_9(X), rexist_9(X).

referTo_9(viol(X),X) <= violation_9(viol(X)).

compensate_9d_9(X) <= compensate_9(Y,X), rexist_9(Y).
exception(violation_9(viol(X)),compensate_9d_9(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist_9(X) <= rexist_f_9(X).
licensee_9(X) <= licensee_f_9(X).
licensor_9(X) <= licensor_f_9(X).
product_9(X) <= product_f_9(X).
result_9(X) <= result_f_9(X).
licence_9(X) <= licence_f_9(X).
comment_9(X) <= comment_f_9(X).
isLicenceOf_9(X,Y) <= isLicenceOf_f_9(X,Y).
                
approve_9(X) <= approve_f_9(X).
commission_9(X) <= commission_f_9(X).
evaluate_9(X) <= evaluate_f_9(X).
grant_9(X) <= grant_f_9(X).
publish_9(X) <= publish_f_9(X).
remove_9(X) <= remove_f_9(X).
                
hasAgent_9(X,Y) <= hasAgent_f_9(X,Y).
hasTheme_9(X,Y) <= hasTheme_f_9(X,Y).
hasResult_9(X,Y) <= hasResult_f_9(X,Y).
hasReceiver_9(X,Y) <= hasReceiver_f_9(X,Y).
isCommentOf_9(X,Y) <= isCommentOf_f_9(X,Y).
