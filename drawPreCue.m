function drawPreCue(loc)
    global stimulus
    
    if stimulus.preCue.type == 0
        if stimulus.oriType == 1
            mglLines2(stimulus.respcueLocation{1}(1), stimulus.respcueLocation{1}(3),...
                stimulus.respcueLocation{1}(2), stimulus.respcueLocation{1}(4),stimulus.respCue.width,stimulus.black);
            mglLines2(stimulus.respcueLocation{2}(1), stimulus.respcueLocation{2}(3),...
                      stimulus.respcueLocation{2}(2), stimulus.respcueLocation{2}(4),stimulus.respCue.width,stimulus.black);
        elseif stimulus.oriType == 2
            mglLines2(stimulus.respcueLocation{3}(1), stimulus.respcueLocation{3}(3),...
                      stimulus.respcueLocation{3}(2), stimulus.respcueLocation{3}(4),stimulus.respCue.width,stimulus.black);
            mglLines2(stimulus.respcueLocation{4}(1), stimulus.respcueLocation{4}(3),...
                      stimulus.respcueLocation{4}(2), stimulus.respcueLocation{4}(4),stimulus.respCue.width,stimulus.black);
        end
    elseif stimulus.preCue.type == 1
        mglLines2(stimulus.respcueLocation{loc}(1), stimulus.respcueLocation{loc}(3),...
                  stimulus.respcueLocation{loc}(2), stimulus.respcueLocation{loc}(4),stimulus.respCue.width,stimulus.black);
    end

end