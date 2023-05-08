%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 1: it is permitted to evaluate the product only with a licence; otherwise, it is prohibited.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.1a: it is prohibited for the licencee to evaluate the product

prohibited(Ev) <= evaluate_f(Ev), hasAgent_f(Ev,X), licensee_f(X), hasTheme_f(Ev,P), product_f(P).

% Art.1b: if the licensor grants the licence to the licensee, the evaluation is permitted. Art.1b is an exception of Art1.a.
permitted(Ev) <= evaluate_f(Ev), hasAgent_f(Ev,X), licensee_f(X), hasTheme_f(Ev,P), product_f(P), isLicenceOf_f(L,P), licence_f(L), grant_f(Eg), rexist_f(Eg), hasTheme_f(Eg,L), hasAgent_f(Eg,Y), licensor_f(Y), hasReceiver_f(Eg,X).

exception(prohibited(Ev), permitted(Ev)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 2: it is permitted to publish the results of an evaluation only if the licensor approves it or the evaluation has been
% commissioned. Otherwise, the publishing of the results is prohibited. If the licencee publish the results of the evaluation 
% even if this was prohibited, he is obliged to remove them.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.2a: it is prohibited for the licencee to publish the results of the evaluation of the product
prohibited(Ep) <= condition_2(Ep,X,R).
condition_2(Ep,X,R) <= publish_f(Ep), hasAgent_f(Ep,X), licensee_f(X), hasTheme_f(Ep,R), result_f(R), hasResult_f(Ev,R), evaluate_f(Ev), rexist_f(Ev).

% Art.2b: if the licensor approves the publishing of the results of the evaluation, this is permitted. Art.2b is an exception of Art2.a.
permitted(Ep) <= publish_f(Ep), hasAgent_f(Ep,X), licensee_f(X), hasTheme_f(Ep,R), result_f(R), hasResult_f(Ev,R), evaluate_f(Ev), rexist_f(Ev), approve_f(Ea), rexist_f(Ea), hasTheme_f(Ea,Ep), licensor_f(Y), hasAgent_f(Ea,Y).

exception(condition_2(Ep,X,R),permitted(Ep)).

% Art.2c: if the licensee publishes the result although he is prohibited to do so, he is obliged to remove them. The removal compensates the violation of the prohibition.
obligatory(ca(Ep,X,R)) <= rexist_f(Ep), condition_2(Ep,X,R).
remove(ca(Ep,X,R)) <= rexist_f(Ep), condition_2(Ep,X,R).
hasTheme(ca(Ep,X,R),R) <= rexist_f(Ep), condition_2(Ep,X,R).
hasAgent(ca(Ep,X,R),X) <= rexist_f(Ep), condition_2(Ep,X,R).
compensate(ca(Ep,X,R),Ep) <= rexist_f(Ep), condition_2(Ep,X,R).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 3. The Licensee must not publish comments on the evaluation of the Product,
%            unless the Licensee is permitted to publish the results of the evaluation.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Art.3a: publishing comments about the evaluation is prohibited.
prohibited(Ep) <= publish_f(Ep), hasAgent_f(Ep,X), licensee_f(X), hasTheme_f(Ep,C), comment_f(C), evaluate_f(Ev), rexist_f(Ev), isCommentOf_f(C,Ev).

% Art.3b: if publishing the result is permitted, also publishing the comments is permitted; this overrides the above prohibition.
permitted(Ep) <= publish_f(Ep), hasAgent_f(Ep,X), licensee_f(X), hasTheme_f(Ep,C), comment_f(C), isCommentOf_f(C,Ev), evaluate_f(Ev), rexist_f(Ev), hasResult_f(Ev,R), publish_f(Epr), hasAgent_f(Epr,X), hasTheme_f(Epr,R), permitted(Epr).

exception(prohibited(Ep),permitted(Ep)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Article 4. If the Licensee is commissioned to perform the evaluation, the Licensee is obliged to publish the evaluation results.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Art.4a: if the evaluation has been commissioned, the publishing of the results is obligatory. Art.4a is an exception of Art2.a.

obligatory(Ep) <= publish_f(Ep), hasAgent_f(Ep,X), licensee_f(X), hasTheme_f(Ep,R), result_f(R), hasResult_f(Ev,R), evaluate_f(Ev), rexist_f(Ev), commission_f(Ec), rexist_f(Ec), hasTheme_f(Ec,Ev).
exception(condition_2(Ep,X,R),obligatory(Ep)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% COMPLIANCE CHECKING RULES
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%(1) if there is some obligatory action x and, at the same time, x does not really exist => violation; 
%(2) if there is some prohibited action x and, at the same time, x really exists => violation

rexist(ca(Ep,X,R)) <= remove(ca(Ep,X,R)), hasAgent(ca(Ep,X,R),X), hasTheme(ca(Ep,X,R),R), rexist_f(Er), remove_f(Er), hasTheme_f(Er,R), hasAgent_f(Er,X).

violation(viol(X)) <= obligatory(X).
-violation(viol(X)) <= obligatory(X), rexist(X).
exception(violation(X),-violation(X)).

violation(viol(X)) <= prohibited(X), rexist(X).

referTo(viol(X),X) <= violation(viol(X)).

compensated(X) <= compensate(Y,X), rexist(Y).
exception(violation(viol(X)),compensated(X)).



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ENTAILMENTS PREDICATES <= FACTS 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

rexist(X) <= rexist_f(X).
licensee(X) <= licensee_f(X).
licensor(X) <= licensor_f(X).
product(X) <= product_f(X).
result(X) <= result_f(X).
licence(X) <= licence_f(X).
comment(X) <= comment_f(X).
isLicenceOf(X,Y) <= isLicenceOf_f(X,Y).
                
approve(X) <= approve_f(X).
commission(X) <= commission_f(X).
evaluate(X) <= evaluate_f(X).
grant(X) <= grant_f(X).
publish(X) <= publish_f(X).
remove(X) <= remove_f(X).
                
hasAgent(X,Y) <= hasAgent_f(X,Y).
hasTheme(X,Y) <= hasTheme_f(X,Y).
hasResult(X,Y) <= hasResult_f(X,Y).
hasReceiver(X,Y) <= hasReceiver_f(X,Y).
isCommentOf(X,Y) <= isCommentOf_f(X,Y).