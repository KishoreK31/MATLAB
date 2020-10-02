function clique = max_clique(graph,clique)
    if nargin<2
        clique = [];
    end
    max_clq = clique;
    if isempty(clique)
        for ii = 1:length(graph)
            clq = max_clique(graph,ii)
            if length(clq)> length(max_clq)
                max_clq = clq;
            end
        end
    else
        for node = 1:length(graph)
            if isempty(find(node == clique))
                if check_clique(clique,node,graph)
                    clq = max_clique(graph,[clique node]);
                    if length(clq) > length(max_clq)
                        max_clq = clq;
                    end
                end
            end
        end
    end
    clique = max_clq;
end
function ok = check_clique(clq,node,graph)
    ok = false;
    for ii = length(clq)
        if isempty(find(clq(ii)==graph{node})) || ...
                isempty(find(node == graph{clq(ii)}))
            return;
        end
    end
    ok = true;
end
% unsolved

            